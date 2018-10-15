clc;clear;close all;
e = 0:0.01:1;
x = (1-e).^(-1/2);
plot(e,x);
xlabel('\xi');ylabel('X');