clear all
close all
clc

% y[n] = a*y[n-1] + b*x[n-1]
% H(z) = b * z^(-1) / (1 - a * z^(-1))
b = 0.2;
% b = 0.2;
a = 0.8;
% a = 0.8;
N = 8;

bb = [0, b];
aa = [1, -a];
[hh, ff] = freqz(bb, aa, N);


figure(1);

subplot(1,2,1);
plot(ff,abs(hh));
xlabel('Little Omega');
axis([0, pi, 0, 1.5]);
ylabel('Magnitude');
title('Magnitude Response');
grid on;


subplot(1,2,2);
plot(ff,phase(hh));
xlabel('Little Omega');
axis([0, pi, -4, 1]);
ylabel('Phase');
title('Phase Response');
grid on;

n = 0 : 20;
omega1 = pi / 2;
omega2 = pi / 4;
x1 = 3 * cos(pi*n/2);
x2 = 3 * sin(pi*n/4);
H1 = (b * exp(-j * omega1)) / (1 - a * exp(-j * omega1));
H2 = (b * exp(-j * omega2)) / (1 - a * exp(-j * omega2));
y1 = abs(H1) * 3 * cos(pi*n/2 + phase(H1));
y2 = abs(H2) * 3 * sin(pi*n/4 + phase(H2));

figure(2);
subplot(121)
stem(n, y1);
title('value of y_1');
xlabel('n');
ylabel('value of y_1');

subplot(122)
stem(n, y2);
title('value of y_2');
xlabel('n');
ylabel('value of y_2');

y1_filter = filter(bb, aa, x1);
y2_filter = filter(bb, aa, x2);

figure(3);
subplot(121)
stem(n, y1_filter);
title('value of y_1 calculated by filter function');
xlabel('n');
ylabel('value of y_1');

subplot(122)
stem(n, y2_filter);
title('value of y_2 calculated by filter function');
xlabel('n');
ylabel('value of y_2');


