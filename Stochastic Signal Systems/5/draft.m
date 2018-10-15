syms y
syms z

s = 2*besselk(0, 2*z^(1/2));
int(s,[0 inf])