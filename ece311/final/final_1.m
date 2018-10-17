clear all;
close all;
clc

load('song1.mat');
SIGP = fftshift(fft(sigp));
N = length(sigp);
n = 0:N-1;
omega = n * (2*pi) / N;
omega = fftshift(omega);
omega(1:N/2) = omega(1:N/2) - 2*pi;
fs = 44100;
f = omega * fs / (2*pi);


figure()
subplot(211)
plot(f, abs(SIGP));
axis([-1500 1500 0 3e5])
title('magnitude spectrum of song1')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f, angle(SIGP));
title('phase spectrum of song1')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')

% design a lowpass filter to filter out the contaminating pitch
f_c = [900, 1000];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];

[n, fo, mo, w] = firpmord(f_c, a, rp, fs);
b = firpm(n, fo, mo, w);
aa = zeros(1, length(b));
aa(1) = 1;
sigp_filter = filter(b, aa, sigp);

SIGP_filter = fftshift(fft(sigp_filter));
figure()
subplot(211)
plot(f, abs(SIGP_filter));
title('magnitude spectrum of song1')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f, angle(SIGP_filter));
title('phase spectrum of song1')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')