%% Generate sinusoidal (pure tone) waveform
signal_length_sec = 1.0;   % Signal length [sec]
sampling_rate = 16000;     % Sampling frequency [Hz]
A = 0.5;                   % Amplitude
f = 1000;                  % Frequency of pure tone [Hz]

signal_length_pt = signal_length_sec * sampling_rate;
t =  ((1:signal_length_pt) - 1) / sampling_rate;

x = A * sin(2 * pi * f * t)';     % "x" is a sinusoidal waveform.

% 信号長が16000点の信号xを，800点ずつに分割し，前処理をしてから変数frame_xの中に行列の形で格納する

%% フレーム化処理（基本）
frame_len = 800;   % パラメータ：フレーム長
fft_len   = 1024;  % パラメータ：FFT長   <-- new!!

m = 1;        % 分割後の何番目か，を表す変数
x_idx_st = 1; % xのどこから分割すればよいか，を表す変数
x_idx_en = x_idx_st + frame_len - 1; % xのどこまでに分割すればよいか，を表す変数

while x_idx_en <= length(x)
    % frame_x(:, m) = x(x_idx_st:x_idx_en);
    % 上のままではframe_lenの800点しかframe_xに存在しないので・・・
    % frame_len = 800点のデータの後ろに，
    % 1024 - frame_len = 224点のゼロをつなげることで， 長さ1024のベクトルがframe_xの中に格納されていく操作
    
    frame_x(:, m) = [ x(x_idx_st:x_idx_en); zeros(1024-frame_len, 1) ];   
    % Framing with Zero-padding

    % 次のループの準備
    m = m + 1;
    x_idx_st = x_idx_st + frame_len;
    x_idx_en = x_idx_st + frame_len - 1;
end

X = fft(frame_x, fft_len) / fft_len; % 各フレームの信号に対するFFTの結果として，1024x20の複素数の行列X
Pow_X = abs(X) .^ 2; % 20個のFFTの結果を，20個のパワースペクトルに変換
Pow_X((2+fft_len/2):end, :) = [];  % 後ろから(半分-1)個を消す＝前から(半分+1)個を生かす 片側化
Pow_X_dB = 10 * log10(Pow_X);% 対数化

[f_num, t_num] = size(Pow_X_dB);
t = linspace(0, signal_length_sec, sampling_rate);    % 信号長（1.0秒）
f = linspace(0, sampling_rate/2, f_num);     % サンプリング周波数 (16,000Hz)
imagesc(t,f,Pow_X_dB);

set(gca, 'YDir', 'normal');
caxis([-70 -20])
colorbar
xlabel('Time[sec]');
ylabel('Frequency');
