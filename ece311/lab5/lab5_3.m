clear all
close all
clc

load('NMRSpec.mat');
N_1 = 32;
f_s = 2000;

ST = fft(st, N_1);
ST_shift = fftshift(ST);
omega = fftshift((0 : N_1 - 1) / N_1 * 2 * pi);
omega(1 : N_1/2) = omega(1 : N_1/2) - 2 * pi;
Omega = omega * f_s / (2 * pi);

figure(1);

subplot(1,2,1);
plot(Omega,abs(ST_shift));
xlabel('\Omega (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum');
grid on;


subplot(1,2,2);
plot(Omega,angle(ST_shift));
xlabel('\Omega (Hz)');
ylabel('Phase');
title('Phase Spectrum');
grid on;

N_2 = 512;

ST = fft(st, N_2);
ST_shift = fftshift(ST);
omega = fftshift((0 : N_2 - 1) / N_2 * 2 * pi);
omega(1 : N_2/2) = omega(1 : N_2/2) - 2 * pi;
Omega = omega * f_s / (2 * pi);

figure(2);

subplot(1,2,1);
plot(Omega,abs(ST_shift));
xlabel('\Omega (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum');
grid on;


subplot(1,2,2);
plot(Omega,angle(ST_shift));
xlabel('\Omega (Hz)');
ylabel('Phase');
title('Phase Spectrum');
grid on;
