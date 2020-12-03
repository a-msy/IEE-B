function plot_spectrogram(PowX_dB, x_len, Fs)
% PLOT_SPECTROGRAM  PowX_dB���X�y�N�g���O�����Ƃ��ĕ\������֐�
%     PowX_dB    �t���[�����Ƃ̃p���[�X�y�N�g���i�j
%     x_len      ���̐M�����i�b�P�ʁj
%     Fs         �T���v�����O���g���iHz�P�ʁj

[f_num, t_num] = size(PowX_dB);
t = linspace(0, x_len, t_num);    % x_len�͐M�����i0.5�b�j
f = linspace(0, Fs/2, f_num);     % Fs�̓T���v�����O���g�� (16,000Hz)

% Plot: �\�������܂����̏ꍇ�͑�4�����̐�����ς��ĐF�ɑ΂��鋭���̃����W�𒲐�����
imagesc(t, f, PowX_dB, [-90 -10]); set(gca, 'YDir', 'normal');
  % ���邢�́Csurf(t, f, PowX_dB);

xlabel('Time [s]');
ylabel('Frequency [Hz]');
colorbar

end