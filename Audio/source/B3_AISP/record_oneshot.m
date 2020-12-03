function record_oneshot(wav_length, wav_filename)
% RECORD_ONESHOT  カウントダウンをしつつ音を録音して指定したファイルに書き出す関数
%   RECORD_ONESHOT(wav_length, wav_filename)
%       wav_length秒の音データを録音して，wav_filenameという名前のファイルに音データを保存する

% Initialize audiorecorder
rec = audiorecorder(16000, 16, 1);  % 16000 Hz, 16 bit, 1 channel

% Count down
disp('3'); pause(1); disp('2'); pause(1); disp('1'); pause(1);
disp('Go!');pause(1);

% Start recording
recordblocking(rec, wav_length);

% Get data and save it.
x = getaudiodata(rec);
audiowrite(wav_filename, x, rec.SampleRate);

% Debug
% plot(x);
sound(x, rec.SampleRate)

end