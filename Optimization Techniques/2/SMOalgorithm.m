function [a,w,b] = SMOalgorithm(x,y,C,maxIter)
    % This program is used for calculte the optimal solution of linear SVM
    % problems.
    % Input:
    % x —————— m by n matrix, which is the feature of samples. m is 
    %              the dimension of feature and n is the number of samples.
    % y —————— n dimenion vectors, which is the label of samples. Values
    %              should be -1 or 1.
    % C——————- box constraint
    % maxIter——— maximum iterations. If no input, maxIter = 100
    
    % Output:
    % a —————— n dimension vectors, alpha for dual problems.
    % w —————— m dimension vectors, normal vector of the hyperplane
    % b —————— intercept

% set initial parameters
m = size(x,2);
a = zeros(1,m);
b = 0;
KKT = 0;
w = 0;

if nargin < 4
    maxIter = 100;
end
            
iter = 1;
while KKT ~= 1 && iter < maxIter

    for ii = 1:m
        
        % use heuristics to decide a of the outside loop 
        satisfy = judgeKKT(a(ii),y(ii),w,x(:,ii),b,C);
        if satisfy == 1
            continue
        end
        
        %a of inner loop is decided randomly
        jj=ii;
        while jj==ii
            jj=randi(m);
        end
        
        %calculate the new value of a1 and a2
        w = sum(a.*y.*x,2);
        e1 = w'*x(:,ii) + b - y(ii);
        e2 = w'*x(:,jj) + b - y(jj);
        eta = - 2*x(:,ii)'*x(:,jj) + x(:,ii)'*x(:,ii) + x(:,jj)'*x(:,jj);
        a_2new = a(jj) + y(jj)*(e1-e2)/eta;
        if y(ii)~= y(jj)
            L = max(0, a(jj)-a(ii));
            H = min(C, C + a(jj)-a(ii));
        elseif y(ii) == y(jj)
            L = max(0, a(jj)+a(ii) - C);
            H = min(C, a(jj)+a(ii));
        end
        if a_2new >= H
            a_2clipped = H;
        elseif a_2new <= L
            a_2clipped = L;
        elseif a_2new > L && a_2new < H
            a_2clipped = a_2new;
        end
        if abs(a_2clipped - a(jj)) < 0.001
            continue
        end
        a_1new = a(ii) + y(ii)*y(jj)*(a(jj)-a_2clipped);
        
        %calculate w and b
        w = sum(a.*y.*x,2);
        e1 = w'*x(:,ii) + b - y(ii);
        e2 = w'*x(:,jj) + b - y(jj);
        b1 = - e1 - y(ii)*(a_1new - a(ii))*x(:,ii)'*x(:,ii) - y(jj)*(a_2clipped-a(jj))*x(:,ii)'*x(:,jj)+b;
        b2 = - e2 - y(ii)*(a_1new - a(ii))*x(:,ii)'*x(:,jj) - y(jj)*(a_2clipped-a(jj))*x(:,jj)'*x(:,jj)+b;
        a(ii) = a_1new;
        a(jj) = a_2clipped;
        if a(jj)>0 && a(jj)<C
            b = b2;
        elseif a(ii)>0 && a(ii)<C
            b = b1;
        else
            b = (b1+b2)/2;
        end
        
    end
    % judge by KKT conditions
    KKT = 1;
    for ii = 1:m
        satisfy = judgeKKT(a(ii),y(ii),w,x(:,ii),b,C);
        if satisfy == 0
            KKT = 0;
        end
    end
    iter = iter + 1;
    %ouput updated a
    fprintf('a=');disp(a);
end
fprintf('w=\n');disp(w);
fprintf('b=');disp(b);
end


function satisfy = judgeKKT(a,y,w,x,b,C)
    %subfunction to judge if KKT conditions is satisfied
    if a == 0
        if y*(w'*x+b) >= 1
            satisfy = 1;
        else
            satisfy = 0;
        end
    elseif a == C
        if y*(w'*x+b) <= 1
            satisfy = 1;
        else
            satisfy = 0;
        end
    elseif a>0 && a<C
        if y*(w'*x+b) == 1
            satisfy = 1;
        else
            satisfy = 0;
        end
    end
end