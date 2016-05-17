function [ pcaSQI ] = calc_pcaSQI( ECGw, algorithm )
%CALC_PCASQI Summary of this function goes here
%   Detailed explanation goes here
    if (nargin<2)
       algorithm = 'simple' ;
    end
    
    N= ECGw.ECG_header.nsamp;
    signal = ECGw.read_signal(1,N);
    
    header = ECGw.ECG_header();
    fs = header.freq;
    Leads = get_lead_names(header);
    Leads_cant = numel(Leads);
    
    if (Leads_cant ==12)
        principal = 5;
    else
        principal = Leads_cant /2;
    end
    
    if (strcmp(algorithm,'simple'))
        [eigen_vec eigen_val]= autovec_calculation(signal);
    elseif(strcmp(algorithm,'robust'))
        [eigen_vec eigen_val]= autovec_calculation_robust(signal);
    else
        cprintf('red','pcaSQI ERROR: Incorrect algorithm');
        return;
    end    
    pcaSQI = sum(eigen_val(1:principal))/sum(eigen_val) * ones(1,Leads_cant);
end

