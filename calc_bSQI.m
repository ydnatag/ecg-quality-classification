function [ bSQI ] = calc_bSQI( ECGw, qrs_detector1, qrs_detector2)
%CALC_ESQI Ratio between # of HB detecteted by both detectors 
% over # of HB detected by qrs_detector1 
    if (nargin<2)
       qrs_detector1 =  'wqrs' ;
    end
    
    if (nargin<2)
       qrs_detector2 =  'epltdqrs1' ;
    end
    
    
    N= ECGw.ECG_header.nsamp;
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    soft_int_interval = 0.1*fs; % Soft intersect over 100ms
    
    
    
    [ recording_path, rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        bSQI = [];
        return;
    end
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);

    
    for i=1:numel(Leads)
        
        field_qrs1 = [qrs_detector1 '_' Leads{i} ];
        field_qrs2 = [ qrs_detector2 '_'  Leads{i}];

        
        if (isfield(Detection.(field_qrs1),'time') && isfield(Detection.(field_qrs2),'time') )
            
            beats_qrs1 = Detection.(field_qrs1).time( Detection.(field_qrs1).time < N);        
            beats_qrs2 = Detection.(field_qrs2).time( Detection.(field_qrs2).time < N);        
            
            beats_qrs1_N = numel(beats_qrs1);
            beats_qrs2_N = numel(beats_qrs2);
            
            qrs1_qrs2_N = 0;

            if (beats_qrs2_N)
                qrs1_qrs2_N = numel(soft_intersect(beats_qrs2,beats_qrs1,soft_int_interval));
            end       
            
            if (beats_qrs1_N)
                bSQI(i) = qrs1_qrs2_N/ beats_qrs1_N ;
            else
                bSQI(i) = 0;
            end
        end    
    end
    
end

