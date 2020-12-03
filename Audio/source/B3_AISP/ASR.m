%% 0. Initialization
clear;
rec = audiorecorder(16000, 16, 1);  % 16000 Hz, 16 bit, 1 channel
fft_len = 16384;
result_string_table = {'Goo', 'Chk', 'Par'};

% 1. Load waveform from WAV files
JAN_LOAD_WAVEFILES;

%% 2. Convert them to power spectrums
Jan_calc_powerspecs;

%% 3. Record an input waveform
disp('3'); pause(1); disp('2'); pause(1); disp('1'); pause(1); disp('Go!'); % count down
recordblocking(rec, 0.6);
x = getaudiodata(rec);

%% 4. Convert the input waveform to power spectrum
[PowX_dB, PowX] = calc_powerspec(x, fft_len);

%% 5-1. Calculate distance between the input pattern and every reference patterns
Dist(1) = sqrt( sum( (PowX_dB(:,1) - Jan_Goo_PowX_dB(:,1) ) .^2 ) );
Dist(2) = sqrt( sum( (PowX_dB(:,1) - Jan_Chk_PowX_dB(:,1) ) .^2 ) );
Dist(3) = sqrt( sum( (PowX_dB(:,1) - Jan_Par_PowX_dB(:,1) ) .^2 ) );
disp(Dist) % for debug

%% 5-2. Select the pattern that has a minimum distance
[~, idx] = min(Dist);

%% 6. Display the result stiring!
disp(result_string_table{idx});

%% X. Debug plots
t = ((1:length(x)) - 1) / rec.SampleRate;
f_k = linspace(0, rec.SampleRate/2, fft_len/2+1);
% Plot waveform
subplot(3, 2, [1 3 5]);
  plot(t, x);
  title(['Input waveform']);
  xlabel('Time [s]'); ylabel('Signal value');
  ylim([-1 1]);
% Plot spectrums
subplot(3, 2, 2);
  plot(f_k, [PowX_dB(:,1) Jan_Goo_PowX_dB(:,1)]);
  title(['Input and GOO: Dist = ' num2str(Dist(1))]);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  %ylim([-120 -20]);
subplot(3, 2, 4);
  plot(f_k, [PowX_dB(:,1) Jan_Chk_PowX_dB(:,1)]);
  title(['Input and CHK: Dist = ' num2str(Dist(2))]);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  %ylim([-120 -20]);
subplot(3, 2, 6);
  plot(f_k, [PowX_dB(:,1) Jan_Par_PowX_dB(:,1)]);
  title(['Input and PAR: Dist = ' num2str(Dist(3))]);
  xlabel('Frequency [Hz]'); ylabel('Power [dB]');
  %ylim([-120 -20]);