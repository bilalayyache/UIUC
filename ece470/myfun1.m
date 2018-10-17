function S = myfun1(s)
w = s(1:3);
W = screw(w);
v = s(4:6);
S = [W, v; 0 0 0 0];
end