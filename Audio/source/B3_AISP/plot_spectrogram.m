function plot_spectrogram(PowX_dB, x_len, Fs)
% PLOT_SPECTROGRAM  PowX_dBをスペクトログラムとして表示する関数
%     PowX_dB    フレームごとのパワースペクトル（）
%     x_len      元の信号長（秒単位）
%     Fs         サンプリング周波数（Hz単位）

[f_num, t_num] = size(PowX_dB);
t = linspace(0, x_len, t_num);    % x_lenは信号長（0.5秒）
f = linspace(0, Fs/2, f_num);     % Fsはサンプリング周波数 (16,000Hz)

% Plot: 表示がいまいちの場合は第4引数の数字を変えて色に対する強さのレンジを調整する
imagesc(t, f, PowX_dB, [-90 -10]); set(gca, 'YDir', 'normal');
  % あるいは，surf(t, f, PowX_dB);

xlabel('Time [s]');
ylabel('Frequency [Hz]');
colorbar

end