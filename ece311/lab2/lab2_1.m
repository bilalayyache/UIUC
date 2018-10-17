clear all
close all
clc

% PART A: Load cameraman and show it on the screen
im = imread('cameraman.tif');
im_double = double(im);
subplot(221);
imshow(im)
title('cameraman')

% 1D convolution
% PART B: row convolution

h = 1/5 * ones(1,5);
output_1Drow = zeros(256,256);
for i = 1 : 256
    y = conv(im_double(i, :), h, 'same');
    output_1Drow(i,:) = y;
end
output_1Drow_uint8 = uint8(output_1Drow);
subplot(222);
imshow(output_1Drow_uint8)
title('1D row convolution cameraman')

% PART C: column covolution

output_1Dcolumn = zeros(256,256);
for i = 1 : 256
    y = conv(im_double(:, i), h, 'same');
    output_1Dcolumn(:,i) = y;
end
output_1Dcolumn_uint8 = uint8(output_1Dcolumn);
subplot(223);
imshow(output_1Dcolumn_uint8)
title('1D column convolution cameraman')

% PART D: do column convolution with the result of part b
output_1D = zeros(256,256);
for i = 1 : 256
    y = conv(output_1Drow(:, i), h, 'same');
    output_1D(:,i) = y;
end
output_1D_uint8 = uint8(output_1D);
subplot(224);
imshow(output_1D_uint8)
title('1D cameraman after row and column convulotion')

