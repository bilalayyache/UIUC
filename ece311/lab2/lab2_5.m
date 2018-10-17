clear all
close all
clc

L = 1001;
x = ones(L, 1);
y_1 = 0;
y = zeros(L, 1);
y(1) = 5 * y_1 + x(1);
for i = 2 : L
    y(i) = 5 * y(i-1) + x(i);
end

figure(1);
plot(y)
xlabel('n')
ylabel('value of y')
title('output of the system')
