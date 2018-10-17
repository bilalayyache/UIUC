clear all
close all
clc

N = 10;
f_0 = 5;
dt = 0.02;
n = 0 : N-1;
x = sin(2 * pi * f_0 * n * dt);

X = fft(x, N);
X_shift = fftshift(X);
omega = fftshift((0 : N - 1) / N * 2 * pi);
omega(1 : N/2) = omega(1 : N/2) - 2 * pi;
Omega = omega * f_0;

figure(1);
subplot(121)
stem(Omega, abs(X_shift));
axis([-20, 20, 0, 5]);
xlabel('\Omega (Hz)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122);
stem(Omega, angle(X_shift));
axis([-20, 20, -3, 3])
xlabel('\Omega (Hz)');
ylabel('Phase');
title('Phase Response');
grid on;