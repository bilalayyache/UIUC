clear all
close all
clc

n = 0: 50;
k = 1: 10;
for i = 1 : 51
    x(i) = sum((1 ./k) .* sin(0.01.*k.*k*pi.* (i-1)));
end

figure(1)
stem(n, x)
xlabel('n')
ylabel('x[n]')
title('stem plot of x[n]')

% now use filter function to find  v and y
b_H = [1, 0, 0, 0, 0, 0.1];
a_H = [1, 0, 0, 0, 0, 0];

a_Hhat = [1, 0, 0, 0, 0, 0.1];
b_Hhat = [1, 0, 0, 0, 0, 0];

v = filter(b_H, a_H, x);
y = filter(b_Hhat, a_Hhat, v);

figure(2)
subplot(311)
stem(n, x)
xlabel('n')
ylabel('x[n]')
title('stem plot of x[n]')

subplot(312)
stem(n, v)
xlabel('n')
ylabel('v[n]')
title('stem plot of v[n]')

subplot(313)
stem(n, y)
xlabel('n')
ylabel('y[n]')
title('stem plot of y[n]')

diff = x - y;
figure(3)
stem(n, diff)
xlabel('n')
ylabel('difference')
title('difference of x[n] and y[n]')