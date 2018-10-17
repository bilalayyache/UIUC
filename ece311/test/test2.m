clear all
close all
clc

N = 132;
M = 1024;
fs = 40 * 1000;
n = 0:N-1;
coeff = (-1).^(n+1);
window = hamming(N)';

h = 23/40 * coeff .* sinc(23/40*(n-(N-1)/2)) .* window;

H = fftshift(fft(h, M));
omega = 2*pi * (0:M-1) / M;
omega = fftshift(omega);
omega(1:M/2) = omega(1:M/2) - 2*pi;


figure()
stem(n, h)
figure()
plot(omega, mag2db(abs(H)))

F = omega * fs / (2*pi);
figure()
plot(F*2, mag2db(abs(H)))
figure()
plot(F, mag2db(abs(H)))
figure()
plot(F, abs(H))
axis([9000, 21000, 0.98, 1.02])
figure()
plot(F*2, angle(H))