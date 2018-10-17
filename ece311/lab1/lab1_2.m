clear all
close all
clc

a = 0;
b = 5;
N = 100;
x = linspace(a, b, N);
f = x .* x .* log(x) .* sin(x);
figure;
plot(x,f)
title('Graph of a function of x')
xlabel('x')
ylabel('y')