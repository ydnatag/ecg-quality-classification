function [ t features results] = load_features (dataset)
    PATH = ['./results/' dataset '/'];
    d = dir(PATH);
    result = {d.name};
    result(:,1:2)=[];
    
    result = strcat(PATH,result);
    
    [sqi acc] = cellfun(@(x) load_a_lead(x),result);
    
    [sqi acc]=serializar(sqi,acc);
    
    sqi = nan_correction(sqi);
    features = struct2array(sqi);
    results = acc;
    t = [struct2table(sqi) table(acc)];    

end

%% Randsample
% Dividir en 2 el set a
% En 1 generar el modelo y despues probarlos en el 2
% El mejor va contral el B
% Cambiar el orden de entrenamiento y evaluacion
% Probar reg logistica


function [sqi] = nan_correction(sqi)
    sqi.sSQI(isnan(sqi.sSQI))= 0;%realmax;%0;
    sqi.kSQI(isnan(sqi.kSQI))= 0;%realmax;%0;
    sqi.purSQI(isnan(sqi.purSQI))=0;%realmax;%0;
    sqi.hfSQI(isnan(sqi.hfSQI))=0;%realmax;
    sqi.bsSQI(isnan(sqi.bsSQI))=0;%realmax;
    sqi.pcaSQI(isnan(sqi.pcaSQI))=0;%realmax;%1;
    sqi.robpcaSQI(isnan(sqi.robpcaSQI))=0;%realmax;%1;
    sqi.entSQI(isnan(sqi.entSQI))=0;%realmax;%0;
    sqi.entSQI(isinf(sqi.entSQI))=0;%realmax;
    
end


function [ser_sqi ser_acc] = serializar(sqi,acc)
    ser_sqi = sqi(1);
    ser_acc = acc'*ones(1,12);
    ser_acc = ser_acc';
    ser_acc = ser_acc(:);
    fields = fieldnames(sqi);
    for i=1:numel(fields)
       a = arrayfun(@(x)(sqi(x).(fields{i}))',1:numel(sqi),'UniformOutput', false);
       a= cell2mat(a);
       ser_sqi.(fields{i})=a(:);
    end
end


function [sqi acc] = load_a_lead(PATH)
    a = load(PATH);
    sqi=a.sqi(1);
        
    sqi = a.sqi;
    acc = a.acceptable;
end




