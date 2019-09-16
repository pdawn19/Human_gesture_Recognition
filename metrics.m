function [Accuracy, Precision, Recall, F1] = metrics(ypred,ytrue)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    tp = sum(( ypred == 1) & ( ytrue == 1));
    fp = sum(( ypred == 1) & ( ytrue == 0));
    fn = sum(( ypred == 0) & ( ytrue == 1));
    tn = sum(( ypred == 0) & ( ytrue == 0));
    Accuracy = (tp + tn)/(tp + tn + fn + fp);
    Precision = tp / (tp + fp);
    Recall = tp / (tp + fn);
    F1 = (2 * Precision * Recall) / (Precision + Recall);
end

