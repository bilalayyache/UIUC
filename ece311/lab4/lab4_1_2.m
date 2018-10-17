clear all
close all
clc

omega = linspace(-pi, pi, 1000);
h = zeros(1, 1000);
coeff = [1, -2, 3, -4, 0, 4, -3, 2, -1];
for i = 1 : 1000
    h(i) = sum(coeff .* exp(-j*omega(i)).^(0:8));
end

mag_h = abs(h);
pha_h = angle(h);

figure(1);
subplot(121)
plot(omega, mag_h);
title('magnitude response from DTFT')
xlabel('small omega')
ylabel('magnitude response')

subplot(122)
plot(omega, pha_h);
title('phase response from DTFT')
xlabel('small omega')
ylabel('phase response')
b = coeff;
a = zeros(1, 9);
a(1) = 1;
N = 1000;
[hh, ff] = freqz(b, a, N);

figure(2);

subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(1,2,2);
plot(ff,angle(hh));
xlabel('Little Omega');
ylabel('Phase');
title('Phase Response');
grid on;