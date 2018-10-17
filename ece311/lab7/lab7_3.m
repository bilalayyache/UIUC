clear all
close all
clc

load('songz.mat');
data = good_news(1:end-1);
N = length(data);
n = 0:N-1;
omega = 2 * pi * n / N;
omega = fftshift(omega);
omega(1:N/2) = omega(1:N/2) - 2 * pi;
fs = 48000;
DATA = fftshift(fft(data));
f = omega * fs / (2*pi);

figure()
plot(f, abs(DATA))
title('magnitude spectrum of input signal')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

%{
% LPF to filter out the high frequency part
f_c = [0.8e4, 0.85e4];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];

[n, fo, mo, w] = firpmord(f_c, a, rp, fs);
b = firpm(n, fo, mo, w);
aa = zeros(1, length(b));
aa(1) = 1;
data_filter = filter(b, aa, data);

DATA_filter = fftshift(fft(data_filter));
figure()
plot(f, abs(DATA_filter))
%}

% downsample
D = 3;
data_d = downsample(data, D);
DATA_d = fftshift(fft(data_d));

fs_d = fs / D;
N_d = length(data_d);
n_d = 0:N_d-1;

omega_d = 2*pi*n_d/N_d;
omega_d = fftshift(omega_d);
omega_d(1:N_d/2) = omega_d(1:N_d/2) - 2*pi;
f_d = omega_d * fs_d / (2*pi);

figure()
plot(f_d, abs(DATA_d));
title('magnitude spectrum of signal after downsampling')
xlabel('\Omega (Hz)')
ylabel('magnitude spetrum')

% upsample
U = 3;
data_u = upsample(data_d, U);
DATA_u = fftshift(fft(data_u));

figure()
plot(f, abs(DATA_u))
title('magnitude spectrum of signal after upsampling')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')

% apply LPF 
f_c = [0.79e4, 0.81e4];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];

[n, fo, mo, w] = firpmord(f_c, a, rp, fs);
b = firpm(n, fo, mo, w);
lpf = 3 * b;
aa = zeros(1, length(b));
aa(1) = 1;
data_filter = filter(b, aa, data_u);

LPF = fftshift(fft(lpf, 1000));
omega_filter = linspace(-pi, pi, 1000);
f_filter = omega_filter * fs / (2*pi);
figure()
plot(f_filter, mag2db(abs(LPF)))
xlabel('\Omega (Hz)')
ylabel('magnitude response (dB)')
title('magnitude response of LPF in dB scale')

DATA_filter = fftshift(fft(data_filter));
figure()
plot(f, abs(DATA_filter))
title('magnitude spectrum after applying LPF')
xlabel('\Omega (Hz)')
ylabel('magnitude spectrum')