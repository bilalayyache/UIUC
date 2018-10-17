function [W, S] = screw(w)
a = w(1);
b = w(2);
c = w(3);
W = [0, -c, b;, c, 0, -a; -b, a, 0];
end