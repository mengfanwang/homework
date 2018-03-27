clc;clear;close all;

data = xlsread('datamatrix.csv');
data = data(:,2:2794);
neighbor = 20; reduced_dimension = 2;

%find k neighbors
[dimension, number] = size(data);
distance = dist(data',data);
[sort_distance, sort_seq] = sort(distance);

% just if neighbor>dimension and z will be full-rank or not
if neighbor > dimension
    tol = 0.001;
else
    tol = 0;
end

% W = zeros(number, number);
W = zeros(neighbor, number);
for ii = 1:number
    xi = repmat(data(:,ii),1,neighbor);
    xj = data(:,sort_seq(2:neighbor+1,ii));
    Z = (xi-xj)'*(xi-xj);
    Z = Z + eye(neighbor,neighbor)*tol*trace(Z);
    W(:,ii) = inv(Z)*ones(neighbor,1)/(ones(1,neighbor)*inv(Z)*ones(neighbor,1));  
%     W(:,ii) = Z\ones(neighbor,1);                           % solve Cw=1
%     W(:,ii) = W(:,ii)/sum(W(:,ii)); 
end
% M = (1-W)'*(1-W);
N = number;
K = neighbor;
M = sparse(1:N,1:N,ones(1,N),N,N,4*K*N); 
for ii=1:number
   w = W(:,ii);
   jj = sort_seq(2:neighbor+1,ii);
   M(ii,jj) = M(ii,jj) - w';
   M(jj,ii) = M(jj,ii) - w;
   M(jj,jj) = M(jj,jj) + w*w';
end

options.disp = 0; options.isreal = 1; options.issym = 1; 
[vectors,values] = eigs(M,reduced_dimension+1,0,options);

Y = vectors(:,2:reduced_dimension+1)'*sqrt(number);
plot(Y(1,:),Y(2,:),'r.');


