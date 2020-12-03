% JAN_PLOT_SPECTROGRAMS
% �ꊇ����1���̉摜�Ƃ��ăX�y�N�g���O������\�����邽�߂̃X�N���v�g

% Prepare
x_len = 0.5;   % ���̉����̐M�����i�b�j

subplot(2, 3, 1);
  plot_spectrogram(Jan_Goo1_PowX_dB, x_len, Fs);
  title('Goo 1');

subplot(2, 3, 4);
  plot_spectrogram(Jan_Goo2_PowX_dB, x_len, Fs);
  title('Goo 2');

subplot(2, 3, 2);
  plot_spectrogram(Jan_Chk1_PowX_dB, x_len, Fs);
  title('Chk 1');

subplot(2, 3, 5);
  plot_spectrogram(Jan_Chk2_PowX_dB, x_len, Fs);
  title('Chk 2');

subplot(2, 3, 3);
  plot_spectrogram(Jan_Par1_PowX_dB, x_len, Fs);
  title('Par 1');

subplot(2, 3, 6);
  plot_spectrogram(Jan_Par2_PowX_dB, x_len, Fs);
  title('Par 2');
