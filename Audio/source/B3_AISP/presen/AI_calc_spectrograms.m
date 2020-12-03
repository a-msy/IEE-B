% JAN_CALC_SPECTROGRAMS
% 一括してスペクトログラムに変換するためのスクリプト

% Prepare
frame_len = 400;  % frame長　16000 * 0.025;
fft_len = 512;

% Process: Goo 1
frame_x = signal2frame(A(:, 1), frame_len, fft_len);
A1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Goo 2
frame_x = signal2frame(A(:, 2), frame_len, fft_len);
A2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Chk 1
frame_x = signal2frame(I(:, 1), frame_len, fft_len);
I1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Chk 2
frame_x = signal2frame(I(:, 2), frame_len, fft_len);
I2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 1
frame_x = signal2frame(U(:, 1), frame_len, fft_len);
U1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 2
frame_x = signal2frame(U(:, 2), frame_len, fft_len);
U2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 1
frame_x = signal2frame(E(:, 1), frame_len, fft_len);
E1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 2
frame_x = signal2frame(E(:, 2), frame_len, fft_len);
E2_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 1
frame_x = signal2frame(O(:, 1), frame_len, fft_len);
O1_PowX_dB = calc_powerspec(frame_x, fft_len);

% Process: Par 2
frame_x = signal2frame(O(:, 2), frame_len, fft_len);
O2_PowX_dB = calc_powerspec(frame_x, fft_len);
