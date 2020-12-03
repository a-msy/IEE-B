signal_length_sec = 0.6;
sampling_rate = 16000;
A = 0.2;    % Amplitude
f = 1000;     % Frequency [Hz]

signal_length_pt = signal_length_sec * sampling_rate;
t =  ((1:signal_length_pt) - 1) / sampling_rate;
x = A * sin(2 * pi * f * t)';
plot(x);
disp("play sound");
sound(x, sampling_rate);
disp("end");