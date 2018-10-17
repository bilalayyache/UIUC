clear all
close all
clc

[data, fs] = audioread('sound2.wav');
figure(1)
plot(abs(data))
xlabel('sampling index')
ylabel('Magnitude')
title('Magnitude of signal before filtering')

figure(2)
freqz(data, 1)
title('Magnitude and phase response')
% spectrogram setup
window = hamming(4096);
w = 4096;
noverlap = 2048;
[s1,w1,t1] = spectrogram(data,window,noverlap,w);
figure(3)
imagesc(t1, w1, log(abs(s1)))
axis('xy')
title('spectrogram for sound2 before filtering')
ylabel('digital frequency')
xlabel('sampling index')

% design a lowpass filter
f = [4581, 5292];
a = [1, 0];
delta_s = 10^(-2.5);
delta_p = ((10^0.1 - 1)/(10^0.1 + 1));
rp = [delta_p, delta_s];

[n, fo, mo, w] = firpmord(f, a, rp, fs);
b = firpm(n, fo, mo, w);
aa = zeros(1, length(b));
aa(1) = 1;
data_filter = filter(b, aa, data);

figure(4)
plot(abs(data_filter))
xlabel('sampling index')
ylabel('Magnitude')
title('Magnitude of signal after filtering')
% magnitude and phase response of filtered data
figure(5)
freqz(data_filter, 1)
title('Magnitude and phase response after filtering')

w = 4096;
[s2,w2,t2] = spectrogram(data_filter,window,noverlap,w);
figure()
imagesc(t2, w2, log(abs(s2)))
axis('xy')
title('spectrogram for sound2 after filtering')
ylabel('digital frequency')
xlabel('sampling index')