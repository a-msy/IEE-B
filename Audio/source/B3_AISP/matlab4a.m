rec = audiorecorder(16000, 16, 1); 
recordblocking(rec, 2.0);
rec.SampleRate
x = getaudiodata(rec);
x
% tatebekutoru
sound(x,rec.SampleRate)