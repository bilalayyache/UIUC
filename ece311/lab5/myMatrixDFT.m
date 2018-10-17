function Z = DFTMatrix(x)
% X is the output vector that indicates the DFT of the input vector x
N = length(x);
k = 0 : (N-1);
W_N = exp(j * 2 * pi / N);
temp = k' * k;
Z = W_N .^ (-temp);
end