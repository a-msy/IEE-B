% JAN_PLOT_SPECTROGRAMS
% 一括して1枚の画像としてスペクトログラムを表示するためのスクリプト

% Prepare
x_len = 0.5;   % 元の音声の信号長（秒）

subplot(2, 3, 1);
  plot_spectrogram(Jan_Goo1_PowX_dB, x_len, Fs);
  title('Goo 1');

subplot(2, 3, 4);
  plot_spectrogram(Jan_Goo2_PowX_dB, x_len, Fs);
  title('Goo 2');

subplot(2, 3, 2);
  plot_spectrogram(Jan_Chk1_PowX_dB, x_len, Fs);
  title('Chk 1');

subplot(2, 3, 5);
  plot_spectrogram(Jan_Chk2_PowX_dB, x_len, Fs);
  title('Chk 2');

subplot(2, 3, 3);
  plot_spectrogram(Jan_Par1_PowX_dB, x_len, Fs);
  title('Par 1');

subplot(2, 3, 6);
  plot_spectrogram(Jan_Par2_PowX_dB, x_len, Fs);
  title('Par 2');
