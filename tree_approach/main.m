function [  ] = main( )
    PATH = './../records/set-a/';

    f = fopen([PATH 'RECORDS-Myacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);

    acc_res = zeros(1,files_num);
    
    for i=1:files_num
        ECGw = ECGwrapper ('recording_name', [PATH files{i}]);
        acc_res(i)=Acceptable_tree(ECGw);
    end
    
    f = fopen([PATH 'RECORDS-Myunacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
        
    unacc_res = zeros(1,files_num);

    parfor i=1:files_num
        ECGw = ECGwrapper ('recording_name',[PATH files{i}]);
        unacc_res(i)=Acceptable_tree(ECGw);
    end

end

function [ret] = Acceptable_tree (ECGw)
    if (isFlat(ECGw))
       ret = false;
       return ;
    end
    
    if (isSpeak(ECGw))
       ret = false;
       return;
    end
    
    if (isBigStep(ECGw))
       ret = false;
       return;
    end
    
    ret = true;
    
    

end

function [ ret ] = isSpeak (ECGw)
    header = ECGw.ECG_header();
    N= header.nsamp;
    ECG = ECGw.read_signal(1,N);
    
    th= 230.4;  % mV/seg
    per = 0.0423;
    
    th = th* header.gain(1)/header.freq;  %Cuentas/muestras
        
    speaks=sum(abs(diff(ECG))>th)/N;
    ret = all(speaks < per);
end

function [ ret ] = isBigStep (ECGw)
    header = ECGw.ECG_header();
    N= header.nsamp;
    ECG = ECGw.read_signal(1,N);

    ECG = abs(diff(ECG));
    
    MaxEdge = 3; %mV/seg
    MaxEdge = MaxEdge* header.gain(1)/header.freq;  %Cuentas por muestra
    
    ret = any(any(ECG > MaxEdge));
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