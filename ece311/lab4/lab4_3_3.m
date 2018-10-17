clear all
close all
clc

% set parameters
N = 1000;
n = 0: N;
B = 10;
F_s = 100;

omega = linspace(0, pi/5, 1001);
hh_1000 = 0.2 ./ (1 - 0.8*exp(-j*omega));

b = [0.2, 0];
a = [1, -0.8];
x = cos((pi*B/F_s/N).*n .*n);
y = filter(b, a, x);

figure(1)
plot(n, y);
hold on;
plot(n,abs(hh_1000));
xlabel('n');
ylabel('Magnitude response and output y[n]');
title('Magnitude Response and output y[n]');
legend('Manitude response','output y[n]');
grid on;