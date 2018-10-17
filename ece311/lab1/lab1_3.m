clear all
close all
clc

x = 0 : 0.2 : 5;
f = x .^ 2 .* exp(sqrt(x));
g = 3 * sqrt(x) + sin(8 * pi * x);

figure;
subplot(211)
plot(x,f)
xlabel('x')
ylabel('f(x)')
title('two functions plotted in the same graph')
subplot(212)
plot(x,g)
xlabel('x')
ylabel('g(x)')

figure;
subplot(211)
stem(x,f)
xlabel('x')
ylabel('f(x)')
title('two functions plotted in the same graph')
subplot(212)
stem(x,g)
xlabel('x')
ylabel('g(x)')