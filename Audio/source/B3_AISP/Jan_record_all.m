% JAN_RECORD_ALL.M
% じゃんけんの掛け声（グー，チョキ，パー）を録音するためのスクリプト
%
%   See also RECORD_ONESHOT.

%% Jan_Goo_1の収録
disp('***** Say GOO *****')
record_oneshot(0.6, 'wav/Jan_Goo_1.wav');

%% Jan_Chk_1の収録
disp('***** Say CHO-KI *****')
record_oneshot(0.6, 'wav/Jan_Chk_1.wav');

%% Jan_Par_1の収録
disp('***** Say PAR *****')
record_oneshot(0.6, 'wav/Jan_Par_1.wav');

%% Jan_Goo_2の収録
disp('***** Say GOO *****')
record_oneshot(0.6, 'wav/Jan_Goo_2.wav');

%% Jan_Chk_2の収録
disp('***** Say CHO-KI *****')
record_oneshot(0.6, 'wav/Jan_Chk_2.wav');

%% Jan_Par_2の収録
disp('***** Say PAR *****')
record_oneshot(0.6, 'wav/Jan_Par_2.wav');