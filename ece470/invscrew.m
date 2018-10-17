function w = invscrew(W)
w = zeros(3, 1);
w(1) = W(3, 2);
w(2) = W(1, 3);
w(3) = W(2, 1);
end