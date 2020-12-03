% JAN_CALC_SPECTROGRAMS
% 一括してスペクトログラムに変換するためのスクリプト

% Prepare
frame_len = 400;  % frame長　16000 * 0.025;
fft_len = 512;

% Process: Goo 1
frame_x = signal2frame(Jan_Goo(:, 1), frame_len, fft_len);
Jan_Goo1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Goo 2
frame_x = signal2frame(Jan_Goo(:, 2), frame_len, fft_len);
Jan_Goo2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Chk 1
frame_x = signal2frame(Jan_Chk(:, 1), frame_len, fft_len);
Jan_Chk1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Chk 2
frame_x = signal2frame(Jan_Chk(:, 2), frame_len, fft_len);
Jan_Chk2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 1
frame_x = signal2frame(Jan_Par(:, 1), frame_len, fft_len);
Jan_Par1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 2
frame_x = signal2frame(Jan_Par(:, 2), frame_len, fft_len);
Jan_Par2_PowX_dB = calc_powerspec(frame_x, fft_len);
