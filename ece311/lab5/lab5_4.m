clear all
close all
clc

N  = 20;
M = 512;

%% rectangular window
w = ones(1, N);
n = 0 : N - 1;

figure(1)
stem(n, w);
xlabel('n');
ylabel('rectangular window');
title('rectangular window function')

W = fft(w, M);
W_shift = fftshift(W);
omega = fftshift((0 : M - 1) / M * 2 * pi);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;

figure(2);
subplot(121)
plot(omega, abs(W_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122)
plot(omega, mag2db(abs(W_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response in dB');
grid on;

%% triangular window

w = triang(N);

figure(3)
stem(n, w);
xlabel('n');
ylabel('triangular window');
title('triangular window function')

W = fft(w, M);
W_shift = fftshift(W);
omega = fftshift((0 : M - 1) / M * 2 * pi);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;

figure(4);
subplot(121)
plot(omega, abs(W_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122)
plot(omega, mag2db(abs(W_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response in dB');
grid on;


%% hamming window

w = hamming(N);

figure(5)
stem(n, w);
xlabel('n');
ylabel('hamming window');
title('hamming window function')

W = fft(w, M);
W_shift = fftshift(W);
omega = fftshift((0 : M - 1) / M * 2 * pi);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;

figure(6);
subplot(121)
plot(omega, abs(W_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122)
plot(omega, mag2db(abs(W_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response in dB');
grid on;

%% hanning window

w = hanning(N);

figure(7)
stem(n, w);
xlabel('n');
ylabel('hanning window');
title('hanning window function')

W = fft(w, M);
W_shift = fftshift(W);
omega = fftshift((0 : M - 1) / M * 2 * pi);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;

figure(8);
subplot(121)
plot(omega, abs(W_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122)
plot(omega, mag2db(abs(W_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response in dB');
grid on;

%% Kaiser window

beta = 0.1;
w = kaiser(N, beta);

figure(9)
stem(n, w);
xlabel('n');
ylabel('Kaiser window');
title('Kaiser window function')

W = fft(w, M);
W_shift = fftshift(W);
omega = fftshift((0 : M - 1) / M * 2 * pi);
omega(1 : M/2) = omega(1 : M/2) - 2 * pi;

figure(10);
subplot(121)
plot(omega, abs(W_shift));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response');
grid on;

subplot(122)
plot(omega, mag2db(abs(W_shift)));
xlabel('\omega (radians)');
ylabel('Magnitude');
title('Magnitude Response in dB');
grid on;


