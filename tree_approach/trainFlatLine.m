function [ th ] = trainFlatLine(  )
    
    
    PATH = './../records/set-a/';
    
    %% Calculo con base de datos aceptable
    % Cuidado!!! Hay flat en los aceptables :o
%     Registros
%     '1548723'
%     '1968453'
%     '2080991'
%     '2140454'
%     '2151032'
%     '2266555'
%     '2381242'
%     '2536401'
%     '2537839'
%     '2653435'
%     '2865486'
%     '2883516'
%     '1755843'
%     '2358887'
%     '2362692'
%     '2376318'
%     '2536401'
%     '2873998'
%     '2883516'


    f = fopen([PATH 'RECORDS-Myacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
    
    
    acc_min_win_mean_dxdt= zeros(1,files_num);
    acc_min_std_ecg = zeros(1,files_num);
    acc_min_delta_ecg = zeros(1,files_num);
    
    parfor i=1:files_num
        record = files{i};
        [acc_min_win_mean_dxdt(i) acc_min_std_ecg(i) acc_min_delta_ecg(i)] = calc_flatline_estimators ([PATH record]);
    end
    
    N=1000
    i=0:(N-1);
    
    th_dxdt(i+1) = i*(max(acc_min_win_mean_dxdt)-min(acc_min_win_mean_dxdt))/N;
    th_std(i+1) = i*(max(acc_min_std_ecg)-min(acc_min_std_ecg))/N;
    th_delta(i+1) = i*(max(acc_min_delta_ecg)-min(acc_min_delta_ecg))/N;
        
    
    for i=1:N
        cant_dxdt(i)= sum(acc_min_win_mean_dxdt<=th_dxdt(i));
        cant_std(i)= sum(acc_min_std_ecg<=th_std(i));
        cant_delta(i)= sum(acc_min_delta_ecg<=th_delta(i));
    end
    
    
    acc_cant_dxdt= cant_dxdt/files_num;
    acc_cant_std= cant_std/files_num;
    acc_cant_delta= cant_delta/files_num;
    
    
    %% Calculo con base de datos flat
    
    
    f = fopen([PATH 'RECORDS-flatline']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    files_num= size(files,1);
        
    flat_min_win_mean_dxdt= zeros(1,files_num);
    flat_min_std_ecg = zeros(1,files_num);
    flat_min_delta_ecg = zeros(1,files_num);
    
    parfor i=1:files_num
        record = files{i};
        [flat_min_win_mean_dxdt(i) flat_min_std_ecg(i) flat_min_delta_ecg(i)] = calc_flatline_estimators ([PATH record]);
    end
    

    N=1000
    i=0:(N-1);
    
    for i=1:N
        cant_dxdt(i)= sum(flat_min_win_mean_dxdt<=th_dxdt(i));
        cant_std(i)= sum(flat_min_std_ecg<=th_std(i));
        cant_delta(i)= sum(flat_min_delta_ecg<=th_delta(i));
    end
    
    flat_cant_dxdt= cant_dxdt/files_num;
    flat_cant_std= cant_std/files_num;
    flat_cant_delta= cant_delta/files_num;
    
    subplot 311
    plot(1:1000,[acc_cant_delta' flat_cant_delta'])
    subplot 312
    plot(1:1000,[acc_cant_dxdt' flat_cant_dxdt'])
    subplot 313
    plot(1:1000,[acc_cant_std' flat_cant_std'])
    
    %% Por los resultados mostrados en la figura anterior, elijo como TH el IDX 100 de la media de la derivada => 0.0017 mV/muestra *fs => 

end


function [min_win_mean_dxdt min_std_ecg min_delta_ecg] = calc_flatline_estimators ( file)
    ECGw = ECGwrapper ('recording_name', file);
        
    header = ECGw.ECG_header();
    N= header.nsamp;
    fs = header.freq;
    leads = get_lead_names(header);
    n_leads= numel(leads);
    
    win_size = round(1.5 * fs);  % ventana en muestras (Segundos *fs)
    gain = 1./header.gain;
    ecg = ECGw.read_signal(1,N)*diag(gain); %unidades fisicas (en mV)
    
    dxdt= abs(diff(ecg));
    
    win_mean_dxdt = filter(ones(1,win_size)/win_size,1,dxdt); % Calculo la media en win_size
    win_std_ecg = sqrt(winvar(ecg,win_size));
    win_delta_ecg = windelta(ecg,win_size);
    
    
    min_win_mean_dxdt = min(min(win_mean_dxdt(win_size:size(win_mean_dxdt,1),:) ));
    min_std_ecg = min(min(win_std_ecg));
    min_delta_ecg = min(min(win_delta_ecg));

end

function [ v ] = windelta (x,win)

    function [ v ] = aux_func ( x )
        m = mean(x);
        v = max(abs(bsxfun( @minus, x, m)));
    end

    v = arrayfun(@(i)aux_func(x((i-win+1):i,:)),[(win):size(x,1)], 'UniformOutput',false );
    v = cell2mat(v');        
end



function [ v ] = winvar ( x, win)
    v = arrayfun(@(i)var(x((i-win+1):i,:)),[(win):size(x,1)], 'UniformOutput',false );
    v = cell2mat(v');
end


function aux_plot (idx)
    PATH = './../records/set-a/';
    f = fopen([PATH 'RECORDS-Myunacceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};

    for i=idx
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

end

function [] = KB_CallBack(src, evnt) 
    switch evnt.Key
        case 'y'
            uiresume(src);
        case 'n'
            uiresume(src);
    end

end

