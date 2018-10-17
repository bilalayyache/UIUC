clear all
close all
clc

x = [1; 2; 3; 4; 5];
X_DFT = myMatrixDFT(x);
X_FFT = fft(x);
diff = X_DFT - X_FFT;
figure(1);
stem(real(diff));
hold on
stem(imag(diff));
xlabel('n');
ylabel('difference');
title('difference between two method');
legend('real part', 'imaginary part');