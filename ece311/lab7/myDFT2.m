function X = myDFT2(x)
[M, N] = size(x);
X = zeros(M, N);
% first do row fft
for m = 0:(M-1)
    X(m+1, :) = fft(x(m+1, :));
end

% second do column fft
% this fft is based on the result of row fft from last step
for n = 0:(N-1)
    X(:, n+1) = fft(X(:, n+1));
end

