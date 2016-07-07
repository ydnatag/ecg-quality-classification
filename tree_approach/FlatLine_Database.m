function [  ] = FlatLine_Database(  )
    global PATH ;
    global record;
    global file_flatline;
    
    PATH = './../records/set-a/';
    f = fopen([PATH 'RECORDS-unacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
    
    file_flatline = fopen([PATH 'RECORDS-flatline']); % Por las dydas comento el %w para no pisar jejejejejej%'w+');
    
    for i=1:files_num
        record = files{i};
        ECGw = ECGwrapper ('recording_name', [PATH record]);
        plot_ecg_strip(ECGw,'Lead_gain',1.3*ones(ECGw.ECG_header.nsig,1));
        a= findall(0,'type','figure');
        set(a(1),'WindowKeyPressFcn',{@KB_CallBack});
        figure(a(1));
        uiwait
        figure(a(1));
               
        close all;
    end
    
    fclose(file_flatline)
    clear PATH record file_flatline;
end

function [] = KB_CallBack(src, evnt) 
    global record;
    global file_flatline;

    switch evnt.Key
        case 'y'
            fprintf('yep: %s\n',record);    

            fprintf(file_flatline,'%s\n',record);
            uiresume(src);
        case 'n'
            fprintf('Nop\n');    
            uiresume(src);
    end

end