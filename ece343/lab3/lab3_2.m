v = csvread('322.csv', 1, 0);
cbv = v(:,4);
cav = v(:,2);
R = cbv ./ (cav - cbv) * 10^7;
plot(R)