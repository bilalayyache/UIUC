clear all
close all
clc

image1 = imread('image1.jpg');
% lowpass filter
h = [1/8, 1/16, 1/8; 1/16, 1/4, 1/16; 1/8, 1/16, 1/8];

% apply the filter
image1_filter = conv2(double(image1), double(h));
figure()
imagesc(image1)
title('image1 before filtering')


figure()
imagesc(image1_filter)
title('image1 after filtering')
