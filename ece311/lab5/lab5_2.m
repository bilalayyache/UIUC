clear all
close all
clc

load('signal.mat');
X = fft(x);
N = length(x);

X_shift = fftshift(X);
omega = fftshift((0 : N - 1) / N * 2 * pi);
omega(1 : N/2) = omega(1 : N/2) - 2 * pi;

figure(1);

subplot(1,2,1);
plot(omega,abs(X_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(1,2,2);
plot(omega,angle(X_shift));
xlabel('\omega (radians)');
ylabel('Phase');
title('Phase Response');
grid on;

f_s = 200;
Omega = omega * f_s / (2 * pi);

figure(2);

subplot(1,2,1);
plot(Omega,abs(X_shift));
xlabel('\Omega (Hz)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(1,2,2);
plot(Omega,angle(X_shift));
xlabel('\Omega (Hz)');
ylabel('Phase');
title('Phase Response');
grid on;

