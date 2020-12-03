%% Generate sinusoidal (pure tone) waveform
signal_length_sec = 0.8;   % Signal length [sec]
sampling_rate = 16000;     % Sampling frequency [Hz]
fft_len = 16384;      % Why 16384?  -> see Chapter 3

[yuuki,Fs] = audioread('yuuki.wav');
my = audioread('my.wav');

[temp_PowX_dB, temp_PowX] = calc_powerspec([yuuki(:,1),my(:,1)], fft_len);
% Prepare
f_k = linspace(0, sampling_rate/2, fft_len/2+1);
plot(f_k, temp_PowX_dB);
xlabel('Frequency [Hz]'); ylabel('Power [dB]');
ylim([-120 -20]);