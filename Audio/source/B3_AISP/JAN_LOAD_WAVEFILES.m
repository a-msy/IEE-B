% JAN_LOAD_WAVEFILES.M
% 音声ファイルを読み込むスクリプト
% 変数 Fs には音声ファイルから読み取ったサンプリング周波数が格納される．

%% Load wav files
[Jan_Goo(:, 1), Fs] = audioread('wav/Jan_Goo_1.wav');
Jan_Goo(:, 2) = audioread('wav/Jan_Goo_2.wav');
Jan_Chk(:, 1) = audioread('wav/Jan_Chk_1.wav');
Jan_Chk(:, 2) = audioread('wav/Jan_Chk_2.wav');
Jan_Par(:, 1) = audioread('wav/Jan_Par_1.wav');
Jan_Par(:, 2) = audioread('wav/Jan_Par_2.wav');