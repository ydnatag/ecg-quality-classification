function [  ] = train_all_models( dataset )
    t = load_features('set-a');
  
    features = t.Properties.VariableNames;
    features=features(1:(numel(features)-1));
    
    
    
    for i=4:numel(features)
        c = combnk(features,i);
        fprintf('Dea a %d',i);
        parfor j=1:numel(c)
            res(i,j)=trainClassifier(t,c{j});
        end
    end
    
    

end

