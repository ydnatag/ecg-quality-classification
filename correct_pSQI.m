function [ ] = correct_pSQI( dataset )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    PATH = ['./results/' dataset '/'];

    if ( exist(['./records/' dataset '/RECORDS-unacceptable'],'file') )
        f = fopen(['./records/' dataset '/RECORDS-unacceptable']);
        files = textscan(f,'%s');
        fclose(f);
    else
        error('No existe el archivo');
    end
    
    files = files{1}';
    files= strcat([PATH 'sqi_'],files);
    files= strcat(files,'.mat');
    
    
    for i=1:size(files,2)
        load(files{i});
        wrapper = ECGwrapper ('recording_name', ['./records/' dataset '/' file]);
     
        N= wrapper.ECG_header.nsamp;
        signal = wrapper.read_signal(1,N);
        header = wrapper.ECG_header();
        fs = header.freq;

        fft_signal = abs(fft(signal));
        P_fft_signal = (fft_signal/N).^2;

        f = 0:fs/N:(N-1)*(fs/N);
        t = 0: 1/fs : (N-1)/fs;

        %% pSQI
        sqi.pSQI = calc_pSQI(f,P_fft_signal);
        save(files{i},'file','sqi','acceptable');
    end
    

end

