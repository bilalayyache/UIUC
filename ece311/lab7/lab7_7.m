clear all
close all
clc

n = 100;
DFT_matrix = DFTMatrix(n);
real_DFT = real(DFT_matrix);
im_DFT = imag(DFT_matrix);

filter = [1, 2, 3, 4, 5, 6];
L = 50;
theta = 30;
con_matrix = convmtx(filter, L);

motion_filter = fspecial('motion',L, theta);

figure()
subplot(221)
imagesc(real_DFT);
title('real part of DFT matrix')
colorbar();

subplot(222)
imagesc(im_DFT)
title('imaginary part of DFT matrix')
colorbar();

subplot(223)
imagesc(con_matrix)
title('convolution matrix')
colorbar();

subplot(224)
imagesc(motion_filter)
title('motion filter matrix')
colorbar();

vector1 = real_DFT(:);
vector2 = im_DFT(:);
vector3 = con_matrix(:);
vector4 = motion_filter(:);
fs = 44100;