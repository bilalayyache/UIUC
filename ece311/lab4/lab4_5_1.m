clear all
close all
clc

t_init = 0; % start time in seconds
% t_end = 1;%end time in seconds
t_end = 10;%end time in seconds
t_samp = 1/8192; %sampling period

t_vect = t_init:t_samp:t_end; %obtain the time vector

Omega_0 = 2*pi*3000;
beta = 2000;
% Let's sample at 8192 Hz!

x_a = sin(Omega_0.*t_vect + 0.5*beta.*t_vect.*t_vect);
figure(1);
plot(t_vect,x_a);
title('Sampling at 8192 Hz');
xlabel('Time in s');
ylabel('Amplitude')
sound(x_a)