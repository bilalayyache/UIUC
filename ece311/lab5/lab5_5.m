clear all
close all
clc

N = 20;
%N = 40;
L = 1000;
omega = linspace(-pi, pi, L);
coeff = exp(-j * omega * (N - 1)/2);
W_DTFT = N * coeff .* diric(omega, N);

mag_W = abs(W_DTFT);
pha_W = angle(W_DTFT);

figure(1);

subplot(1,2,1);
plot(omega, mag_W);
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;


subplot(1,2,2);
plot(omega, pha_W);
xlabel('\omega (radians)');
ylabel('Phase');
title('Phase Response');
grid on;
