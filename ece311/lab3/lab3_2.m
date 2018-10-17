% X(z) = 
clear all
close all
clc

b_X = [2, -1/6, 0];
a_X = [1 -1/6, -1/6];
S_X = tf(b_X, a_X);

delta = zeros(1, 20);
delta(1) = 1;
n = 0 : 19;

x = filter(b_X, a_X, delta);
x_origin = (1/2).^n + (-1/3).^n;
diff = x - x_origin;

figure(1);
subplot(211)
stem(n, x);
title('x from filter function')
xlabel('n')
ylabel('value of x[n]')
subplot(212);
stem(n, x_origin, 'r');
title('x from the expression')
xlabel('n')
ylabel('value of x[n]')

figure(2);
stem(n, diff)
title('difference between two method')
xlabel('n')
ylabel('difference')
