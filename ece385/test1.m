clear all
close all
clc

tic
data = imread('FinalGameBackground.png');
dlmwrite('FinalGameBackground.txt',data,'delimiter','');
toc

