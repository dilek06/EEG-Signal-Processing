close all; 
clear all; 
clc;
fs = 512; % fs — Sampling frequency, positive scalar. Sampling frequency, specified as a positive scalar. The sampling frequency is the number of samples per unit time. If the unit of time is seconds, the sampling frequency has units of hertz.
T = 1/fs;% sampling rate or frequency
load('C:\Users\Dilek\Desktop\EEG SÝNYAL ÖDEV\hmwk_EEGs.mat') % contains eeg1 and fs
N =length(EEGsig); 
ls = size(EEGsig); % find the length of the data per second
tx =(0:length(EEGsig)-1)/fs;% Make time axis for EEG signal
fx = fs*(0:N/2-1)/N;   %Prepare freq data for plot
figure; 
subplot (211), plot(tx,EEGsig); 
xlabel('Time (s)'), ylabel('Amplitude (uV)'), title('Orjinal EEG sinyali'); %EEG waveform
subplot(212), plot(tx,EEGsig);
xlabel('Time (s)'), ylabel('Amplitude (uV)'), title('Orijinal EEG sinyalini 1 ila 2 saniyesi'), xlim([1,2]) % Used to zoom in on single ECG waveformfigure;
%The mean of the PSDs of xl
mean_EEGsig = mean(EEGsig);
max_value=max(EEGsig);
mean_value=mean(EEGsig);
threshold=(max_value-mean_value)/2;

%Estimate the power spectrum of the 10-s epoch by computing the periodogram
%% this method is slide the window through the entire data at every 1/2 second, calculate the frequency, average it.
[p,f] = pwelch(EEGsig,hamming(fs),.5*fs, 2*fs,fs); %%
figure; subplot(421), plot (f,10*log10(p),'r'); 
xlabel('freq (hz)');
ylabel('PSD Genlik'); 
title('Welch yöntemi ve hamming penceresi aracýlýðýyla SPektral Güç Yoðunluðu');
grid on; 
xlabel('freq (hz)');
ylabel('PSD Amplitude (dB)');
subplot(422), plot (f,10*log10(p),'g'); 
xlabel('freq (hz)');
ylabel('PSD Amplitude (dB)'); 
title('Welchs yöntemiyle Güç SPektral Yoðunluðu, 60 hz de yakýnlaþtýrma'); 
xlim([0,60]);
grid on;
x= EEGsig;
[pxx,f] = periodogram(EEGsig,hamming(length(x)),length(x),fs,'power');
[pwrest,idx] = max(pxx);
fprintf('Maksimum güç %3.1f Hz\n',f(idx));
fprintf('Güç tahmini %2.2f\n',pwrest);
subplot(423), plot(f,10*log10(pxx));
title('Periodogram yöntemi ve hamming penceresi aracýlýðýyla Güç SPektral Yoðunluðu ');
grid on; 
xlabel('freq (hz)');
ylabel('PSD Amplitude (dB)');
subplot(424), plot(f,10*log10(pxx));
title('Periodogram yöntemi ile Güç SPektral Yoðunluðu ve 60 Hzde hamming penceresi yakýnlaþtýrma');
grid on; 
xlabel('freq (hz)');
ylabel('PSD Amplitude (dB)');
xlim([0,60]);
%% low pass filter
lpfLength=127; % Order/Number of Filter coefficients
fc = 30; %% cutoff frequency
Wn=(2*fc)/fs; 
h1=fir1(lpfLength,Wn);
figure; 
plot(h1);
xlabel('Saniye Cinsinden Zaman'); 
ylabel('Büyüklük'); 
title('Low-pass (Alçak Geçirgen) filtresi');
fi = filtfilt(h1,1,EEGsig);
figure; plot(fi); 
title ('filtfilt');
%Compute the Fourier transform
Tr1 = conv(EEGsig,h1);
figure; 
plot(Tr1);