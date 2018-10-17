clear all
close all
clc

h = [1 -2 1];

im = imread('cameraman.tif');
im_double = double(im);

output_r = zeros(256,256);
for i = 1 : 256
    y = conv(im_double(i, :), h, 'same');
    output_r(i,:) = y;
end
output_r_uint8 = uint8(output_r);
figure(1);
imshow(output_r_uint8)
title('row-by-row convolution')

output_c = zeros(256,256);
for i = 1 : 256
    y = conv(im_double(:, i), h, 'same');
    output_c(:, i) = y;
end
output_c_uint8 = uint8(output_c);
figure(2);
imshow(output_c_uint8)
title('column-by-column convolution')
