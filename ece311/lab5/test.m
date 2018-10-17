%This is a comment
clc,clear all,close all

%% Section 7
load('song1.mat');
sound(song1,44100);  %Load and play song1
[s,w,t]=spectrogram(song1,hamming(4096),2048,4096);
imagesc(t,w,log(abs(s)));
xlabel('Block Index');
ylabel('Digital Frequencies between 0 and pi');
title('The Spectrogram for Song1');  %Plot the spectrogram for song1

load('song2.mat');
sound(song2,44100);  %Load and play song2
[s1,w1,t1]=spectrogram(song2,hamming(4096),2048,4096);
figure;
imagesc(t1,w1,log(abs(s1)));
xlabel('Block Index');
ylabel('Digital Frequencies between 0 and pi');
title('The Spectrogram for Song2');  %Plot the spectrogram for song2

load('song3.mat');
sound(song3,44100);  %Load and play song3
[s2,w2,t2]=spectrogram(song3,hamming(4096),2048,4096);
figure;
imagesc(t2,w2,log(abs(s2)));
xlabel('Block Index');
ylabel('Digital Frequencies between 0 and pi');
title('The Spectrogram for Song3');  %Plot the spectrogram for song3

