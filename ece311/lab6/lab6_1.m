clear all
close all
clc

N = 40;
% N = 40;
M = 1024;
n = -N : N;
omega = 2 * pi / M * (0 : M - 1);
omega = fftshift(omega);
omega(1:M/2) = omega(1:M/2) - 2 * pi;
delta = zeros(1, 2 * N + 1);
delta(N + 1) = 1;
omega_c = pi / 4;
omega_0 = pi / 2;

% lowpass filter
h_low = omega_c / pi * sinc(omega_c / pi * n);
H_low = fft(h_low, M);
H_low = fftshift(H_low);

figure(1)
subplot(211)
stem(n, h_low)
xlabel('n')
ylabel('Impulse response')
title('impulse response of lowpass filter (N = 40)')
subplot(212)
plot(omega, abs(H_low))
xlabel('\omega (radians)')
ylabel('Magnitude Response')
title('Magnitude response of lowpass filter (N = 40)')

% bandpass filter
h_band = cos(omega_0 * n) .* h_low;
H_band = fft(h_band, M);
H_band = fftshift(H_band);

figure(2)
subplot(211)
stem(n, h_band)
xlabel('n')
ylabel('Impulse response')
title('impulse response of bandpass filter (N = 40)')
subplot(212)
plot(omega, abs(H_band))
xlabel('\omega (radians)')
ylabel('Magnitude Response')
title('Magnitude response of bandpass filter (N = 40)')

% highpass filter
h_high = delta - h_low;
H_high = fft(h_high, M);
H_high = fftshift(H_high);

figure(3)
subplot(211)
stem(n, h_high)
xlabel('n')
ylabel('Impulse response')
title('impulse response of highpass filter (N = 40)')
subplot(212)
plot(omega, abs(H_high))
xlabel('\omega (radians)')
ylabel('Magnitude Response')
title('Magnitude response of highpass filter (N = 40)')