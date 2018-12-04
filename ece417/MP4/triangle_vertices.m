% this function finds all vertices coordinates
% input: all vertices coordinates 33 x 2
%        triangle vertices index  42 x 3
% output: triangle vertices coordinates 42 x 3 x 3
% if three vertices of a triangle is (a1, b1), (a2, b2), (a3, b3)
% then the output matrix for this triangle should be:
% a1   a2   a3
% b1   b2   b3
%  1    1    1

function [ver_coordinates] = triangle_vertices(coordinates, triangle, num_triangle)
ver_coordinates = zeros(num_triangle, 3, 3);
for i = 1:num_triangle
    for j = 1:3
        ver_coordinates(i, :, j) = [coordinates(triangle(i, j), 1); coordinates(triangle(i, j), 2); 1];
    end
end
end