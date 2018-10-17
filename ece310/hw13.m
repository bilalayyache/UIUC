clear all
close all
clc

% set parameters
L = 2;
M = 3;
omega_c = pi;

% X
N = 6000;
omega = linspace(-pi, pi, N);
X = 1 - abs(omega)/pi;
x = ifft(ifftshift(X));

% W
w = upsample(x, L);
W = fftshift(fft(w));
omega_w = linspace(-pi, pi, N*L);


% LPF
lpf = zeros(1, N*L);
index_l = N*L/2 - omega_c/(2*pi)*N*L+1;
index_h = N*L/2 + omega_c/(2*pi)*N*L;
lpf(index_l:index_h) = L;

% HPF
hpf = 1 - lpf;

% V
V = W .* lpf;
V_H = W .* hpf;
v = ifft(ifftshift(V));
v_H = ifft(ifftshift(V_H));

% Y
y = downsample(v, M);
y_H = downsample(v_H, M);
Y = fftshift(fft(y));
Y_H = fftshift(fft(y));

omega_y = linspace(-pi, pi, N*L/M);
figure()

subplot(321)
plot(omega/pi, X)
title('X_d(\omega)')
xlabel('\omega/pi')

subplot(322)
plot(omega_w/pi, abs(W))
title('W_d(\omega)')
xlabel('\omega/\pi')

subplot(323)
plot(omega_w/pi, abs(V))
title('V_d(\omega)')
xlabel('\omega/\pi')

subplot(324)
plot(omega_y/pi, abs(Y))
title('Y_d(\omega)')
xlabel('\omega/\pi')

subplot(325)
plot(omega_w/pi, abs(V_H))
title('V_d(\omega)-HPF')
xlabel('\omega/\pi')

subplot(326)
plot(omega_y/pi, abs(Y_H))
title('Y_d(\omega)-HPF')
xlabel('\omega/\pi')
