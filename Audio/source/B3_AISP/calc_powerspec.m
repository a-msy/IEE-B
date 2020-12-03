function [PowX_dB, PowX] = calc_powerspec(signal, fft_len)
% CALC_POWERSPEC  音声データから（片側）パワースペクトルを計算する関数
%   PowX_dB = CALC_POWERSPEC(signal, fft_len)
%   [PowX_dB, PowX] = CALC_POWERSPEC(signal, fft_len)
%       signal   ... 音声データ
%       fft_len  ... FFT長
%       PowX     ... （片側）パワースペクトル
%       PowX_dB  ... （片側対数）パワースペクトル（dB単位）

X = fft(signal, fft_len) / fft_len;
%X = fft(signal, fft_len);
PowX = abs(X).^2;
PowX((2+fft_len/2):end, :) = [];  % PowXの後半分-1を消す＝前半分+1を生かす
PowX_dB = 10 * log10(PowX);
end