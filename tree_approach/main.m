function [  ] = main( )
    addpath('./../');
    PATH = './../records/set-a/';
    
    global sqi_list;
    global model;
    
    reduced = { 'kSQI' 'sSQI' 'pSQI' 'basSQI' 'bSQI2' 'pcaSQI' }; 
    full = { 'pSQI' 'basSQI' 'bsSQI' 'eSQI' 'hfSQI' 'bSQI2' 'sSQI' 'kSQI' 'rsdSQI' 'purSQI' 'entSQI' 'pcaSQI' };
    sqi_list = reduced;
    model = train_model(sqi_list);
    
    acc_res = proc_RECORDS([PATH 'RECORDS-Myacceptable']);
    unacc_res= proc_RECORDS([PATH 'RECORDS-Myunacceptable']);
    
    
    tp = sum(acc_res)
    tn = sum(~(unacc_res))
    fn = sum(~(acc_res))
    fp = sum(unacc_res)
    Accuracy = (tp+tn)/(tp+tn+fp+fn)
    Sensitivity = tp/(tp+fn)
    Specificity = tn/(tn+fp)
    
end

function [res] = proc_RECORDS ( RECORDS_file)
    PATH = [fileparts(RECORDS_file) '/'];
    f = fopen(RECORDS_file);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);

    res = zeros(1,files_num);
       
    for i=1:files_num
        ECGw = ECGwrapper ('recording_name', [PATH files{i}]);
        res(i)=Acceptable_tree(ECGw);
    end
   
end

function [ret] = Acceptable_tree (ECGw)
    
    global sqi_list;
    global model;
%      if (isFlat(ECGw))
%        ret = false;
%        return ;
%     end
%     if (isSpeak(ECGw))
%        ret = false;
%        return;
%     end   
%         
%    
%     if (isBigStep(ECGw))
%        ret = false;
%        return;
%     end
 
     ret = true;
%    
    if (size(sqi_list))
        [~,name]= fileparts(ECGw.recording_name);
        features = load(['./../results/set-a/sqi_' name]);
        features.sqi = nan_correction(features.sqi);
        features = struct2table(features.sqi);
        features = features(1,sqi_list);
        ret = predict (model,table2array(features));
    end
%     
    
    

end

function [sqi] = nan_correction(sqi)
    for i=1:numel(sqi)
        sqi(i).sSQI(isnan(sqi(i).sSQI))= 0;%realmax;%0;
        sqi(i).kSQI(isnan(sqi(i).kSQI))= 0;%realmax;%0;
        sqi(i).purSQI(isnan(sqi(i).purSQI))=0;%realmax;%0;
        sqi(i).hfSQI(isnan(sqi(i).hfSQI))=0;%realmax;
        sqi(i).bsSQI(isnan(sqi(i).bsSQI))=0;%realmax;
        sqi(i).pcaSQI(isnan(sqi(i).pcaSQI))=0;%realmax;%1;
        sqi(i).robpcaSQI(isnan(sqi(i).robpcaSQI))=0;%realmax;%1;
        sqi(i).entSQI(isnan(sqi(i).entSQI))=0;%realmax;%0;
        sqi(i).entSQI(isinf(sqi(i).entSQI))=0;%realmax;
    end
end

function [ ret ] = isSpeak (ECGw)
    [~,name]= fileparts(ECGw.recording_name);

    if (exist(['./../results/tree/tree_res/tree_spike_' name '.mat'],'file'))
        ret = load(['./../results/tree/tree_res/tree_spike_' name '.mat']);
        ret = ret.ret;
    else
        header = ECGw.ECG_header();
        N= header.nsamp;
        ECG = ECGw.read_signal(1,N);
        
        th= 189;  % mV/seg
        per = 0.1;
        
        th = th* header.gain(1)/header.freq;  %Cuentas/muestras
        
        spike =max(sum(abs(diff(ECG))>th)/N);
        ret = any(spike > per);
        save(['./../results/tree/tree_res/tree_spike_' name '.mat'],'ret');
    end
end

% Idea: ECG-Median ---> Subdividir el ECG en 10 pedazos.  ---> Si alguno se
% va a mayor a un thresshols => ES MALO.   3/10 para determinar como
% unacceptable

function [ ret ] = isBigStep (ECGw)
%     header = ECGw.ECG_header();
%     N= header.nsamp;
%     ECG = ECGw.read_signal(1,N);
% 
%     ECG = abs(diff(ECG));
%     
%     MaxEdge = 1000; %mV/seg
%     MaxEdge = MaxEdge* header.gain(1)/header.freq;  %Cuentas por muestra
%     
%     ret = any(any(ECG > MaxEdge));
    [~,name]= fileparts(ECGw.recording_name);

    if (exist(['./../results/tree/tree_res/tree_bstep_' name '.mat'],'file'))
        ret = load(['./../results/tree/tree_res/tree_bstep_' name '.mat']);
        ret = ret.ret;
    else

        header = ECGw.ECG_header();
        N= header.nsamp;
        ECG = ECGw.read_signal(1,N);

        ECG =    bsxfun(@minus,ECG,median(ECG));
        big = abs(ECG)>1100;

        sections = 10;
        win=N/sections;

        ok = arrayfun(@(x)any(any(big((1+(x-1)*win):(x*win),:))),1:10);

        ret = false;

        if (sum(ok)>2)
           ret = true;
        end

        save(['./../results/tree/tree_res/tree_bstep_' name '.mat'],'ret');
    end
end

function [ ret ] = isFlat (ECGw)
    [~,name]= fileparts(ECGw.recording_name);

    if (exist(['./../results/tree/tree_res/tree_flat_' name '.mat'],'file'))
        ret = load(['./../results/tree/tree_res/tree_flat_' name '.mat']);
        ret = ret.ret;
    else
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

        save(['./../results/tree/tree_res/tree_flat_' name '.mat'],'ret');
    end
end