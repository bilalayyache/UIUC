clear all
close all
clc

load('song1_corrupt.mat');
data = song1_corrupt;
DATA = fftshift(fft(data));
N = length(data);

n = 0:N-1;
omega = 2*pi*n/N;
omega = fftshift(omega);
omega(1:N/2) = omega(1:N/2) - 2*pi;
fs = 44100;
f = omega * fs / (2*pi);

figure()
subplot(211)
plot(f, abs(DATA))
title('magnitude spectrum of song1\_corrupt')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f, angle(DATA))
title('phase spectrum of song1\_corrupt')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')


% downsample D = 2
D = 2;
fs_d = fs / D;
data_d = downsample(data, D);
DATA_d = fftshift(fft(data_d));
N_d = length(data_d);
n_d = 0:N_d-1;

omega_d = 2*pi*n_d/N_d;
omega_d = fftshift(omega_d);
omega_d(1:N_d/2) = omega_d(1:N_d/2) - 2*pi;
f_d = omega_d * fs_d / (2*pi);


figure()
subplot(211)
plot(f_d, abs(DATA_d))
title('magnitude spectrum of song1\_corrupt after downsampling')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f_d, angle(DATA_d))
title('phase spectrum of song1\_corrupt after downsampling')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')

% design a LPF
% transition band from 1e4 to 1.5e4 Hz
f_c = [1e4, 1.5e4];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];

[n, fo, mo, w] = firpmord(f_c, a, rp, fs);
b = firpm(n, fo, mo, w);
aa = zeros(1, length(b));
aa(1) = 1;
data_filter = filter(b, aa, data);

% redraw the frequency spectrum after LPF
DATA_filter = fftshift(fft(data_filter));
figure()
subplot(211)
plot(f, abs(DATA_filter))
title('magnitude spectrum of song1\_corrupt after LPF')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f, angle(DATA_filter))
title('phase spectrum of song1\_corrupt after LPF')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')

% redraw the frequency spectrum after downsampling
data_filter_d = downsample(data_filter, D);
DATA_filter_d = fftshift(fft(data_filter_d));

figure()
subplot(211)
plot(f_d, abs(DATA_filter_d))
title('magnitude spectrum of song1\_corrupt after LPF and downsampling')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

subplot(212)
plot(f_d, angle(DATA_filter_d))
title('phase spectrum of song1\_corrupt after LPF and downsampling')
xlabel('\Omega (Hz)')
ylabel('phase spectrum')