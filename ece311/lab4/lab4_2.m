clear all
close all
clc

% y[n] = 0.8y[n-1] + 0.2x[n]
% x[n] = cos(pi * n^2 / 10000)

a = 0.8;
b = 0.2;
N = 1000;
bb = [b, 0];
aa = [1, -a];
[hh, ff] = freqz(bb, aa, N);


figure(1);

subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
axis([0, pi, 0, 1.5]);
ylabel('Magnitude');
title('Magnitude Response');
grid on;


subplot(1,2,2);
plot(ff,phase(hh));
xlabel('Little Omega');
axis([0, pi, -4, 1]);
ylabel('Phase');
title('Phase Response');
grid on;

