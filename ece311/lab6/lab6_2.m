clear all
close all
clc

load('impulseresponse.mat');
N = length(h);
n = 0:(N-1);

figure(1)
stem(n, h)
xlabel('n')
ylabel('Impulse response')
title('Impulse response for imported signal')

% do zero padding
M = 512;
omega = 2 * pi / M * (0 : M-1);
omega = fftshift(omega);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;
H = fft(h, M);
H_shift = fftshift(H);

figure(2);
plot(omega, mag2db(abs(H_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude (dB)');
title('Magnitude Response');
grid on;

figure(3)
plot(omega, angle(H_shift));
xlabel('\omega (radians)');
ylabel('Phase');
title('Phase Response');
grid on;