%% Load wav files
[A(:, 1), Fs] = audioread('wav/a_1.wav');
A(:, 2) = audioread('wav/a_2.wav');
I(:, 1) = audioread('wav/i_1.wav');
I(:, 2) = audioread('wav/i_2.wav');
U(:, 1) = audioread('wav/u_1.wav');
U(:, 2) = audioread('wav/u_2.wav');
E(:, 1) = audioread('wav/e_1.wav');
E(:, 2) = audioread('wav/e_2.wav');
O(:, 1) = audioread('wav/o_1.wav');
O(:, 2) = audioread('wav/o_2.wav');