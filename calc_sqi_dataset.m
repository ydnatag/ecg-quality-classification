function [ SQI ] = calc_sqi_dataset ( DATASET )
    PATH = ['./records/' DATASET ];
    RES_PATH = ['./results/' DATASET];
    
    if ( ~exist(PATH,'dir') )
        fprintf('NO EXISTE EL DATASET\n');
        return;
    end
    
    if ( ~exist(RES_PATH,'dir') )
        mkdir(RES_PATH);
    end
    
    if ( exist([PATH '/RECORDS-acceptable'],'file') )
        f = fopen([PATH '/RECORDS-acceptable']);
        files = textscan(f,'%s');
        fclose(f);
    end
    
    for i=1:numel(files{:})
        procFile(files{1}{i},PATH,RES_PATH,1);
    end
    
    clear files;
   
    if ( exist([PATH '/RECORDS-unacceptable'],'file') )
        f = fopen([PATH '/RECORDS-unacceptable']);
        files = textscan(f,'%s');
        fclose(f);
    end
    
    parfor i=1:numel(files{:})
        procFile(files{1}{i},PATH,RES_PATH,0);
    end
    
end

function procFile (file,PATH,RES_PATH,acceptable)
    cacheResults=0;
    fprintf('processing %s\n',file);
    if (cacheResults == 1)
        if (~exist([RES_PATH '/sqi_' file '.mat'],'file'))
            sqi = calc_all_sqi([PATH '/' file]);
            save([RES_PATH '/sqi_' file '.mat'],'file','sqi','acceptable');
        end
    else
        sqi = calc_all_sqi([PATH '/' file]);
        save([RES_PATH '/sqi_' file '.mat'],'file','sqi','acceptable');
    end
end

