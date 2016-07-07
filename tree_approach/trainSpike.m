function [ tp_per ] = trainSpike ()
    [acc_train unacc_train acc_test unacc_test] = get_train_set(1);
    
    N = size(acc_train,1)+size(unacc_train,1);
    th = 20;
    per = logspace(-8,0,100); %[0.0:0.02:0.1]; % Por ahi hay que cambiarlo a logspace porque los puntos con los que genera la roc estan muy agrupados
  
    thacc = trainSpikeTH(1); % Vector de maximas derivadas de los OK
    thunacc = trainSpikeTH(0); % vector de maximas derivadas de los NO OK
    thmit = trainSpikeTH(-1); % vector de maximas derivadas del MIT

    [h_acc x_acc] = hist(thacc,0:3:250);
    [h_unacc x_unacc]  = hist(thunacc,0:3:250);
    [h_mit x_mit] = hist(thmit,0:3:250);
    
    h_acc = h_acc/numel(thacc);
    h_unacc = h_unacc/numel(thunacc);
    h_mit = h_mit/numel(thmit);
    
    th= prctile(thmit,99)
    prc_descartado= 1-sum(h_unacc(x_unacc<th));
    
    parfor i=1:numel(per)
        [tp] = cellfun(@(x)calc_spikes(x,th,per(i)),acc_train);
        [fp] = cellfun(@(x)calc_spikes(x,th,per(i)),unacc_train);
        tp = sum(tp);
        fp = sum(fp);
        fn = size(acc_train,1)-tp;
        tn = size(unacc_train,1)-fp;
        
        tp = tp/size(acc_train,1);
        fp = fp/size(unacc_train,1);
        
        tp_out(i) = tp;
        fp_out(i) = fp; 
        
     
        
    end
    
    trapz(fp_out,tp_out);
    plot(fp_out,tp_out);
    d = sqrt(fp_out.^2+(1-tp_out).^2);
    
    best_per = per(d==min(d)); % Mas cercano al ideal 
    aceptableTP = 0.98;
    
    d = abs(tp_out-aceptableTP);
    tp_per = per(d==min(d))
    
end


function [th_vec] = trainSpikeTH (acc)
    if (acc==1)
        f = get_train_set(1);
        PATH = './../records/set-a/';
        f=f';
    elseif (acc==0)
        [~, f]= get_train_set(1);
        PATH = './../records/set-a/';
        f=f';
    else
        f = dir(['./../records/mit/*.hea']);
        f = arrayfun(@(x)f(x).name,1:size(f,1),'UniformOutput',0);
        PATH = './../records/mit/';
    end
        
    
    
    ECGtask = ECGtask_QRS_detection;
    ECGtask.detectors = {'gqrs'}  ;
    out =cell(1,size(f,2));
    
    parfor i=1:size(f,2)
        ECGw = ECGwrapper ('recording_name', [PATH f{i}], ...
                           'output_path',[PATH 'qrs/'], ...
                           'ECGtaskHandle',ECGtask , ...
                           'cacheResults',true ...
                           );
        ECGw.Run;
        header = ECGw.ECG_header();
        N= header.nsamp;
        fs = header.freq;
        leads = get_lead_names(header);
        
        qrs_interval = round([-0.1*fs:0.1*fs]);
        
        %qrs = ECGw.ECG_annotations();
        qrs = load ([PATH 'qrs/' header.recname '_QRS_detection.mat']);
        ecg = ECGw.read_signal(1,N);
        n_leads= numel(leads);
      
        for k=1:n_leads;
            
            field = ['gqrs_'  leads{k}];
            qrs_t = qrs.(field).time;
            qrs_t = qrs_t(qrs_t>abs(min(qrs_interval)) & qrs_t<(N-max(qrs_interval)) );

            for j=1:size(qrs_t,1)
                d= abs(diff(ecg(qrs_t(j)+qrs_interval,k)));
                max_d = max(d) /header.gain(k)*fs;
                out{i}= [ out{i} max_d];
            end
        end
        
    end
    th_vec=[];
    for i=1:size(out,2)
        th_vec = [th_vec out{i}];        
    end     
end 

function ret = calc_spikes(file,th,per)
    ECGw = ECGwrapper ('recording_name', ['./../records/set-a/' file]);
    header = ECGw.ECG_header();
    N= header.nsamp;
    ECG = ECGw.read_signal(1,N);
    
    th = th* header.gain(1)/header.freq;
        
    speaks=sum(abs(diff(ECG))>th)/N;
    ret = all(speaks < per);

end


function [ acc_train_files unacc_train_files acc_test_files unacc_test_files ] = get_train_set( per )
    f = fopen(['./../records/set-a/RECORDS-acceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
    
    acc_idx= randsample(files_num,files_num);
    acc_train_idx = acc_idx([1:round(per*files_num)]');
    acc_test_idx = acc_idx([round(per*files_num)+1:files_num]');
    
    acc_train_files = files(acc_train_idx);
    acc_test_files = files(acc_test_idx);
    
    f = fopen(['./../records/set-a/RECORDS-unacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);

    unacc_idx= randsample(files_num,files_num);
    unacc_train_idx = unacc_idx([1:round(per*files_num)]');
    unacc_test_idx = unacc_idx([round(per*files_num)+1:files_num]');
    
    unacc_train_files = files(unacc_train_idx);
    unacc_test_files = files(unacc_test_idx);
    
end

