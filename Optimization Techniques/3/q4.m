clc;clear;close all;

data = xlsread('datamatrix.csv');
data = data(:,2:2794);
data2 = PCA(data,2);
plot(data(1,:),data(2,:),'r.');


function data_PCA = PCA(data,dimension)
    %This function is used to implement PCA algorithm.
    %Input:  data-------- Each column is a data point. All data points
    %                     should have the same dimension of features.
    %        dimension--- The dimension data will be reduced to.
    %Output: data_PCA---- The new data after transformation. Each column
    %                     is a data point.
    
    data = (data-mean(data,2))./sqrt(var(data,[],2)); %normalization
    [U,S,V] = svd(data);
    data_PCA = U(:,1:dimension)'*data;
end