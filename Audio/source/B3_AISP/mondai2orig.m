signal_length_sec = 1.0;
sampling_rate = 16000;
A = 0.2;    % Amplitude
f = 5000;     % Frequency [Hz]

signal_length_pt = signal_length_sec * sampling_rate
t =  ((1:signal_length_pt) - 1) / sampling_rate;
x = A * sin(2 * pi * f * t)';

%plot(t, x);

%DFT
X = fft(x) / length(x);
XPow = abs(X) .^ 2;
plot(XPow, 'o-');
%xlim([1 10]) %plot array index from 1 to 10