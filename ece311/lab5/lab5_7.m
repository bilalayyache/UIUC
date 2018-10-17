clear all
close all
clc

window = hamming(4096);
w = 4096;
noverlap = 2048;

load('song1.mat');
load('song2.mat')
load('song3.mat')
[s1,w1,t1] = spectrogram(song1,window,noverlap,w);
[s2,w2,t2] = spectrogram(song2,window,noverlap,w);
[s3,w3,t3] = spectrogram(song3,window,noverlap,w);
figure(1)
imagesc(t1, w1, log(abs(s1)))
xlabel('time')
ylabel('frequency')
title('spectrogram of song 1')

figure(2)
imagesc(t2, w2, log(abs(s2)))
xlabel('time')
ylabel('frequency')
title('spectrogram of song 2')

figure(3)
imagesc(t3, w3, log(abs(s3)))
xlabel('time')
ylabel('frequency')
title('spectrogram of song 3')
