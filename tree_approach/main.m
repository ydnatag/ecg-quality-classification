function [  ] = main( )
    PATH = './../records/set-a/';

    f = fopen([PATH 'RECORDS-Myacceptable']);
    acc_files = textscan(f,'%s');
    fclose(f);
    acc_files = acc_files{1};
    acc_files_num= size(acc_files,1);

    acc_res = zeros(1,acc_files_num);
    acc_noise = zeros(1,acc_files_num);
    
    parfor i=1:acc_files_num
        ECGw = ECGwrapper ('recording_name', [PATH acc_files{i}]);
        acc_res(i)=Acceptable_tree(ECGw);
        acc_noise(i) = isNoisy(ECGw);
        if (acc_res(i)==0)
            acc_noise(i) = isNoisy(ECGw);
        end
        fprintf('Acc: Archivo numero %d: %d\n',i,acc_res(i));
    end
    
    f = fopen([PATH 'RECORDS-Myunacceptable']);
    unacc_files = textscan(f,'%s');
    fclose(f);
    unacc_files = unacc_files{1};
    unacc_files_num= size(unacc_files,1);
        
    unacc_res = zeros(1,unacc_files_num);
    unacc_noise = zeros(1,unacc_files_num);

    parfor i=1:unacc_files_num
        ECGw = ECGwrapper ('recording_name',[PATH unacc_files{i}]);
        unacc_res(i)=Acceptable_tree(ECGw);
        if (unacc_res(i)==0)
            unacc_noise(i) = isNoisy(ECGw);
        end
        fprintf('Unacc: Archivo numero %d: %d\n',i,unacc_res(i));
    end
    
    cant_acc = length(acc_res);
    tp = sum(acc_res==0);
    fn =  cant_acc-tp;

    fprintf('Aceptables: \n\tTotal:%d  \n\tDetectados:%d  \n\tErrados:%d  \n\tPorcentaje:%.3f\n', ...
            cant_acc, ...
            tp, ... 
            fn,...
            (tp/cant_acc)*100);

    cant_unacc = length(unacc_res);
    tn = sum(unacc_res~=0) ;
    fp =  cant_unacc-tn;

    fprintf('Inaceptables: \n\tTotal:%d  \n\tDetectados:%d  \n\tErrados:%d  \n\tPorcentaje:%.3f\n', ...
            cant_unacc, ...
            tn, ...
            fp, ...
            (tn/cant_unacc)*100);
    save('./../results/tree/results.mat','acc_files','acc_res','unacc_files','unacc_res');
end

function [ret] = Acceptable_tree (ECGw)
    if (isFlat(ECGw))
       ret = -1;
       return ;
    end
    
    if (isSpeak(ECGw))
       ret = -2;
       return;
    end
    
    if (isBigStep(ECGw))
       ret = -3;
       return;
    end
    
    ret = 0;
    
    

end

function [ ret ] = isNoisy (ECGw)
    h = ECGw.ECG_header();
    N= h.nsamp;
    ECG = ECGw.read_signal(1,N);
    [evec eval]=autovec_calculation(ECG);
    ret = sum(eval(1:4))/sum(eval);
end


function [ ret ] = isSpeak (ECGw)
    header = ECGw.ECG_header();
    N= header.nsamp;
    ECG = ECGw.read_signal(1,N);
    
    th= 230.4;  % mV/seg
    per = 0.0423;
    
    th = th* header.gain(1)/header.freq;  %Cuentas/muestras
        
    speaks=sum(abs(diff(ECG))>th)/N;
    ret = any(speaks > per);
end

function [ ret ] = isBigStep (ECGw)
    header = ECGw.ECG_header();
    N= header.nsamp;
    ECG = ECGw.read_signal(1,N);

    ECG = abs(diff(ECG));
    
    MaxEdge = 2000; %mV/seg
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
