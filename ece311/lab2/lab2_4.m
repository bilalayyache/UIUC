clear all
close all
clc

% Analytical expression of y
y = ones(99, 1);

% part (b)
h_b = ones(50, 1);
x_b = ones(50, 1);
for i = 1 : 50
    h_b(i) = 0.9^(i-1);
    x_b(i) = 0.9^(i-1);
end

for i = 1: 99
    y(i) = i * 0.9^(i-1);
end
y_b = conv(x_b,h_b);

% part (c)
h_c = ones(99, 1);
x_c = ones(99, 1);
for i = 1 : 99
    h_c(i) = 0.9^(i-1);
    x_c(i) = 0.9^(i-1);
end
y_c = conv(x_c,h_c);

% plot all graphs together
figure(1);
plot(y)
xlabel('n')
ylabel('value of y')
title('Analytical Expression')
legend('y')
figure(2);
plot(y)
hold on
plot(y_b)
hold on
plot(y_c)
xlabel('n')
ylabel('value of y')
title('Analytical Expression and Finite Length Representation of a Convolution')
legend('y', 'y_{50 samples}', 'y_{99 samples}')
