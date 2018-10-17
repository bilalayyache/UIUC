clear all
close all
clc

image2 = imread('image2.jpg');
% lowpass filter
h = [-1, -1, -1; -1, 8, -1; -1, -1, -1];

% apply the filter
image2_filter = conv2(double(image2), double(h));

figure()
imagesc(image2)
colormap('gray')
title('image2 before filtering')

figure()
imagesc(image2_filter)
colormap('gray')
title('image2 after filtering')