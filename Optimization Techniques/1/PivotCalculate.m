clc;clear;
format rat;
A= [ 1 -2 -1 2 0 1 0 0
     2 -3 -1 1 0 0 1 0
     0 0 1 0 1 0 0 1
     -3 5 -1 2 0 0 0 0 ];
A=[1             -2              1              2              1              1              0              1       
       2             -3              1              1              1              0              1              1       
       0              0              1              0              1              0              0              1       
      -3              5              1              2              1              0              0              1  ];
B = A*0;
m = 2;
n = 1;
for ii = 1:size(A,1)
    for jj = 1:size(A,2)
        if ii == m && jj ==n
            B(ii,jj) = 1/A(ii,jj);
        elseif ii == m && jj~= n
            B(ii,jj) = A(ii,jj)/A(m,n);
        elseif ii~= m && jj==n
            B(ii,jj) = -A(ii,jj)/A(m,n);
        elseif 11~=m && jj~=n
            B(ii,jj) = A(ii,jj)-A(ii,n)*A(m,jj)/A(m,n);
        end
    end
end
B
         