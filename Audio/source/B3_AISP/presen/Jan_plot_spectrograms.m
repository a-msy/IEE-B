% JAN_PLOT_SPECTROGRAMS
% 一括して1枚の画像としてスペクトログラムを表示するためのスクリプト

% Prepare
x_len = 0.5;   % 元の音声の信号長（秒）

subplot(3, 4, 1);
  plot_spectrogram(A1_PowX_dB, x_len, Fs);
  title('A1');

subplot(3, 4, 2);
  plot_spectrogram(A2_PowX_dB, x_len, Fs);
  title('A2');

subplot(3, 4, 3);
  plot_spectrogram(I1_PowX_dB, x_len, Fs);
  title('I1');

subplot(3, 4, 4);
  plot_spectrogram(I2_PowX_dB, x_len, Fs);
  title('I2');

subplot(3, 4, 5);
  plot_spectrogram(U1_PowX_dB, x_len, Fs);
  title('U1');

subplot(3, 4, 6);
  plot_spectrogram(U2_PowX_dB, x_len, Fs);
  title('U2');

subplot(3, 4, 7);
  plot_spectrogram(E1_PowX_dB, x_len, Fs);
  title('E1');

subplot(3, 4, 8);
  plot_spectrogram(E2_PowX_dB, x_len, Fs);
  title('E2');
  
subplot(3, 4, 9);
  plot_spectrogram(O1_PowX_dB, x_len, Fs);
  title('O1');

subplot(3, 4, 10);
  plot_spectrogram(O2_PowX_dB, x_len, Fs);
  title('O2');