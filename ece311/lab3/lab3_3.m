clear all
close all
clc

% h[n] = 2(1/3)^n * u[n] - 2(1/3)^(n-1) * u[n-1]
n = 0 : 19;
u = ones(1, 20);
u(1) = 0;
h = 2*(1/3).^n - 2*(1/3).^(n-1) .* u;

figure(1);
stem(n, h);
title('stem graph for impulse response h')
xlabel('n')
ylabel('value of h[n]')

% x[n] = (1/2)^n * u[n]
x = (1/2).^n;
y = conv(x, h);
y = y(1:20);
figure(2);
stem(n, y);
title('stem graph for output y')
xlabel('n')
ylabel('value of y[n]')


