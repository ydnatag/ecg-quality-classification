function [ ] = ver_resultado( )
    res=load('./../results/tree/results.mat');
    PATH = './../records/set-a/';
    cant_acc = length(res.acc_res);
    tp = sum(res.acc_res==0);
    fn =  cant_acc-tp;

    fprintf('Aceptables: \n\tTotal:%d  \n\tDetectados:%d  \n\tErrados:%d  \n\tPorcentaje:%.3f\n', ...
            cant_acc, ...
            tp, ... 
            fn,...
            (tp/cant_acc)*100);

    cant_unacc = length(res.unacc_res);
    tn = sum(res.unacc_res~=0) ;
    fp =  cant_unacc-tn;

    fprintf('Inaceptables: \n\tTotal:%d  \n\tDetectados:%d  \n\tErrados:%d  \n\tPorcentaje:%.3f\n', ...
            cant_unacc, ...
            tn, ...
            fp, ...
            (tn/cant_unacc)*100);

    revisar = find(res.acc_res);
    
    for idx=revisar
        ECGw=ECGwrapper('recording_name',[PATH res.acc_files{idx}]);
        plot_ecg_strip(ECGw,'Lead_gain',1.3*ones(ECGw.ECG_header.nsig,1));
        a= findall(0,'type','figure');
        set(a(1),'WindowKeyPressFcn',{@KB_CallBack});
        figure(a(1));
        uiwait
        figure(a(1));
        close(a(1));
    end
    
    function [] = KB_CallBack(src, evnt)
        
        switch evnt.Key
            case 'y'
                uiresume(src);
            case 'n'
                uiresume(src);
        end

    end
        
end

