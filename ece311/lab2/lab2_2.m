clear all
close all
clc

% initialize x1 and x2
x1 = zeros(1,21);
x2 = zeros(1,21);
x1(1) = 1;
x2(6) = 1;

% x[n] = delta[n]
y_1 = 1;
y1_x1 = zeros(1,21);
y2_x1 = zeros(1,21);
y1_x1(1) = x1(1);
y2_x1(1) = 0.9 * y_1 + x1(1);
for i = 2 : 21
    y1_x1(i) = (i-1)/i * y1_x1(i-1) + x1(i);
    y2_x1(i) = 0.9 * y2_x1(i-1) + x1(i);
end
figure(1);
stem(y1_x1)
hold on
stem(y2_x1)
legend('y_1', 'y_2')
xlabel('n')
ylabel('value of y')
title('when x[n] = delta[n]')

% x[n] = delta[n-5]
y_1 = 1;
y1_x2 = zeros(1,21);
y2_x2 = zeros(1,21);
y1_x2(1) = x2(1);
y2_x2(1) = 0.9 * y_1 + x2(1);
for i = 2 : 21
    y1_x2(i) = (i-1)/i * y1_x2(i-1) + x2(i);
    y2_x2(i) = 0.9 * y2_x2(i-1) + x2(i);
end
figure(2);
stem(y1_x2)
hold on
stem(y2_x2)
legend('y_1', 'y_2')
xlabel('n')
ylabel('value of y')
title('when x[n] = delta[n-5]')
