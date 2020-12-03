[y, Fs] = audioread('example_1.wav');
sound(y, Fs)
Fs
length(y)
t =  ((1:length(y(:,1))) - 1) / Fs;
plot(y)
xlabel('sample');
ylabel('Signal value');
length(y)/Fs