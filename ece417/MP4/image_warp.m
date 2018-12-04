% This function takes a 3 x frame_number input array and return
% frame_number images
% input: feature 3 x frame_number
%        coordinates: original coordinates for all vertices
%        delta: delta change produced by ANN
function [image] = image_warp(feature, coordinates, ver_coordinates, triangle, num_triangle, input_image)
[~, frame_number] = size(feature);
[height, width] = size(input_image);
% we need to generate frame_number images based on input features
image = zeros(height, width, 1, frame_number, 'uint8');
for i = 1:frame_number
    cur_feature = feature(:, i);
    cur_image = single_image_warp(cur_feature, coordinates, ver_coordinates, triangle, num_triangle, input_image);
    image(:, :, 1, i) = cur_image;
    filename = strcat('./test_images/test_0', findstring(i-1), '.jpg');
    imwrite(cur_image, filename);
    fprintf('this is the %dth image\n', i) 
end
end

function [str] = findstring(x)
o = rem(x, 10);
t = rem((x-o)/10, 10);
h = (x - rem(x, 100))/100;
str = strcat(mat2str(h), mat2str(t), mat2str(o));
end
% % single image generate from one frame of feature
% % feature is a 3 x 1 array
% function [image] = single_image_warp(feature, coordinates, ver_coordinates, triangle, num_triangle, input_image)
% [height, width] = size(input_image);
% % find argument for function interpVert
% X = coordinates(:, 1);
% Y = coordinates(:, 2);
% fScale = 1.5;
% 
% [new_X, new_Y] = interpVert(X, Y, feature, fScale);
% % num_ver = length(new_X);
% [new_ver_coordinates] = triangle_vertices([new_X, new_Y], triangle, num_triangle);
% % Now we need to use the new_X and new_Y to generate the new image
% image = zeros(height, width, 'uint8');
% 
% % we need to figure out all other pixels value
% for i = 1:width
%     for j = 1:height
%         [x, y] = BaryCentric([i;j;1], ver_coordinates, new_ver_coordinates);
%         % check whether the pixel needs to be colored
%         if x > 0 && y > 0
%             image(j, i) = LinearInterpolate(y, x, input_image);
%         end
%     end
% end
% 
% end