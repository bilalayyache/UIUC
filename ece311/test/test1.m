clear all
close all
clc

ws1 = pi / 5;
wp1 = pi / 4;
wc1 = (ws1 + wp1) / 2;
delta1 = wp1 - ws1;

wp2 = 0.4 * pi;
ws2 = 0.5 * pi;
wc2 = (wp2 + ws2) / 2;
delta2 = ws2 - wp2;

L = 161;
w = hamming(L)';

n = 0 : (L - 1);
gn = 0.45 * sinc(0.45 * (n - 80)) - 0.225 * sinc(0.225 * (n - 80));
hn = gn .* w;

figure(1)
stem(n, hn)
xlabel('n')
ylabel('h_n')
title('\{h_n\}_{n = 0}^{160}')

figure(2)
H = fft(hn);
H = fftshift(H);
omega = fftshift((0 : L - 1) / L * 2 * pi);
omega(1 : L/2) = omega(1 : L/2) - 2 * pi;
plot(omega, abs(H));
xlabel('\omega')
ylabel('Magnitude Response')
title('Magnitude Response of \{h_n\}')
