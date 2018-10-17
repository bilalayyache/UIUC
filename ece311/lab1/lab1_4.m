clear all
close all
clc

x = linspace(-5, 5, 400);
y = linspace(-4, 4, 300);
[xx, yy] = meshgrid(x,y);
f = sinc(sqrt(xx.^2 + yy.^2));
figure
imagesc(x,y,f)
xlabel('x')
ylabel('y')
title('first function')
axis xy

f = sinc(xx).*sinc(yy);
figure
imagesc(x,y,f)
xlabel('x')
ylabel('y')
title('second function')
axis xy