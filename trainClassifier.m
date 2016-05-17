function [trainedClassifier, validationAccuracy] = trainClassifier(datasetTable)
% Extract predictors and response
predictorNames = {'bSQI1', 'bSQI2', 'bSQI3', 'bSQI4', 'bSQI5', 'bSQI6', 'sSQI', 'kSQI', 'pSQI', 'basSQI', 'bsSQI', 'eSQI', 'hfSQI', 'entSQI', 'purSQI', 'rsdSQI', 'pcaSQI', 'robpcaSQI'};
predictors = datasetTable(:,predictorNames);
predictors = table2array(varfun(@double, predictors));
response = datasetTable.acc;
% Data transformation: Select subset of the features
predictors = predictors(:,[true false false false false false false false false false false false false false false false true false]);
% Train a classifier
trainedClassifier = fitcsvm(predictors, response, 'KernelFunction', 'gaussian', 'PolynomialOrder', [], 'KernelScale', 1.100000e+00, 'BoxConstraint', 25, 'Standardize', 1, 'PredictorNames', {'bSQI1' 'pcaSQI'}, 'ResponseName', 'acc', 'ClassNames', [0 1], 'method','LS');

% Perform cross-validation
partitionedModel = crossval(trainedClassifier, 'KFold', 2);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

%% Uncomment this section to compute validation predictions and scores:
% % Compute validation predictions and scores
% [validationPredictions, validationScores] = kfoldPredict(partitionedModel);