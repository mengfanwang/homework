clc;clear;close all;
data = xlsread('datamatrix.csv');
X = data(:,2:2794);
d = 2;
for ii = 1:4
if ii == 1
K = 5;
elseif ii == 2
K = 10;
elseif ii == 3
K = 20;
elseif ii == 4
K = 100;
end
Y = LLE(X,K,d);
figure(ii),plot(Y(1,:),Y(2,:),'r.');
end
function [Y] = LLE(X,K,d)
%This function is used to implemeant LLE algorithm.
%Input: X----------- Each column is a data point. All data points
% should have the same dimension of features.
% K----------- The number of neighbors.
% d----------- The dimension data will be reduced to.
%Output: Y----------- The new data after transformation. Each column
% is a data point.
[D,N] = size(X);
distance = dist(X',X);
% find neighbors
[sorted,index] = sort(distance);
neighbor = index(2:(1+K),:);
% If K>D, the local covariance will not be full rank
if K>D
tol=0.001;
else
tol=0;
end
%Calculate W
W = zeros(K,N);
for ii=1:N
x_ij = X(:,neighbor(:,ii))-repmat(X(:,ii),1,K);
Z = x_ij' *x_ij;
Z = Z + eye(K,K) * tol * trace(Z);
W(:,ii) = Z\ones(K,1);
W(:,ii) = W(:,ii)/sum(W(:,ii));
end
%Calculte M
M = sparse(1:N,1:N,ones(1,N),N,N);
for ii=1:N
w = W(:,ii);
jj = neighbor(:,ii);
M(ii,jj) = M(ii,jj) - w';
M(jj,ii) = M(jj,ii) - w;
M(jj,jj) = M(jj,jj) + w * w';
end
%Use eigen decomposition to get the new data
[Y,values] = eigs(M,d+1,0);
Y = Y(:,1:d)';
end