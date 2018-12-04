% single image generate from one frame of feature
% feature is a 3 x 1 array
function [image] = single_image_warp(feature, coordinates, ver_coordinates, triangle, num_triangle, input_image)
[height, width] = size(input_image);
% find argument for function interpVert
X = coordinates(:, 1);
Y = coordinates(:, 2);
fScale = 1.5;

[new_X, new_Y] = interpVert(X, Y, feature, fScale);
% num_ver = length(new_X);
[new_ver_coordinates] = triangle_vertices([new_X, new_Y], triangle, num_triangle);
% Now we need to use the new_X and new_Y to generate the new image
image = zeros(height, width, 'uint8');
% we need to figure out all other pixels value
for i = 1:width
    for j = 1:height
        [x, y] = BaryCentric([i;j;1], ver_coordinates, new_ver_coordinates);
        % check whether the pixel needs to be colored
        if x > 0 && y > 0
            image(j, i) = LinearInterpolate(y, x, input_image);
        elseif j <= 10 || j >= height-5 || i <= 18 || i >= width-15
            image(j, i) = input_image(j, i); 
        end
        
    end
end

end