function [  ] = ver_resultados( )
    PATH = './../records/set-a/';

    aux = load('./../results/tree/results.mat');
    
    for idx=find(aux.unacc_res==0)
        ECGw = ECGwrapper ('recording_name', [PATH aux.unacc_files{idx}]);        
        plot_ecg_strip(ECGw,'Lead_gain',1.3*ones(ECGw.ECG_header.nsig,1));
        a= findall(0,'type','figure');
        set(a(1),'WindowKeyPressFcn',{@KB_CallBack});
        figure(a(1));
        uiwait
        close(a(1));
    end
end

function [] = KB_CallBack(src, evnt) 
   switch evnt.Key
        case 'y'
            uiresume(src);
        case 'n'
            uiresume(src);
    end

end