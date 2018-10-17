function Z = DFTMatrix(n)
% n is input dimension
k = 0 : (n-1);
W_N = exp(j * 2 * pi / n);
temp = k' * k;
Z = W_N .^ (-temp);
end