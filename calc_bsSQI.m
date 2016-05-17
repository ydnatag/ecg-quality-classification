function [ bsSQI ] = calc_bsSQI( ECGw , qrs_detector )
%CALC_BSSQI Summary of this function goes here
%   Detailed explanation goes here
    
    if (nargin<2)
       qrs_detector =  'epltdqrs1' ;
    end

    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    
    Ra_interval = round ( -0.07*fs:0.07*fs);
    Ba_interval = round ( -1 *fs : +1*fs );
    
    [ recording_path rec_name ] = fileparts(ECGw.recording_name);
    if (~exist([ECGw.output_path rec_name '_QRS_detection.mat'], 'file'))
        cprintf( 'Red', ['ERROR: File ' [ECGw.output_path rec_name '_QRS_detection.mat'] 'does not exist\n' ]);
        bsSQI=[];
        return;
    end
    
    Detection = load ([ECGw.output_path rec_name '_QRS_detection.mat']);
    
    FiltBL = FilterBaseLine (fs); 
    baseline = filter( FiltBL, signal);
    baseline = flipud(filter(FiltBL , flipud(baseline)));
    
 

    bsSQI = zeros(1,numel(Leads));

    for i=1:numel(Leads)
        field = [qrs_detector '_' Leads{i}];

        if (isfield(Detection.(field),'time') )
            beats = Detection.(field).time( ...
                              Detection.(field).time > abs(min(Ba_interval)) ...
                            & Detection.(field).time < (N-abs(max(Ba_interval))) ...
                            );        

            beats_N = numel(beats);

            if (beats_N)
                Ra = [];
                Ba = [];
                RdivB = [];
                for j=1:beats_N
                    Ra(j) = peak2peak (signal(Ra_interval+beats(j),1) );
                    Ba(j) = peak2peak (baseline(Ba_interval+beats(j),1));
                end

                RdivB = Ba ./ Ra;
                 
                bsSQI(i)= sum(RdivB)/beats_N;
                if (bsSQI(i)==inf || bsSQI(i)==NaN) 
                    bsSQI(i)=realmax;
                end
            else
                bsSQI(i)=realmax;
            end
        end

    end

end

