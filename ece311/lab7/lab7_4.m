clear all
close all
clc

% construct f(m,n)
x = 0:100;
y = 0:100;
[m, n] = meshgrid(x, y);
kx = pi/4;
ky = -pi/4;

f = cos(ky*m + kx*n);
figure()
imagesc(f)
title('image of f for (k_x, k_y) = (\pi/4, -\pi/4)')
xlabel('x index')
ylabel('y index')

F = fftshift(myDFT2(f));
figure()
imagesc(abs(F))
title('image of 2-D DFT of f for (k_x, k_y) = (\pi/4, -\pi/4)')
xlabel('x index')
ylabel('y index')
