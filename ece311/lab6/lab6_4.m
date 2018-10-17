clear all
close all
clc

% parameters
f = [225, 270];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];
fs = 1500;

[n, fo, mo, w] = firpmord(f, a, rp, fs);
b = firpm(n, fo, mo, w);

figure(1)
freqz(b, 1)
title('Magnitude and phase response')

figure(2)
impz(b);
