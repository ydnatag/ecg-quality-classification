function [mat,trainedClassifier] = trainClassifier(datasetTable,pred_list)

% Split matrices in the input table into vectors
datasetTable.bSQI1_1 = datasetTable.bSQI1(:,1);
datasetTable.bSQI1_2 = datasetTable.bSQI1(:,2);
datasetTable.bSQI1_3 = datasetTable.bSQI1(:,3);
datasetTable.bSQI1_4 = datasetTable.bSQI1(:,4);
datasetTable.bSQI1_5 = datasetTable.bSQI1(:,5);
datasetTable.bSQI1_6 = datasetTable.bSQI1(:,6);
datasetTable.bSQI1_7 = datasetTable.bSQI1(:,7);
datasetTable.bSQI1_8 = datasetTable.bSQI1(:,8);
datasetTable.bSQI1_9 = datasetTable.bSQI1(:,9);
datasetTable.bSQI1_10 = datasetTable.bSQI1(:,10);
datasetTable.bSQI1_11 = datasetTable.bSQI1(:,11);
datasetTable.bSQI1_12 = datasetTable.bSQI1(:,12);
datasetTable.bSQI1 = [];
datasetTable.bSQI2_1 = datasetTable.bSQI2(:,1);
datasetTable.bSQI2_2 = datasetTable.bSQI2(:,2);
datasetTable.bSQI2_3 = datasetTable.bSQI2(:,3);
datasetTable.bSQI2_4 = datasetTable.bSQI2(:,4);
datasetTable.bSQI2_5 = datasetTable.bSQI2(:,5);
datasetTable.bSQI2_6 = datasetTable.bSQI2(:,6);
datasetTable.bSQI2_7 = datasetTable.bSQI2(:,7);
datasetTable.bSQI2_8 = datasetTable.bSQI2(:,8);
datasetTable.bSQI2_9 = datasetTable.bSQI2(:,9);
datasetTable.bSQI2_10 = datasetTable.bSQI2(:,10);
datasetTable.bSQI2_11 = datasetTable.bSQI2(:,11);
datasetTable.bSQI2_12 = datasetTable.bSQI2(:,12);
datasetTable.bSQI2 = [];
datasetTable.bSQI3_1 = datasetTable.bSQI3(:,1);
datasetTable.bSQI3_2 = datasetTable.bSQI3(:,2);
datasetTable.bSQI3_3 = datasetTable.bSQI3(:,3);
datasetTable.bSQI3_4 = datasetTable.bSQI3(:,4);
datasetTable.bSQI3_5 = datasetTable.bSQI3(:,5);
datasetTable.bSQI3_6 = datasetTable.bSQI3(:,6);
datasetTable.bSQI3_7 = datasetTable.bSQI3(:,7);
datasetTable.bSQI3_8 = datasetTable.bSQI3(:,8);
datasetTable.bSQI3_9 = datasetTable.bSQI3(:,9);
datasetTable.bSQI3_10 = datasetTable.bSQI3(:,10);
datasetTable.bSQI3_11 = datasetTable.bSQI3(:,11);
datasetTable.bSQI3_12 = datasetTable.bSQI3(:,12);
datasetTable.bSQI3 = [];
datasetTable.bSQI4_1 = datasetTable.bSQI4(:,1);
datasetTable.bSQI4_2 = datasetTable.bSQI4(:,2);
datasetTable.bSQI4_3 = datasetTable.bSQI4(:,3);
datasetTable.bSQI4_4 = datasetTable.bSQI4(:,4);
datasetTable.bSQI4_5 = datasetTable.bSQI4(:,5);
datasetTable.bSQI4_6 = datasetTable.bSQI4(:,6);
datasetTable.bSQI4_7 = datasetTable.bSQI4(:,7);
datasetTable.bSQI4_8 = datasetTable.bSQI4(:,8);
datasetTable.bSQI4_9 = datasetTable.bSQI4(:,9);
datasetTable.bSQI4_10 = datasetTable.bSQI4(:,10);
datasetTable.bSQI4_11 = datasetTable.bSQI4(:,11);
datasetTable.bSQI4_12 = datasetTable.bSQI4(:,12);
datasetTable.bSQI4 = [];
datasetTable.bSQI5_1 = datasetTable.bSQI5(:,1);
datasetTable.bSQI5_2 = datasetTable.bSQI5(:,2);
datasetTable.bSQI5_3 = datasetTable.bSQI5(:,3);
datasetTable.bSQI5_4 = datasetTable.bSQI5(:,4);
datasetTable.bSQI5_5 = datasetTable.bSQI5(:,5);
datasetTable.bSQI5_6 = datasetTable.bSQI5(:,6);
datasetTable.bSQI5_7 = datasetTable.bSQI5(:,7);
datasetTable.bSQI5_8 = datasetTable.bSQI5(:,8);
datasetTable.bSQI5_9 = datasetTable.bSQI5(:,9);
datasetTable.bSQI5_10 = datasetTable.bSQI5(:,10);
datasetTable.bSQI5_11 = datasetTable.bSQI5(:,11);
datasetTable.bSQI5_12 = datasetTable.bSQI5(:,12);
datasetTable.bSQI5 = [];
datasetTable.bSQI6_1 = datasetTable.bSQI6(:,1);
datasetTable.bSQI6_2 = datasetTable.bSQI6(:,2);
datasetTable.bSQI6_3 = datasetTable.bSQI6(:,3);
datasetTable.bSQI6_4 = datasetTable.bSQI6(:,4);
datasetTable.bSQI6_5 = datasetTable.bSQI6(:,5);
datasetTable.bSQI6_6 = datasetTable.bSQI6(:,6);
datasetTable.bSQI6_7 = datasetTable.bSQI6(:,7);
datasetTable.bSQI6_8 = datasetTable.bSQI6(:,8);
datasetTable.bSQI6_9 = datasetTable.bSQI6(:,9);
datasetTable.bSQI6_10 = datasetTable.bSQI6(:,10);
datasetTable.bSQI6_11 = datasetTable.bSQI6(:,11);
datasetTable.bSQI6_12 = datasetTable.bSQI6(:,12);
datasetTable.bSQI6 = [];
datasetTable.sSQI_1 = datasetTable.sSQI(:,1);
datasetTable.sSQI_2 = datasetTable.sSQI(:,2);
datasetTable.sSQI_3 = datasetTable.sSQI(:,3);
datasetTable.sSQI_4 = datasetTable.sSQI(:,4);
datasetTable.sSQI_5 = datasetTable.sSQI(:,5);
datasetTable.sSQI_6 = datasetTable.sSQI(:,6);
datasetTable.sSQI_7 = datasetTable.sSQI(:,7);
datasetTable.sSQI_8 = datasetTable.sSQI(:,8);
datasetTable.sSQI_9 = datasetTable.sSQI(:,9);
datasetTable.sSQI_10 = datasetTable.sSQI(:,10);
datasetTable.sSQI_11 = datasetTable.sSQI(:,11);
datasetTable.sSQI_12 = datasetTable.sSQI(:,12);
datasetTable.sSQI = [];
datasetTable.kSQI_1 = datasetTable.kSQI(:,1);
datasetTable.kSQI_2 = datasetTable.kSQI(:,2);
datasetTable.kSQI_3 = datasetTable.kSQI(:,3);
datasetTable.kSQI_4 = datasetTable.kSQI(:,4);
datasetTable.kSQI_5 = datasetTable.kSQI(:,5);
datasetTable.kSQI_6 = datasetTable.kSQI(:,6);
datasetTable.kSQI_7 = datasetTable.kSQI(:,7);
datasetTable.kSQI_8 = datasetTable.kSQI(:,8);
datasetTable.kSQI_9 = datasetTable.kSQI(:,9);
datasetTable.kSQI_10 = datasetTable.kSQI(:,10);
datasetTable.kSQI_11 = datasetTable.kSQI(:,11);
datasetTable.kSQI_12 = datasetTable.kSQI(:,12);
datasetTable.kSQI = [];
datasetTable.pSQI_1 = datasetTable.pSQI(:,1);
datasetTable.pSQI_2 = datasetTable.pSQI(:,2);
datasetTable.pSQI_3 = datasetTable.pSQI(:,3);
datasetTable.pSQI_4 = datasetTable.pSQI(:,4);
datasetTable.pSQI_5 = datasetTable.pSQI(:,5);
datasetTable.pSQI_6 = datasetTable.pSQI(:,6);
datasetTable.pSQI_7 = datasetTable.pSQI(:,7);
datasetTable.pSQI_8 = datasetTable.pSQI(:,8);
datasetTable.pSQI_9 = datasetTable.pSQI(:,9);
datasetTable.pSQI_10 = datasetTable.pSQI(:,10);
datasetTable.pSQI_11 = datasetTable.pSQI(:,11);
datasetTable.pSQI_12 = datasetTable.pSQI(:,12);
datasetTable.pSQI = [];
datasetTable.basSQI_1 = datasetTable.basSQI(:,1);
datasetTable.basSQI_2 = datasetTable.basSQI(:,2);
datasetTable.basSQI_3 = datasetTable.basSQI(:,3);
datasetTable.basSQI_4 = datasetTable.basSQI(:,4);
datasetTable.basSQI_5 = datasetTable.basSQI(:,5);
datasetTable.basSQI_6 = datasetTable.basSQI(:,6);
datasetTable.basSQI_7 = datasetTable.basSQI(:,7);
datasetTable.basSQI_8 = datasetTable.basSQI(:,8);
datasetTable.basSQI_9 = datasetTable.basSQI(:,9);
datasetTable.basSQI_10 = datasetTable.basSQI(:,10);
datasetTable.basSQI_11 = datasetTable.basSQI(:,11);
datasetTable.basSQI_12 = datasetTable.basSQI(:,12);
datasetTable.basSQI = [];
datasetTable.bsSQI_1 = datasetTable.bsSQI(:,1);
datasetTable.bsSQI_2 = datasetTable.bsSQI(:,2);
datasetTable.bsSQI_3 = datasetTable.bsSQI(:,3);
datasetTable.bsSQI_4 = datasetTable.bsSQI(:,4);
datasetTable.bsSQI_5 = datasetTable.bsSQI(:,5);
datasetTable.bsSQI_6 = datasetTable.bsSQI(:,6);
datasetTable.bsSQI_7 = datasetTable.bsSQI(:,7);
datasetTable.bsSQI_8 = datasetTable.bsSQI(:,8);
datasetTable.bsSQI_9 = datasetTable.bsSQI(:,9);
datasetTable.bsSQI_10 = datasetTable.bsSQI(:,10);
datasetTable.bsSQI_11 = datasetTable.bsSQI(:,11);
datasetTable.bsSQI_12 = datasetTable.bsSQI(:,12);
datasetTable.bsSQI = [];
datasetTable.eSQI_1 = datasetTable.eSQI(:,1);
datasetTable.eSQI_2 = datasetTable.eSQI(:,2);
datasetTable.eSQI_3 = datasetTable.eSQI(:,3);
datasetTable.eSQI_4 = datasetTable.eSQI(:,4);
datasetTable.eSQI_5 = datasetTable.eSQI(:,5);
datasetTable.eSQI_6 = datasetTable.eSQI(:,6);
datasetTable.eSQI_7 = datasetTable.eSQI(:,7);
datasetTable.eSQI_8 = datasetTable.eSQI(:,8);
datasetTable.eSQI_9 = datasetTable.eSQI(:,9);
datasetTable.eSQI_10 = datasetTable.eSQI(:,10);
datasetTable.eSQI_11 = datasetTable.eSQI(:,11);
datasetTable.eSQI_12 = datasetTable.eSQI(:,12);
datasetTable.eSQI = [];
datasetTable.hfSQI_1 = datasetTable.hfSQI(:,1);
datasetTable.hfSQI_2 = datasetTable.hfSQI(:,2);
datasetTable.hfSQI_3 = datasetTable.hfSQI(:,3);
datasetTable.hfSQI_4 = datasetTable.hfSQI(:,4);
datasetTable.hfSQI_5 = datasetTable.hfSQI(:,5);
datasetTable.hfSQI_6 = datasetTable.hfSQI(:,6);
datasetTable.hfSQI_7 = datasetTable.hfSQI(:,7);
datasetTable.hfSQI_8 = datasetTable.hfSQI(:,8);
datasetTable.hfSQI_9 = datasetTable.hfSQI(:,9);
datasetTable.hfSQI_10 = datasetTable.hfSQI(:,10);
datasetTable.hfSQI_11 = datasetTable.hfSQI(:,11);
datasetTable.hfSQI_12 = datasetTable.hfSQI(:,12);
datasetTable.hfSQI = [];
datasetTable.entSQI_1 = datasetTable.entSQI(:,1);
datasetTable.entSQI_2 = datasetTable.entSQI(:,2);
datasetTable.entSQI_3 = datasetTable.entSQI(:,3);
datasetTable.entSQI_4 = datasetTable.entSQI(:,4);
datasetTable.entSQI_5 = datasetTable.entSQI(:,5);
datasetTable.entSQI_6 = datasetTable.entSQI(:,6);
datasetTable.entSQI_7 = datasetTable.entSQI(:,7);
datasetTable.entSQI_8 = datasetTable.entSQI(:,8);
datasetTable.entSQI_9 = datasetTable.entSQI(:,9);
datasetTable.entSQI_10 = datasetTable.entSQI(:,10);
datasetTable.entSQI_11 = datasetTable.entSQI(:,11);
datasetTable.entSQI_12 = datasetTable.entSQI(:,12);
datasetTable.entSQI = [];
datasetTable.purSQI_1 = datasetTable.purSQI(:,1);
datasetTable.purSQI_2 = datasetTable.purSQI(:,2);
datasetTable.purSQI_3 = datasetTable.purSQI(:,3);
datasetTable.purSQI_4 = datasetTable.purSQI(:,4);
datasetTable.purSQI_5 = datasetTable.purSQI(:,5);
datasetTable.purSQI_6 = datasetTable.purSQI(:,6);
datasetTable.purSQI_7 = datasetTable.purSQI(:,7);
datasetTable.purSQI_8 = datasetTable.purSQI(:,8);
datasetTable.purSQI_9 = datasetTable.purSQI(:,9);
datasetTable.purSQI_10 = datasetTable.purSQI(:,10);
datasetTable.purSQI_11 = datasetTable.purSQI(:,11);
datasetTable.purSQI_12 = datasetTable.purSQI(:,12);
datasetTable.purSQI = [];
datasetTable.rsdSQI_1 = datasetTable.rsdSQI(:,1);
datasetTable.rsdSQI_2 = datasetTable.rsdSQI(:,2);
datasetTable.rsdSQI_3 = datasetTable.rsdSQI(:,3);
datasetTable.rsdSQI_4 = datasetTable.rsdSQI(:,4);
datasetTable.rsdSQI_5 = datasetTable.rsdSQI(:,5);
datasetTable.rsdSQI_6 = datasetTable.rsdSQI(:,6);
datasetTable.rsdSQI_7 = datasetTable.rsdSQI(:,7);
datasetTable.rsdSQI_8 = datasetTable.rsdSQI(:,8);
datasetTable.rsdSQI_9 = datasetTable.rsdSQI(:,9);
datasetTable.rsdSQI_10 = datasetTable.rsdSQI(:,10);
datasetTable.rsdSQI_11 = datasetTable.rsdSQI(:,11);
datasetTable.rsdSQI_12 = datasetTable.rsdSQI(:,12);
datasetTable.rsdSQI = [];
datasetTable.pcaSQI_1 = datasetTable.pcaSQI(:,1);
datasetTable.pcaSQI_2 = datasetTable.pcaSQI(:,2);
datasetTable.pcaSQI_3 = datasetTable.pcaSQI(:,3);
datasetTable.pcaSQI_4 = datasetTable.pcaSQI(:,4);
datasetTable.pcaSQI_5 = datasetTable.pcaSQI(:,5);
datasetTable.pcaSQI_6 = datasetTable.pcaSQI(:,6);
datasetTable.pcaSQI_7 = datasetTable.pcaSQI(:,7);
datasetTable.pcaSQI_8 = datasetTable.pcaSQI(:,8);
datasetTable.pcaSQI_9 = datasetTable.pcaSQI(:,9);
datasetTable.pcaSQI_10 = datasetTable.pcaSQI(:,10);
datasetTable.pcaSQI_11 = datasetTable.pcaSQI(:,11);
datasetTable.pcaSQI_12 = datasetTable.pcaSQI(:,12);
datasetTable.pcaSQI = [];
datasetTable.robpcaSQI_1 = datasetTable.robpcaSQI(:,1);
datasetTable.robpcaSQI_2 = datasetTable.robpcaSQI(:,2);
datasetTable.robpcaSQI_3 = datasetTable.robpcaSQI(:,3);
datasetTable.robpcaSQI_4 = datasetTable.robpcaSQI(:,4);
datasetTable.robpcaSQI_5 = datasetTable.robpcaSQI(:,5);
datasetTable.robpcaSQI_6 = datasetTable.robpcaSQI(:,6);
datasetTable.robpcaSQI_7 = datasetTable.robpcaSQI(:,7);
datasetTable.robpcaSQI_8 = datasetTable.robpcaSQI(:,8);
datasetTable.robpcaSQI_9 = datasetTable.robpcaSQI(:,9);
datasetTable.robpcaSQI_10 = datasetTable.robpcaSQI(:,10);
datasetTable.robpcaSQI_11 = datasetTable.robpcaSQI(:,11);
datasetTable.robpcaSQI_12 = datasetTable.robpcaSQI(:,12);
datasetTable.robpcaSQI = [];

