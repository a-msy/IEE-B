%% Generate sinusoidal (pure tone) waveform
signal_length_sec = 0.8;   % Signal length [sec]
sampling_rate = 16000;     % Sampling frequency [Hz]

[yuuki,Fs] = audioread('yuuki.wav');
my = audioread('my.wav');

% Prepare
frame_len = 400;  % frame長　16000 * 0.025;
fft_len = 256;

% Process: Goo 1
frame_x = signal2frame(yuuki, frame_len, fft_len);
yuuki_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Goo 2
frame_x = signal2frame(my, frame_len, fft_len);
my_PowX_dB = calc_powerspec(frame_x, fft_len);

% Prepare
x_len = signal_length_sec;   % 元の音声の信号長（秒）

subplot(1, 2, 1);
  plot_spectrogram(yuuki_PowX_dB, x_len, Fs);
  title('yuuki');
  ylim([0 4000]);

subplot(1, 2, 2);
  plot_spectrogram(my_PowX_dB, x_len, Fs);
  title('my');
  ylim([0 4000]);