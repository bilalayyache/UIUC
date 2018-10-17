%% Sampling

% Harry Nyquist said to sample greater than 2 times your highest frequency
% suppose we have a continuous time signal x(t) = cos(2pi*ft)
% And we want to sample x(t), how would I do this?


% Well lets start here:

% t = nT, n is an integer index, T is the sampling rate 
% 1/T is the sampling frequency


%Suppose we have x(t) = cos(2*pi*20*t);
% This is a 20 Hz tone
% Let's sample this function at 100 Hz, and sample from 0 to 5 seconds


t_init = 0; % start time in seconds
t_end = 1;%end time in seconds
t_samp = 1/100; %sampling period

t_vect = t_init:t_samp:t_end; %obtain the time vector

% Let's sample!


xt = cos(2*pi*20*t_vect);
figure(3);
plot(t_vect,xt);
title('Sampling at 100 Hz');
xlabel('Time in s');
ylabel('Amplitude')

% We see the sampled cosine

%% Sampling at 30 Hz


figure(4);

t_init = 0; % start time in seconds
t_end = 1;%end time in seconds
t_samp = 1/30; %sampling period

t_vect = t_init:t_samp:t_end; %obtain the time vector

% Let's sample at 30 Hz!


xt = cos(2*pi*20*t_vect);
figure(4);
plot(t_vect,xt);
title('Sampling at 30 Hz');
xlabel('Time in s');
ylabel('Amplitude')


