clc;
close all;
clear;

load ('labelled_data','MyoData','GData')
n = length(MyoData.spoon.EMG.Data);
metrics_user = zeros(n,12);

%%

for i = 1:n
    [Fs,Fs_lab] = dep_user_data(MyoData, i, 3);
    if isempty(Fs)
        continue;
    end
    y1=Fs(1,:);
    y2=Fs(2,:);
    x=1:size(Fs,2);
    X=Fs;
    
    % Do the PCA
    p=5;
    [coeff,score,latent] = pca(X,'NumComponents', p);

    %PCA projected Data
    Z = score;

    %% split train and test data
    train_trate = 0.6;
    L = length(Z);
    train_len = floor(L*train_trate);
    test_len = L-train_len;
    train_0 = Z(1:train_len,:);
    labtrain_0 = Fs_lab(1:train_len);
    test_0 = Z(train_len+1:L,:);
    labtest_0 = Fs_lab(train_len+1:L);

    % Classification models
    Mdl_0 = fitctree(train_0,labtrain_0,'OptimizeHyperparameters','auto');
    pre_label_decision_0 = predict(Mdl_0,test_0);
    [acc_dt, prec_dt, rec_dt, f1_dt] = metrics(pre_label_decision_0, labtest_0);

    SVMModel_0 = fitcsvm(train_0,labtrain_0,'Standardize',true,'KernelFunction','RBF',...
        'KernelScale','auto');
    pre_label_svm_0 = predict(SVMModel_0,test_0);
    [acc_svm, prec_svm, rec_svm, f1_svm] = metrics(pre_label_svm_0, labtest_0);
    
    pre_label_nn_0=neurl_net(Z,Fs_lab);
    [acc_nn, prec_nn, rec_nn, f1_nn] = metrics(pre_label_nn_0', labtest_0);
    
    %use the below if you dont want plots and only want metrics
    %close all;
    %clc;
    
    metrics_user(i,:) = [acc_dt, prec_dt, rec_dt, f1_dt, acc_svm, prec_svm, rec_svm, f1_svm, acc_nn, prec_nn, rec_nn, f1_nn];

end

%% Plots

figure;
subplot(2,2,1);
plot(metrics_user(:,1), '-*');
grid on;
title 'Accuracy'
subplot(2,2,2);
plot(metrics_user(:,2), '-*');
grid on;
title 'Precision'
subplot(2,2,3);
plot(metrics_user(:,3), '-*');
grid on;
title 'Recall'
subplot(2,2,4);
plot(metrics_user(:,4), '-*');
grid on;
title 'F1'
suptitle 'Decision Tree Plots'

figure;
subplot(2,2,1);
plot(metrics_user(:,5), '-*');
grid on;
title 'Accuracy'
subplot(2,2,2);
plot(metrics_user(:,6), '-*');
grid on;
title 'Precision'
subplot(2,2,3);
plot(metrics_user(:,7), '-*');
grid on;
title 'Recall'
subplot(2,2,4);
plot(metrics_user(:,8), '-*');
grid on;
title 'F1'
suptitle 'SVM Plots'

figure;
subplot(2,2,1);
plot(metrics_user(:,9), '-*');
grid on;
title 'Accuracy'
subplot(2,2,2);
plot(metrics_user(:,10), '-*');
grid on;
title 'Precision'
subplot(2,2,3);
plot(metrics_user(:,11), '-*');
grid on;
title 'Recall'
subplot(2,2,4);
plot(metrics_user(:,12), '-*');
grid on;
title 'F1'
suptitle 'Neural Net Plots'