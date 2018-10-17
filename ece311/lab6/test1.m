clear all

y=audioread('sound1.wav');
figure;
plot(abs(y));
xlabel('Index');
ylabel('Magniutde');
title('The Signal Magnitude');  %Plot the magnitude of signal
figure;
freqz(y,1);
title('The Magnitude and Phase Response');  %Plot the frequency response of the signal

% The window function is hamming with length 4096. noverlap is 2048. w is
% 4096
[sa,wa,ta]=spectrogram(y,hamming(4096),2048,4096);
figure;
imagesc(ta,wa,log(abs(sa)));
xlabel('Block Index');
ylabel('Digital Frequencies between 0 and pi');
title('The Spectrogram for Unfiltered Signal');  %Plot the spectrogram for the unfiltered signal

fx=[12127.5,12789];
ax=[1,0];
rpx=[0.122018454,0.003162278];
fsx=44100;
[nx,fox,mox,w1x]=firpmord(fx,ax,rpx,fsx);  
bx=firpm(nx,fox,mox,w1x);  %Generate the lowpass filter
a2=zeros(1,length(bx));
a2(1)=1;  %Generate the denominator coefficient sequence for the filter
ynew=filter(bx,a2,y);  %Get the filtered sequence
% soundsc(ynew,44100);  %Play the filtered signal. This is no hiss now.

figure;
freqz(ynew,1);
title('The Magnitude and Phase Response');  %Plot the frequency response of the signal

% The window function is hamming with length 4096. noverlap is 2048. w is
% 4096
[sa,wa,ta]=spectrogram(ynew,hamming(4096),2048,4096);
figure;
imagesc(ta,wa,log(abs(sa)));
xlabel('Block Index');
ylabel('Digital Frequencies between 0 and pi');
title('The Spectrogram for Filtered Signal');  %Plot the spectrogram for the filtered signal
