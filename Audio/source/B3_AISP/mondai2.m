signal_length_sec = 0.6;
sampling_rate = 16000;
A = 0.2;    % Amplitude
f = 10;     % Frequency [Hz]

signal_length_pt = signal_length_sec * sampling_rate
t =  ((1:signal_length_pt) - 1) / sampling_rate;
x = A * sin(2 * pi * f * t)';

%plot(t, x);

%DFT
X = fft(x) / length(x);
XPow = abs(X) .^ 2;
%plot(XPow, 'o-');
%xlim([1 10]) %plot array index from 1 to 10

f_k = linspace(0, sampling_rate, signal_length_pt+1);  % 16000を9600+1分割した配列
f_k(end) = [];% 最後消す
XPow((2+signal_length_pt/2):end) = [];% 折り返した後半を消して片側のみ
f_k = linspace(0, sampling_rate/2, 1+signal_length_pt/2);%等分割
plot(f_k, XPow);
xlabel('Frequency [Hz]');
%xlim([1 20]) %plot array index from 1 to 10