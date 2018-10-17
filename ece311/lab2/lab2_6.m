clear all
close all
clc

x = sin(2*pi*0.01*(0:100)) + 0.05*randn(1,101);
A_x = sum(x);

h = ones(1,5);
A_h = sum(h);

y = conv(x, h);
A_y = sum(y);

diff = A_y - A_x * A_h;

figure(1);
plot(x)
hold on
plot(y)
xlabel('n')
ylabel('value of x and y')
title('part (b)')
legend('x', 'y')

L_h = length(h);
h_norm = 1 / L_h * h;
A_h_norm = sum(h_norm);

y_norm = conv(x, h_norm);
A_y_norm = sum(y_norm);
diff_norm = A_y_norm - A_x * A_h_norm;
figure(2);
plot(x)
hold on
plot(y_norm)
xlabel('n')
ylabel('value of x and y_{normalized}')
title('part (c)')
legend('x', 'y_{normalized}')