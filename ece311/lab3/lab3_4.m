clear all
close all
clc

b_H = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/1024];
a_H = [1, -1/2, 0, 0, 0, 0, 0, 0, 0, 0, 0];
S_H = tf(b_H, a_H);
N = 30;

% draw a unit circle
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);

figure(1);
pzplot(S_H,'b');
hold on
plot(x, y, ':b');
axis equal
axis([-2 2 -2 2]);

figure(2);
impz(b_H, a_H, N);