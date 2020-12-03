function [PowX_dB, PowX] = calc_powerspec(signal, fft_len)
% CALC_POWERSPEC  �����f�[�^����i�Б��j�p���[�X�y�N�g�����v�Z����֐�
%   PowX_dB = CALC_POWERSPEC(signal, fft_len)
%   [PowX_dB, PowX] = CALC_POWERSPEC(signal, fft_len)
%       signal   ... �����f�[�^
%       fft_len  ... FFT��
%       PowX     ... �i�Б��j�p���[�X�y�N�g��
%       PowX_dB  ... �i�Б��ΐ��j�p���[�X�y�N�g���idB�P�ʁj

X = fft(signal, fft_len) / fft_len;
%X = fft(signal, fft_len);
PowX = abs(X).^2;
PowX((2+fft_len/2):end, :) = [];  % PowX�̌㔼��-1���������O����+1�𐶂���
PowX_dB = 10 * log10(PowX);
end