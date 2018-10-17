clear all
close all
clc

N = 1000;
b = [0.2, 0];
a = [1, -0.8];

[hh, ff] = freqz(b, a, N);

figure(1);

subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
ylabel('Magnitude');
title('Magnitude Response');
grid on;


subplot(1,2,2);
plot(ff,phase(hh));
xlabel('Little Omega');
ylabel('Phase');
title('Phase Response');
grid on;subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
ylabel('Magnitude');
title('Magnitude Response');
grid on;


subplot(1,2,2);
plot(ff,phase(hh));
xlabel('Little Omega');
ylabel('Phase');
title('Phase Response');
grid on;

omega = linspace(0, pi/5, 1000);
hh_1000 = 0.2 ./ (1 - 0.8*exp(-j*omega));

figure(2)

subplot(1,2,1);
plot(omega,abs(hh_1000));
xlabel('Little Omega');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(1,2,2);
plot(omega,phase(hh_1000));
xlabel('Little Omega');
ylabel('Phase');
title('Phase Response');
grid on;