clear all
close all
clc

N = 35;
b_H = [0, 1, 0];
a_H = [1, 2*cos(0.8*pi), 1];
S_H = tf(b_H, a_H);

% draw a unit circle
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);


figure(1);
subplot(121);
pzplot(S_H,'b');
hold on
plot(x, y, ':b');
axis([-2 2 -2 2])
subplot(122);
impz(b_H, a_H, N);

% Create an X such than the output Y is unbounded
b_X = [1, -cos(0.2*pi)];
a_X = [1, -2*cos(0.2*pi), 1];
S_X = tf(b_X, a_X);
n = 0 : 100;
x = cos(pi*n/5).*n;

y = filter(b_H, a_H, x);
figure(2);
stem(n, y);
title('input x[n] that generates an unbounded output')
xlabel('n')
ylabel('output y[n]')

% Create an X such than the output Y is bounded
x_bounded = (1/2).^n .* n;
y_bounded = filter(b_H, a_H, x_bounded);
figure(3);
stem(n, y_bounded);
title('input x[n] that generates a bounded output')
xlabel('n')
ylabel('output y[n]')
