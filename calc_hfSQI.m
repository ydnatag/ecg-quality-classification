function [ hfSQI ] = calc_hfSQI( ECGw , qrs_detector )
%CALC_HFSQI Summary of this function goes here
%   Detailed explanation goes here
    if (nargin<2)
       qrs_detector =  'epltdqrs1' ;
    end

    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    
    [ recording_path, rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        hfSQI = [];
        return;
    end
    
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);
  
    Ra_interval = round ( -0.07*fs:0.07*fs);
    Hi_interval = round ( -0.28*fs:-0.05*fs);
    for i=1:numel(Leads)
        field = [qrs_detector '_'  Leads{i}];

        if (isfield(Detection.(field),'time') )
            beats = Detection.(field).time( ...
                              Detection.(field).time > abs(min(Hi_interval)) ...
                            & Detection.(field).time < (N-abs(max(Ra_interval))) ...
                            );        

            beats_N = numel(beats);

            if (beats_N)

                y = abs(filter([1 -2 1],1,signal ));
                s = filter ( [1 1 1 1 1] ,1,abs(y));
                Hi = [];
                Ra = [];
                
                for j=1:beats_N
                    Ra(j) = peak2peak (signal(Ra_interval+beats(j),1) );
                    Hi(j) = mean(s(Hi_interval+beats(j),1));
                end

                hfSQI(i) = sum(Ra./Hi)/beats_N;

            else
                hfSQI(i)=realmax;
            end
        end

    end

end

