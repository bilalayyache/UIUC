clear all
close all
clc

data1 = csvread('curve1.csv', 1, 0);
data2 = csvread('curve2.csv', 1, 0);
data3 = csvread('curve3.csv', 1, 0);

cav1 = data1(:, 2);
cbv1 = data1(:, 4);
cav2 = data2(:, 2);
cbv2 = data2(:, 4);
cav3 = data3(:, 2);
cbv3 = data3(:, 4);

i1 = (cav1 - cbv1) / 1000;
i2 = (cav2 - cbv2) / 1000;
i3 = (cav3 - cbv3) / 1000;

figure;
scatter(cbv1, i1)
hold on
scatter(cbv2, i2);
hold on
scatter(cbv3, i3);
title('I_C vs V_{CE}');
xlabel('V_{CE}')
ylabel('I_C')
legend('V_{BE}=0.65 V', 'V_{BE}=0.645 V', 'V_{BE}=0.64 V')