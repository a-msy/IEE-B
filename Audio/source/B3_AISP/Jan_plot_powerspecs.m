% JAN_PLOT_POWERSPECS.M
% Jan_calc_powerspecsで計算したパワースペクトルを表示するプログラム

% Prepare
f_k = linspace(0, Fs/2, fft_len/2+1);  % Fsはload_wavefilesで読み込まれているはずのサンプリング周波数 (16,000Hz)

% Plot: Goo
subplot(3, 1, 1);
  plot(f_k, Jan_Goo_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('Goo 1', 'Goo 2');
  ylim([-120 -20]);

% Plot: Chk
subplot(3, 1, 2);
  plot(f_k, Jan_Chk_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('Choki 1', 'Choki 2');
  ylim([-120 -20]);

% Plot: Par
subplot(3, 1, 3);
  plot(f_k, Jan_Par_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('Par 1', 'Par 2');
  ylim([-120 -20]);