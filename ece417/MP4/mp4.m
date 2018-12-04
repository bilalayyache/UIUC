%% This is the file where the main process for mp4 lies in
clear all
close all
clc

%% First, we need to read the data into the workspace
data = load('ECE417_MP4_AV_Data.mat');
% av_* is a struct that contains two variables
% av_*.audio is an array of size 60 x frame_number
% av_*.visual is an array of size 3 x frame_fumber
av_train = data.av_train;
av_validate = data.av_validate;
testAudio = data.testAudio;
silenceModel = data.silenceModel;
input_image = imread('mouth.jpg');
% read vertices coordinates from file mesh.txt
vertices = dlmread('mesh.txt');
num_ver = vertices(1, 1);
coordinates = vertices(2:num_ver+1, 1:2);
num_triangle = vertices(num_ver+2, 1);
triangle = vertices(num_ver+3:end, :);
% this function gets the coordinates of vertices of all triangles
% ver_coordinates has size 42 x 3 x 3
[ver_coordinates] = triangle_vertices(coordinates, triangle, num_triangle);

%% Training Part
numN = 100;
filename = 'mapping.mat';
mapping = ECE417_MP4_train(av_train, av_validate, silenceModel, numN, filename);


%% Run the Model
result = ECE417_MP4_test(testAudio, silenceModel, mapping);
%% Generate All Images On Testing Audio File
output_images = image_warp(result, coordinates, ver_coordinates, triangle, num_triangle, input_image);

%% Save image to file
v = VideoWriter('test.avi');
open(v)
writeVideo(v,output_images)
close(v)
