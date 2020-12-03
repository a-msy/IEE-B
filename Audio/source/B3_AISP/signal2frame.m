function frame_x = signal2frame(x, frame_len, fft_len)
% SIGNAL2FRAME  変数 x をframe_lenの大きさのフレームに分割して戻してくれる関数
%     frame_x= SIGNAL2FRAME(x, frame_len, fft_len)
%     x          信号（音声波形）
%     frame_len  フレーム長（分割するフレームの信号長）
%     fft_len    FFT長（ゼロ詰めの計算に用いる）
%     framed_x   フレーム分割された信号（行列になる）

m = 1;        % 分割後の何番目か，を表す変数
x_idx_st = 1; % xのどこから分割すればよいか，を表す変数
x_idx_en = x_idx_st + frame_len - 1; % xのどこまでに分割すればよいか，を表す変数

while x_idx_en <= length(x)
    frame_x(:, m) = [ x(x_idx_st:x_idx_en); zeros(fft_len-frame_len, 1) ];

    % 次のループの準備
    m = m + 1;
    x_idx_st = x_idx_st + frame_len;
    x_idx_en = x_idx_st + frame_len - 1;
end