% Extract predictors and response

if(iscell(pred_list))
    for i=1:numel(pred_list)
        for j=1:12
            predictorNames{(i-1)*12+j} = [pred_list{i} '_' num2str(j)];
        end
    end
else
    for j=1:12
        predictorNames{j} = [pred_list '_' num2str(j)];
    end
end
predictors = datasetTable(:,predictorNames);
predictors = table2array(varfun(@double, predictors));
response = datasetTable.acc;

% Train a classifier
trainedClassifier = fitcsvm(predictors, response, 'KernelFunction', 'linear', 'PolynomialOrder', [], 'KernelScale', 'auto', 'BoxConstraint', 1, 'Standardize', 1, 'PredictorNames',predictorNames, 'ResponseName', 'acc', 'ClassNames', [0 1]);

% Perform cross-validation
partitionedModel = crossval(trainedClassifier, 'KFold', 5);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

%% Uncomment this section to compute validation predictions and scores:
% % Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

idx = (response==1); 
tp = sum(validationPredictions(idx)==1);
fn = sum(validationPredictions(idx)==0);

idx = (response==0); 
fp = sum(validationPredictions(idx)==1);
tn = sum(validationPredictions(idx)==0);

mat = struct('tp',tp,'fn',fn,'fp',fp,'tn',tn);


