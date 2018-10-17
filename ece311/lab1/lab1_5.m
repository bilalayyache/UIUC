clear all
close all
clc

x = [1 3 -4 -3 4];
N = length(x);
x_label = 1 : N;
X = myDFT(x);
real_X = real(X);
imag_X = imag(X);
% Draw the stem figure
figure;
stem(x_label, real_X);
hold on
stem(x_label, imag_X)
legend('real part of X','imaginary part of X')
xlabel('k')
ylabel('value of X')
title('Discrete Fourier Transform')
