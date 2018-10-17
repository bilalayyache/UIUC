clear all
close all
clc


data = csvread('lab5_1.csv', 1, 0);
cav = data(:, 2);
cbv = data(:, 4);

i = (4.8 - cbv) / 1000;
scatter(cav, i)
xlabel('V_{BE}');
ylabel('I_C');
title('I_C vs. V_{BE}')