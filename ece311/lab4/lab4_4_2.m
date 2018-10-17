clear all
close all
clc

a = [1, 0, 0, 0, 0, 0.1];
b = [1, 0, 0, 0, 0, 0];
N = 1000;

[hh, ff] = freqz(b, a, N);

figure(1);

subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(1,2,2);
plot(ff,phase(hh));
xlabel('Little Omega');
ylabel('Phase');
title('Phase Response');
grid on;

% use tf, pzplot, impz function
S = tf(b, a);
NN = 20;
% draw a unit circle
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);

figure(2);
subplot(121);
pzplot(S);
hold on
plot(x, y, ':')
axis([-1 1 -1 1])
subplot(122);
impz(b, a, NN);
