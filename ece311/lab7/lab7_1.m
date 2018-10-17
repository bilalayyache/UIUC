clear all
close all
clc

data = audioread('audioclip.wav');
fs = 66150;
N = size(data, 1);

% set frequency for plot
n = 0:(N-1);
omega = 2*pi*n / N;
omega = fftshift(omega);
omega(1:N/2) = omega(1:N/2) - 2 * pi;
Omega = omega * fs;
f = Omega / (2 * pi);

% first plot the magnitude spectrum before upsampling
data1 = data(:, 1);
data2 = data(:, 2);

DATA1 = fftshift(fft(data1));
DATA2 = fftshift(fft(data2));

figure()
plot(f, mag2db(abs(DATA1)));
title('magnitude spectrum of left channel')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

figure()
plot(f, mag2db(abs(DATA2)));
title('magnitude spectrum of right channel')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

%% first do upsample U = 2
U = 2;
fs_u = fs * U;
data1_u = upsample(data1, U);
data2_u = upsample(data2, U);
DATA1_u = fftshift(fft(data1_u));
DATA2_u = fftshift(fft(data2_u));

% set new frequency indices
N_u = length(data1_u);
n_u = 0:(N_u - 1);
omega_u = 2*pi*n_u / N_u;
omega_u = fftshift(omega_u);
omega_u(1:N_u/2) = omega_u(1:N_u/2) - 2 * pi;
Omega_u = omega_u * fs_u;
f_u = Omega_u / (2 * pi);

% plot magnitude spectrum after upsampling but before LPF
figure()
plot(f_u, mag2db(abs(DATA1_u)))
title('magnitude spectrum of left channel after upsampling before LPF')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

figure()
plot(f_u, mag2db(abs(DATA2_u)));
title('magnitude spectrum of right channel after upsampling before LPF')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

%% disign a LPF with f_c = fs / 2
f_c = fs / 2;
coeff = f_c / N_u;
% create LPF
% first find the index of f_c = fs/2
index_l = find(~(f_u+f_c));
index_h = find(~(f_u-f_c));

lpf = zeros(N_u, 1);
lpf(index_l:index_h) = U;

% apply LPF to upsampled signal
DATA1_uf = DATA1_u .* lpf;
DATA2_uf = DATA2_u .* lpf;

% plot magnitude spectrum after upsampling and after LPF
figure()
plot(f_u, mag2db(abs(DATA1_uf)))
title('magnitude spectrum of left channel after LPF')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

figure()
plot(f_u, mag2db(abs(DATA2_uf)));
title('magnitude spectrum of right channel after LPF')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

data1_uf = ifft(ifftshift(DATA1_uf));
data2_uf = ifft(ifftshift(DATA2_uf));

%% downsampling D = 3
D = 3;
data1_d = downsample(data1_uf, 3);
data2_d = downsample(data2_uf, 3);
data_d = [data1_d, data2_d];
DATA1_d = fftshift(fft(data1_d));
DATA2_d = fftshift(fft(data2_d));

N_d = length(data1_d);
n_d = 0:(N_d - 1);
fs_d = fs_u / D;
omega_d = 2*pi*n_d / N_d;
omega_d = fftshift(omega_d);
omega_d(1:N_d/2) = omega_d(1:N_d/2) - 2 * pi;
Omega_d = omega_d * fs_d;
f_d = Omega_d / (2 * pi);

% plot magnitude spectrum
figure()
plot(f_d, mag2db(abs(DATA1_d)))
title('magnitude spectrum of left channel after downsampling')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')

figure()
plot(f_d, mag2db(abs(DATA2_d)));
title('magnitude spectrum of right channel after downsampling')
xlabel('analog frequency \Omega (Hz)')
ylabel('magnitude spectrum')


