function [ t features results] = load_features (dataset)
    PATH = ['./../results/' dataset '/'];
    d = dir(PATH);
    result = {d.name};
    result(:,1:2)=[];
    
    result = strcat(PATH,result);
    
    [sqi acc] = cellfun(@(x) load_a_lead(x),result);
    
%     [sqi acc]=serializar(sqi,acc);
    
    sqi = nan_correction(sqi);
%     features = struct2array(sqi);
%     results = acc;
    t = [struct2table(sqi) table(acc','VariableNames',{'acc'})];    

end

%% Randsample
% Dividir en 2 el set a
% En 1 generar el modelo y despues probarlos en el 2
% El mejor va contral el B
% Cambiar el orden de entrenamiento y evaluacion
% Probar reg logistica


function [sqi] = nan_correction(sqi)
    for i=1:numel(sqi)
        sqi(i).sSQI(isnan(sqi(i).sSQI))= 0;%realmax;%0;
        sqi(i).kSQI(isnan(sqi(i).kSQI))= 0;%realmax;%0;
        sqi(i).purSQI(isnan(sqi(i).purSQI))=0;%realmax;%0;
        sqi(i).hfSQI(isnan(sqi(i).hfSQI))=0;%realmax;
        sqi(i).bsSQI(isnan(sqi(i).bsSQI))=0;%realmax;
        sqi(i).pcaSQI(isnan(sqi(i).pcaSQI))=0;%realmax;%1;
        sqi(i).robpcaSQI(isnan(sqi(i).robpcaSQI))=0;%realmax;%1;
        sqi(i).entSQI(isnan(sqi(i).entSQI))=0;%realmax;%0;
        sqi(i).entSQI(isinf(sqi(i).entSQI))=0;%realmax;
    end
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




