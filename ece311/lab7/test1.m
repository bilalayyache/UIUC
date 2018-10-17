%This is a comment
clc,clear all,close all

%% Section 1
s=audioread('audioclip.wav');
left = s(:,1); % Left Channel
leftup=upsample(left,2);
l=length(leftup);
x1=fftshift(fft(leftup));
w=fftshift((0:l-1)/l*2*pi);
w(1:l/2)=w(1:l/2)-2*pi;
figure;
plot(w/pi/2*132300,mag2db(abs(x1)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (in dB)');
title('The Magnitude Response');
grid on;   %Plot the magnitude values

%The following part is constructing an LPF for the downsampling
f=[31752,33075];
a=[1,0];
rp=[0.122018454,0.003162278];
fs=132300;
[n,fo,mo,w1]=firpmord(f,a,rp,fs);
filter6=firpm(n,fo,mo,w1);  %Generate the lowpass filter
denom1=zeros(1,length(filter6)); denom1(1)=1;%Generalize the numerator and denominator coefficient sequences
left_new=filter(filter6,denom1,leftup);  %Apply the LPF


%%
l=length(left_new);
x1=fftshift(fft(left_new));
w=fftshift((0:l-1)/l*2*pi);
w(1:l/2)=w(1:l/2)-2*pi;
figure;
plot(w/pi/2*132300,mag2db(abs(x1)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (in dB)');
title('The Magnitude Response');
grid on;   %Plot the magnitude values

leftds=downsample(left_new,3); %Generate the downsampling sequence
l=length(leftds);
x1=fftshift(fft(leftds));
w=fftshift((0:l-1)/l*2*pi);
w(1:l/2)=w(1:l/2)-2*pi;
figure;
plot(w/pi/2*44100,mag2db(abs(x1)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (in dB)');
title('The Magnitude Response');
grid on;   %Plot the magnitude values
%When played at 44100Hz, the converted sound is faster
