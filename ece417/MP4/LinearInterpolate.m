% this function does the linear interpolation for pixel value
% for a given point (x, y) with x and y are floating point number
% we find the nearest 4 points around it and find the pixel value by
% interpolation

function [color] = LinearInterpolate(x, y, image)
[height, width] = size(image);
xl = floor(x);
yl = floor(y);
xh = xl + 1;
yh = yl + 1;
e = x - xl;
h = y - yl;

I1 = image(xl, yl);
I2 = 0;
I3 = 0;
I4 = 0;
if xl < height && yl < width
    I2 = image(xl, yh);
    I3 = image(xh, yl);
    I4 = image(xh, yh);
elseif xl == height && yl < width
    I2 = image(xl, yh);
    I3 = 0;
    I4 = 0;
elseif xl < height && yl == width
    I2 = 0;
    I3 = image(xh, yl);
    I4 = 0;
end

color = (1-e)*(1-h)*I1 + (1-e)*h*I2 + e*(1-h)*I3 + e*h*I4;

end