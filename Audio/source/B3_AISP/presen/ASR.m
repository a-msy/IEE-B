%% 0. Initialization
clear;
rec = audiorecorder(16000, 16, 1);  % 16000 Hz, 16 bit, 1 channel
fft_len = 16384;
result_string_table = {'A', 'I', 'U', 'E', 'O'};

% 1. Load waveform from WAV files
AI_LOAD_WAVEFILES;

%% 2. Convert them to power spectrums
AI_calc_powerspecs;

RESULT = "";

while 1
  pause(1);
  disp('say')
  %% 3. Record an input waveform
  recordblocking(rec, 0.6);
  x = getaudiodata(rec);

  %% 4. Convert the input waveform to power spectrum
  [PowX_dB, PowX] = calc_powerspec(x, fft_len);

  %% 5-1. Calculate distance between the input pattern and every reference patterns
  Dist(1) = sqrt( sum( (PowX_dB(:,1) - A_PowX_dB(:,1) ) .^2 ) );
  Dist(2) = sqrt( sum( (PowX_dB(:,1) - I_PowX_dB(:,1) ) .^2 ) );
  Dist(3) = sqrt( sum( (PowX_dB(:,1) - U_PowX_dB(:,1) ) .^2 ) );
  Dist(4) = sqrt( sum( (PowX_dB(:,1) - E_PowX_dB(:,1) ) .^2 ) );
  Dist(5) = sqrt( sum( (PowX_dB(:,1) - O_PowX_dB(:,1) ) .^2 ) );

  %% 5-2. Select the pattern that has a minimum distance
  [~, idx] = min(Dist);

  %% 6. Display the result stiring!
  RESULT = [RESULT result_string_table{idx}]
end