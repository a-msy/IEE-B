function frame_x = signal2frame(x, frame_len, fft_len)
% SIGNAL2FRAME  �ϐ� x ��frame_len�̑傫���̃t���[���ɕ������Ė߂��Ă����֐�
%     frame_x= SIGNAL2FRAME(x, frame_len, fft_len)
%     x          �M���i�����g�`�j
%     frame_len  �t���[�����i��������t���[���̐M�����j
%     fft_len    FFT���i�[���l�߂̌v�Z�ɗp����j
%     framed_x   �t���[���������ꂽ�M���i�s��ɂȂ�j

m = 1;        % ������̉��Ԗڂ��C��\���ϐ�
x_idx_st = 1; % x�̂ǂ����番������΂悢���C��\���ϐ�
x_idx_en = x_idx_st + frame_len - 1; % x�̂ǂ��܂łɕ�������΂悢���C��\���ϐ�

while x_idx_en <= length(x)
    frame_x(:, m) = [ x(x_idx_st:x_idx_en); zeros(fft_len-frame_len, 1) ];

    % ���̃��[�v�̏���
    m = m + 1;
    x_idx_st = x_idx_st + frame_len;
    x_idx_en = x_idx_st + frame_len - 1;
end