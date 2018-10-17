clear all
close all
clc

% use loop to calculate y
n = 0 : 49;
x = (0.7).^n .* n;
y = zeros(1, 50);
y(1) = x(1);
y(2) = x(2) - x(1);
for i = 3 : 50
    y(i) = x(i) - x(i - 1) + 0.81 * y(i - 2);
end

% use filter to calculate y

a = [1 0 -.81];
b = [1 -1 0];
y_filter = filter(b, a, x);

diff = y - y_filter;
figure(1);
subplot(311)
stem(n, y)

hold on
stem(n, y_filter)
xlabel('n')
ylabel('y')
title('y calculated by two methods')
legend('y by loop', 'y by filter funvtion')

subplot(212)
stem(n, diff)
xlabel('n')
ylabel('difference')
title('difference between two methods')
