
cav = data(2000:4001, 2);
cbv = data(2000:4001, 4);
vdd = 4.8;
i = (vdd - cbv) / 1000;
t = data(2000:4001, 1) / 100;

plot(t, i);
xlabel('time (ms)')
ylabel('current (A)')