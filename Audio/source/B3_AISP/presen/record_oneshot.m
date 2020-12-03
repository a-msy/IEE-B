function record_oneshot(wav_length, wav_filename)
% RECORD_ONESHOT  カウントダウンをしつつ音を録音して�?��したファイルに書き�?す関数
%   RECORD_ONESHOT(wav_length, wav_filename)
%       wav_length秒�?音�??タを録音して?�wav_filenameと�?��名前のファイルに音�??タを保存す�?

% Initialize audiorecorder
rec = audiorecorder(16000, 16, 1);  % 16000 Hz, 16 bit, 1 channel

% Count down
disp('3'); pause(1); disp('2'); pause(1); disp('1'); pause(1);
disp('Go!');

% Start recording
recordblocking(rec, wav_length);

% Get data and save it.
x = getaudiodata(rec);
audiowrite(wav_filename, x, rec.SampleRate);

% Debug
% plot(x);
sound(x, rec.SampleRate)

end