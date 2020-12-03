[x,fs] = audioread('my.wav');
y = pitchShift(x(:,1),1024,128,18);
sound(y, fs);