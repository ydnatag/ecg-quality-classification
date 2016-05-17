function [ picasqi ] = calc_picasqi(ECGw, qrs_detector)
     
    if (nargin<2)
       qrs_detector =  'wqrs' ;
    end

    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    sync_interval = floor([-0.3*fs:0.45*fs]);
    
    
    [ recording_path, rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        picasqi = [];
        return;
    end
    
%     FiltBL = FilterBaseLine (fs); 
%     baseline = filter( FiltBL, signal);
%     baseline = flipud(filter(FiltBL , flipud(baseline)));
%     
%     signal = signal - baseline;
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);
    
    picasqi = zeros(1,numel(Leads));
    for i=1:numel(Leads)
        field_qrs = [qrs_detector '_' Leads{i} ];
        if (isfield(Detection.(field_qrs),'time'))
            beats_qrs = Detection.(field_qrs).time( ... 
                            (Detection.(field_qrs).time < ( N-abs(max(sync_interval)) ) )...
                            & ...
                            ( Detection.(field_qrs).time > abs(min(sync_interval)) )...
                            );      
            beats_qrs_N = numel(beats_qrs);
           
            if (beats_qrs_N>1) 
                mat = zeros(beats_qrs_N,numel(sync_interval));
                
                for j=1:beats_qrs_N
                   mat(j,:)= signal(sync_interval+beats_qrs(j),i)-mean(signal(sync_interval+beats_qrs(j),i)); 
                end
                
                Cx = mat * mat';
                Cii= diag(1./diag(Cx));
                Cx = Cx * Cii;
                
                picasqi(i) = mean(mean(Cx));
            else
                picasqi(i) = 0;
            end
                % hist(reshape(Cx,1,numel(Cx)),2000);
            
            
            
        end
        
    end
    
end

