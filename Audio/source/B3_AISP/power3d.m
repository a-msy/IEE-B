%% Generate sinusoidal (pure tone) waveform
signal_length_sec = 1.0;   % Signal length [sec]
sampling_rate = 16000;     % Sampling frequency [Hz]
A = 0.5;                   % Amplitude
f = 1000;                  % Frequency of pure tone [Hz]

signal_length_pt = signal_length_sec * sampling_rate;
t =  ((1:signal_length_pt) - 1) / sampling_rate;

x = A * sin(2 * pi * f * t)';     % "x" is a sinusoidal waveform.

% �M������16000�_�̐M��x���C800�_���ɕ������C�O���������Ă���ϐ�frame_x�̒��ɍs��̌`�Ŋi�[����

%% �t���[���������i��{�j
frame_len = 800;   % �p�����[�^�F�t���[����
fft_len   = 1024;  % �p�����[�^�FFFT��   <-- new!!

m = 1;        % ������̉��Ԗڂ��C��\���ϐ�
x_idx_st = 1; % x�̂ǂ����番������΂悢���C��\���ϐ�
x_idx_en = x_idx_st + frame_len - 1; % x�̂ǂ��܂łɕ�������΂悢���C��\���ϐ�

while x_idx_en <= length(x)
    % frame_x(:, m) = x(x_idx_st:x_idx_en);
    % ��̂܂܂ł�frame_len��800�_����frame_x�ɑ��݂��Ȃ��̂ŁE�E�E
    % frame_len = 800�_�̃f�[�^�̌��ɁC
    % 1024 - frame_len = 224�_�̃[�����Ȃ��邱�ƂŁC ����1024�̃x�N�g����frame_x�̒��Ɋi�[����Ă�������
    
    frame_x(:, m) = [ x(x_idx_st:x_idx_en); zeros(1024-frame_len, 1) ];   
    % Framing with Zero-padding

    % ���̃��[�v�̏���
    m = m + 1;
    x_idx_st = x_idx_st + frame_len;
    x_idx_en = x_idx_st + frame_len - 1;
end

X = fft(frame_x, fft_len) / fft_len; % �e�t���[���̐M���ɑ΂���FFT�̌��ʂƂ��āC1024x20�̕��f���̍s��X
Pow_X = abs(X) .^ 2; % 20��FFT�̌��ʂ��C20�̃p���[�X�y�N�g���ɕϊ�
Pow_X((2+fft_len/2):end, :) = [];  % ��납��(����-1)���������O����(����+1)�𐶂��� �Б���
Pow_X_dB = 10 * log10(Pow_X);% �ΐ���

[f_num, t_num] = size(Pow_X_dB);
t = linspace(0, signal_length_sec, sampling_rate);    % �M�����i1.0�b�j
f = linspace(0, sampling_rate/2, f_num);     % �T���v�����O���g�� (16,000Hz)
imagesc(t,f,Pow_X_dB);

set(gca, 'YDir', 'normal');
caxis([-70 -20])
colorbar
xlabel('Time[sec]');
ylabel('Frequency');
