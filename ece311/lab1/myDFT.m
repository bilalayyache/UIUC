function [ X ] = myDFT( x )
%   Detailed explanation goes here
%   The input of the function is x(n) and the output of the function is the
%   result of the Discrete Fourier Transfer X(k)

% First find the length of array x(n)
N = length(x);

% Begin the loop to calculate the DFT
for k = 1 : N
    Sum = 0;
    for n = 1 : N
        Sum = Sum + x(n)*exp(-i*2*pi*(k-1)*(n-1)/N);
    end
    X(k) = Sum;
end
% End of the function
end

