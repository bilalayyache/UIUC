clear all
close all
clc

L = 40;
k = (L-1)/2;
n = 0 : (L - 1);
w1 = ones(1, L);
w2 = hamming(L)';

omega = 0.8*pi*n/L;
omega = fftshift(omega);
omega(1:L/2) = omega(1:L/2) - 0.8*pi;

Gd = exp(-j * k * omega);
Gd = ifftshift(Gd);
gn = ifft(Gd);

hn1 = gn .* w1;
figure(1)
stem(n, hn1)
hn2 = gn .* w2;

Hd1 = fftshift(fft(hn1));
Hd2 = fftshift(fft(hn2));

figure(2)
plot(omega, abs(Hd1))
figure(3)
plot(omega, mag2db(abs(Hd1)))

