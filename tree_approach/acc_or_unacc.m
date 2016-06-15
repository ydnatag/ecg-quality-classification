function [ acc flags ] = acc_or_unacc( )
    FILE = './../records/set-a/2887999';
    %ECGtask = ECGtask_QRS_detection;
    %ECGtask.detectors = { 'wqrs'}  ;

    %ECGw = ECGwrapper ('recording_name', FILE , ...
%                        'output_path','/tmp/signalquality/sqis/', ...
%                        'ECGtaskHandle',ECGtask , ...
%                        'cacheResults',true ...
%                       );

    %ECGw.Run;
    %[ recording_path rec_name ] = fileparts(FILE);
    %qrs = load (['/tmp/signalquality/sqis/' rec_name '_QRS_detection.mat']);
    
    f = fopen(['./../records/set-a/RECORDS-acceptable']);
    files = textscan(f,'%s');
    fclose(f);
    files = files{1};
    
    
    
    
    acc = cellfun(@(x)tmpFunc(x),files(1:3));
    
    %f = fopen(['./../records/set-a/RECORDS-unacceptable']);
    %files = textscan(f,'%s');
    %fclose(f);
    %files = files{1};
    
    %unacc = cellfun(@(x)tmpFunc(x),files(1:10));
    %clear ECGtask ECGw
    
    
    

end

function [res] = tmpFunc (file)
     ECGw = ECGwrapper ('recording_name', ['./../records/set-a/' file]);
     header = ECGw.ECG_header();
     N= header.nsamp;
     ECG = ECGw.read_signal(1,N);
     

     
     
     
     % En este codigo hay valores arbitrarios sin  razon alguna, es solo
     % para testear
     res = struct('var',var(ECG), ...
                  'spikes',sum(diff(ECG)>20)/N,...
                  'sat',sum(ECG>1000)/N, ...
                  'SignalOverBaseline',sqrt( var(ECG)./var(MedianFilt(ECG,0.5*header.freq)) ), ...
                  '', ...                  
                  );
end



