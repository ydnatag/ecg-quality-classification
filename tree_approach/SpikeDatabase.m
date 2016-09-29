function [] = SpikeDatabase ()
    
    PATH = './../records/set-a/';

    f = fopen([PATH 'RECORDS-unacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
    
    noflat = fopen([PATH 'RECORDS-noflat-unacceptable'],'w');
    
    for i=1:files_num
        record = files{i};
        ECGw = ECGwrapper ('recording_name', [PATH record]);
        if (~isFlat(ECGw))
            fprintf(noflat,'%s\n',record);            
        end
    end


end


function [ ret ] = isFlat (ECGw)
    header = ECGw.ECG_header();
    N= header.nsamp;
    fs = header.freq;
    
    win_size = round(1.5 * fs);  % ventana en muestras (Segundos *fs)
    gain = 1./header.gain;
    ecg = ECGw.read_signal(1,N)*diag(gain); %unidades fisicas (en mV)
    
    dxdt= abs(diff(ecg));
    win_mean_dxdt = filter(ones(1,win_size)/win_size,1,dxdt); % Calculo la media en win_size
    min_win_mean_dxdt = min(min(win_mean_dxdt(win_size:size(win_mean_dxdt,1),:) ));
    
    ret = min_win_mean_dxdt<(0.0017);  % En realidad esto esta mal. Depende de FS!!! No lo estoy considerando en la derivada... fuck my self
end