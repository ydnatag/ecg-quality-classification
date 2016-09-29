function [  ] = train_all_models(  )
    t = load_features('set-a');
  
    features = t.Properties.VariableNames;
    features=features(1:(numel(features)-1));
    
    
    
    for i=1:numel(features)
        comb = combnk(features,i); 
        parfor j=1:numel(comb)
            res(j) = trainClassifier(t,comb{j});
        end
        
        save(['./results/svm/results' num2str(i) '.mat'],'res','comb');
        clear res;
    end
    

end

