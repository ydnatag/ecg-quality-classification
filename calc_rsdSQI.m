function [ rsdSQI ] = calc_rsdSQI( ECGw, qrs_detector )
%CALC_RSDSQI Summary of this function goes here
%   Detailed explanation goes here
    if (nargin<2)
       qrs_detector =  'epltdqrs1' ;
    end
    
    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    ri_interval = round(-0.07*fs:0.08*fs);
    ai_interval = round(-0.2*fs:0.2*fs);

    
    
    [ recording_path, rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        bSQI = [];
        return;
    end
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);

    



    rsdSQI = zeros(1,numel(Leads));

    for i=1:numel(Leads)
        field = [qrs_detector '_'  Leads{i}];

        if (isfield(Detection.(field),'time')  )
            beats = Detection.(field).time( ...
                              Detection.(field).time > abs(min(ri_interval)) ...
                            & Detection.(field).time < (N-abs(max(ri_interval))) ...
                            );        


            beats_N = numel(beats);

            if (beats_N)
                aux =0;
                for j=1:beats_N
                   Sri= std( signal(beats(j)+ri_interval,i).^2,0,1);
                   Sai = std(signal(beats(j)+ai_interval,i).^2,0,1); 
                   aux = aux + Sri/(2*Sai);
                end           
                rsdSQI(i) = aux/beats_N;
            else 
                rsdSQI(i) = 1;
            end        

        end
    end

end

