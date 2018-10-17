clear all
close all
clc

load qcoms.mat
x = qcoms;
[r, c] = size(x);
y1 = zeros(r - 51, c);
y2 = zeros(r - 51, c);
for i = 51 : r
    y1(i-50) = 1 / 51 * sum(x(i-50 : i));
end
for i = 26 : (r-25)
    y2(i-25) = 1 / 51 * sum(x(i - 25 : i + 25));
end
h = 1 / 51 * ones(51, 1);
y_conv = conv(h, x);
y_check = y_conv(51 : r);

figure(1);
plot(x)
xlabel('n')
ylabel('value')
title('value of x')
legend('x')


figure(2);
plot(x)
hold on
plot(y1)
hold on
plot(y2)
xlabel('n')
ylabel('value')
title('x, y_1, y_2')
legend('x','y_1','y_2')

y1_diff = y_check - y1;
y2_diff = y_check - y2;