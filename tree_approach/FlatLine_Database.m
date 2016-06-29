function [  ] = FlatLine_Database(  )
    global PATH ;
    global record;
    global file_flatline;
    
    PATH = './../records/set-a/';
    f = fopen([PATH 'RECORDS']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
    
    file_flatline = fopen([PATH 'RECORDS-flatline'],'w+');
    
    for i=1:nnn
        record = files{i};
        ECGw = ECGwrapper ('recording_name', [PATH record]);
        plot_ecg_strip(ECGw);
        a= findall(0,'type','figure');
        set(a(1),'WindowKeyPressFcn',{@KB_CallBack});
        uiwait
        
        
        
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