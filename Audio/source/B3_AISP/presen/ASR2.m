%% 0. Initialization
clear;
rec = audiorecorder(16000, 16, 1);  % 16000 Hz, 16 bit, 1 channel
fft_len = 16384;
result_string_table = {'Goo', 'Chk', 'Par'};

% 1. Load waveform from WAV files
JAN_LOAD_WAVEFILES;

%% 2. Convert them to power spectrums
Jan_calc_powerspecs;

pararent_files = {'1','2'};
filenames = {'/Jan_Goo_1.wav','/Jan_Goo_2.wav','/Jan_Chk_1.wav','/Jan_Chk_2.wav','/Jan_Par_1.wav','/Jan_Par_2.wav'};

for k = 1:length(pararent_files)
    for i = 1:length(filenames)

      filename = strcat(strcat(pararent_files(k)),filenames(i));
      x = audioread(char(filename));

      %% 4. Convert the input waveform to power spectrum
      [PowX_dB, PowX] = calc_powerspec(x, fft_len);

      %% 5-1. Calculate distance between the input pattern and every reference patterns
      Dist(1) = sqrt( sum( (PowX_dB(:,1) - Jan_Goo_PowX_dB(:,1) ) .^2 ) );
      Dist(2) = sqrt( sum( (PowX_dB(:,1) - Jan_Chk_PowX_dB(:,1) ) .^2 ) );
      Dist(3) = sqrt( sum( (PowX_dB(:,1) - Jan_Par_PowX_dB(:,1) ) .^2 ) );
      disp(Dist); % for debug

      %% 5-2. Select the pattern that has a minimum distance
      [~, idx] = min(Dist);

      %% 6. Display the result stiring!
      disp(result_string_table{idx});
    end
end