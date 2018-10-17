clear all
close all
clc

b1 = [2 0 5 4 0 0 -3];
a1 = [1 0 0 0 0 0 0];
S1 = tf(b1, a1);

b2 = [3 2 0 -2];
a2 = [1 0 0 0];
S2 = tf(b2, a2);

b3 = [0 0 0 1 0 0 1 -2];
a3 = [12 1 0 4 0 0 0 0];
S3 = tf(b3, a3);

% draw a unit circle
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);

N = 20;
figure(1);
subplot(121);
pzplot(S1,'b');
hold on
plot(x, y, ':b')
hold on
axis([-2 2 -2 2])
subplot(122);
impz(b1, a1, N);

figure(2);
subplot(121);
pzplot(S2,'b');
hold on
plot(x, y, ':b')
axis([-2 2 -2 2])
subplot(122);
impz(b2, a2, N);

figure(3);
subplot(121);
pzplot(S3,'b');
hold on
plot(x, y, ':b')
axis([-2 2 -2 2])
subplot(122);
impz(b3, a3, N);
