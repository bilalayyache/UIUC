clear all
close all
clc

load clown
figure;
imagesc(X)
colormap(map)

X_17row = X(17,:);
X_49column = X(:,49);
figure
subplot(211)
plot(X_17row)
title('17th row')
subplot(212)
plot(X_49column)
title('49th column')
X_tras = X';
figure
imagesc(X_tras)
