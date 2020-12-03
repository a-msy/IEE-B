% JAN_CALC_POWERSPECS.M
% load_wavefilesで読み込んだ音声データからパワースペクトルを計算するプログラム

% Prepare
fft_len = 16384;      % Why 16384?  -> see Chapter 3

% Process: Goo
[A_PowX_dB, A_PowX] = calc_powerspec(A(:, 1:2), fft_len);

% Process: Chk
[I_PowX_dB, I_PowX] = calc_powerspec(I(:, 1:2), fft_len);

% Process: Par
[U_PowX_dB, U_PowX] = calc_powerspec(U(:, 1:2), fft_len);

% Process: Par
[E_PowX_dB, E_PowX] = calc_powerspec(E(:, 1:2), fft_len);

% Process: Par
[O_PowX_dB, O_PowX] = calc_powerspec(O(:, 1:2), fft_len);