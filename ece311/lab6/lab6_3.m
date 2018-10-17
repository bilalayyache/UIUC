clear all
close all
clc

% design a lowpass filter using hamming window
omega_c = pi/3;
N = 25;
n = 0 : N - 1;
M = 1024;
window = hamming(N)';

omega = 2 * pi * (0:M-1) / M;
omega = fftshift(omega);
omega(1:M/2) = omega(1:M/2) - 2 * pi;

gn = omega_c / pi * sinc(omega_c / pi * (n-12));
hn = gn .* window;

figure(1)
stem(n, hn)
xlabel('n')
ylabel('Impulse response')
title('impulse response of lowpass filter (N = 25)')
grid on

Hn = fft(hn, M);
Hn = fftshift(Hn);

figure(2)
plot(omega, mag2db(abs(Hn)))
grid on
xlabel('\omega (radians)')
ylabel('Magnitude Response (dB)')
title('Magnitude response of lowpass filter (N = 25)')

figure(3)
plot(omega, angle(Hn))
grid on
xlabel('\omega (radians)')
ylabel('Phase Response')
title('Phase response of lowpass filter (N = 25)')