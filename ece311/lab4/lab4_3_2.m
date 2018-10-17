clear all
close all
clc

% set parameters
B = 10;
F_s = 100;
N = 1000;

n = 0:1000;
x = cos((pi*B/F_s/N).*n .*n);
figure(1)
plot(n,x)
xlabel('n')
ylabel('x[n]')
title('values of x[n] for 10 seconds')

% use filter function to find output
b = [0.2, 0];
a = [1, -0.8];

y = filter(b, a, x);
figure(2)
plot(n,y)
xlabel('n')
ylabel('y[n]')
title('values of y[n] from filter function')
