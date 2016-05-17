function [ eSQI ] = calc_eSQI( ECGw, qrs_detector)
%CALC_ESQI Summary of this function goes here
%   Detailed explanation goes here
    if (nargin<2)
       qrs_detector =  'epltdqrs1' ;
    end

    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    [ recording_path rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        eSQI = [];
        return;
    end
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);
  
    R_interval = round ( -0.07*fs:0.08*fs);

    P_total = sum(signal.^2);

    for i=1:numel(Leads)
        field = [qrs_detector '_'  Leads{i}];

        if (isfield(Detection.(field),'time') )
            if (P_total(i))
                beats = Detection.(field).time( ...
                                  Detection.(field).time > abs(min(R_interval)) ...
                                & Detection.(field).time < (N-abs(max(R_interval))) ...
                                );        

                beats_N = numel(beats);
                
                if (beats_N)
                    P_QRS = [];
                    
                    for j=1:beats_N
                        P_QRS(j) = sum (signal(R_interval+beats(j),i).^2);
                    end

                    P_QRS_Total = sum (P_QRS);

                    eSQI(i)= P_QRS_Total/ P_total(i);
                else
                    eSQI(i)=0;
                end
            else
                eSQI(i)= 1;
            end
        end

    end

end

