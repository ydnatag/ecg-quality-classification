function [ classifier ] = train_model( list )
    t = load_features('set-a');
  
    [per classifier]= trainClassifier(t,list);
    
    Accuracy = (per.tp+per.tn)/(per.tp+per.tn+per.fp+per.fn), Sensitivity = per.tp/(per.tp+per.fn), Specificity = per.tn/(per.tn+per.fp)

end

