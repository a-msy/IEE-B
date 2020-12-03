% JAN_PLOT_POWERSPECS.M
% Jan_calc_powerspecsで計算したパワースペクトルを表示するプログラム

% Prepare
f_k = linspace(0, Fs/2, fft_len/2+1);  % Fsはload_wavefilesで読み込まれているはずのサンプリング周波数 (16,000Hz)

% Plot: Goo
subplot(5, 1, 1);
  plot(f_k, A_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('a1', 'a2');
  ylim([-120 -20]);

% Plot: Chk
subplot(5, 1, 2);
  plot(f_k, I_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('i1', 'i2');
  ylim([-120 -20]);

% Plot: Par
subplot(5, 1, 3);
  plot(f_k, U_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('u1', 'u2');
  ylim([-120 -20]);
  
  % Plot: Par
subplot(5, 1, 4);
  plot(f_k, E_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('e1', 'e2');
  ylim([-120 -20]);
  
  % Plot: Par
subplot(5, 1, 5);
  plot(f_k, O_PowX_dB);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  legend('o1', 'o2');
  ylim([-120 -20]);