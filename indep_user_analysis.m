clc;
close all;
clear;

index = 3;
[Fs,Fs_lab]=feature_extraction(index);

%%

y1=Fs(1,:);
y2=Fs(2,:);
x=1:size(Fs,2);
figure;
plot(x,y1,x,y2);
legend('non-eating','eating');
X=Fs;
p=5;
[coeff,score,latent] = pca(X,'NumComponents', p);

feature0 = score;
lab0 = Fs_lab;

%%

train_trate=0.6;
L=length(feature0);
train_len=floor(L*0.6);
test_len=L-train_len;
train_0=feature0(1:train_len,:);
labtrain_0=lab0(1:train_len);
test_0=feature0(train_len+1:L,:);
labtest_0=lab0(train_len+1:L);

%%

Mdl_0 = fitctree(train_0,labtrain_0,'OptimizeHyperparameters','auto');
pre_label_decision_0 = predict(Mdl_0,test_0);
[acc_dt, prec_dt, rec_dt, f1_dt] = metrics(pre_label_decision_0, labtest_0);

SVMModel_0 = fitcsvm(train_0,labtrain_0,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
pre_label_svm_0 = predict(SVMModel_0,test_0);
[acc_svm, prec_svm, rec_svm, f1_svm] = metrics(pre_label_svm_0, labtest_0);

pre_label_nn_0=neurl_net(feature0,lab0);
[acc_nn, prec_nn, rec_nn, f1_nn] = metrics(pre_label_nn_0', labtest_0);