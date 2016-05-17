
function [ SQI ] = calc_all_sqi ( FILE )

ECGtask = ECGtask_QRS_detection;
ECGtask.detectors = { 'wqrs' 'pantom' 'sqrs' 'gqrs' 'wavedet'}  ;

wrapper = ECGwrapper ('recording_name', FILE , ...
                      'output_path','/tmp/signalquality/sqis/', ...
                      'ECGtaskHandle',ECGtask , ...
                      'cacheResults',true ...
                        );

wrapper.Run;

[ recording_path rec_name ] = fileparts(FILE);
Detection = load (['/tmp/signalquality/sqis/' rec_name '_QRS_detection.mat']);

N= wrapper.ECG_header.nsamp;
signal = wrapper.read_signal(1,N);
header = wrapper.ECG_header();
fs = header.freq;

Leads = get_lead_names(header);

fft_signal = abs(fft(signal));
P_fft_signal = (fft_signal/N).^2;

f = 0:fs/N:(N-1)*(fs/N);
t = 0: 1/fs : (N-1)/fs;

%% pSQI
pSQI = calc_pSQI(f,P_fft_signal);

%% basSQI
basSQI = calc_basSQI(f,P_fft_signal);

%% bsSQI
bsSQI = calc_bsSQI(wrapper,'wavedet');

%% eSQI
eSQI = calc_eSQI(wrapper,'wavedet');

%% hfSQI
hfSQI = calc_hfSQI(wrapper,'wavedet');

%% bSQI
bSQI1 = calc_bSQI(wrapper,'sqrs','wqrs');
bSQI2 = calc_bSQI(wrapper,'gqrs','wqrs');
bSQI3 = calc_bSQI(wrapper,'wqrs','wavedet');
bSQI4 = calc_bSQI(wrapper,'sqrs','wavedet');
bSQI5 = calc_bSQI(wrapper,'gqrs','wavedet');
bSQI6 = calc_bSQI(wrapper,'gqrs','sqrs');

%% sSQI
sSQI = skewness(signal);

%% kSQI
kSQI = kurtosis(signal);

%% rsdSQI
rsdSQI = calc_rsdSQI(wrapper,'wavedet');

%% purSQI
 w2 = spectral_moment(signal, fs, 2);
 w0 = spectral_moment(signal, fs, 0);
 w4 = spectral_moment(signal, fs, 4);
 purSQI = (w2.^2) ./ (w0.*w4) ;

%% entSQI
dim = 3;
r=0.2;
for i=1:numel(Leads)
     entSQI(i) =SampEn( dim, r, signal(:,i) );
end

%% pcaSQI
pcaSQI = calc_pcaSQI (wrapper,'simple');
robpcaSQI = calc_pcaSQI (wrapper,'robust');

%% Return
SQI = struct ('bSQI1',bSQI1,... %
              'bSQI2',bSQI2,... %
              'bSQI3',bSQI3,... %
              'bSQI4',bSQI4,... %
              'bSQI5',bSQI5,... %
              'bSQI6',bSQI6,... %
              'sSQI',sSQI, ... %
              'kSQI',kSQI, ... %
              'pSQI',pSQI, ...
              'basSQI',basSQI,...
              'bsSQI',bsSQI, ...
              'eSQI',eSQI, ...
              'hfSQI',hfSQI, ...
              'entSQI',entSQI, ...
              'purSQI', purSQI, ...
              'rsdSQI', rsdSQI, ... % Posiblemente mandarla a la mierda
              'pcaSQI', pcaSQI, ...
              'robpcaSQI', robpcaSQI ...
               );
end

