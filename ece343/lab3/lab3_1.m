
v0 = csvread('0.csv');
v25 = csvread('0_25.csv',1,0);
v5 = csvread('0_5.csv',1,0);
v25vsb = csvread('v25_vsb.csv',1,0);
v5vsb = csvread('v5_vsb.csv',1,0);

cav0 = v0(1:1000,2);
cbv0 = v0(1:1000,4);
R_D = 1000;
id0 = (5 - cbv0)/R_D;

cav25 = v25(:,2);
cbv25 = v25(:,4);
id25 = (5 - cbv25)/R_D;

cav5 = v5(:,2);
cbv5 = v5(:,4);
id5 = (5 - cbv5)/R_D;

vsb25 = v25vsb(:,4);
vsb5 = v5vsb(:,4);

figure(1)
scatter(cav0, id0*1000)
hold on
scatter(cav25 - vsb25, id25*1000)
hold on
scatter(cav5 - vsb5, id5*1000)
% set(gca, 'YScale', 'log')


