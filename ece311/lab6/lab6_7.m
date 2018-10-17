clear all
close all
clc

load('sig1.mat');

% create s and h
N = 50;
% N = 50, 100, 500, 1000, 10000;
M = 24;
x = sig1(1:N)';
h = ones(M, 1);
h = h / M;

% zero-padding x, h to (M + N -1)
xz = zeros(M + N - 1, 1);
xz(1:N) = x;
hz = zeros(M + N - 1, 1);
hz(1:M) = h;

% first method
tic
y_1 = ifft(fft(xz) .* fft(hz));
toc

% second method
tic
C = convmtx(h, N);
y_2 = C * x;
toc

diff = y_1 - y_2;
figure();
stem(diff)
title('difference between two methods')
xlabel('n')
ylabel('difference')