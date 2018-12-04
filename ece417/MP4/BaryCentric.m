% Function: Barycentric(out_coord, inp_triangs, out_triangs)
% Description: find the input coordinate of the pixel in input triangles.
% Input: out_coord: the output coordinates of the pixel in output traingle.
%        inp_triangs: an array of triangles in input image.
%(array with size 42x3x3)
%        out_triangs: an array of triangles in output image.
%(array with size 42x3x3)
% Return: inp_coord: the corresponding input coordinate of the given output coordinate

function [x, y] = BaryCentric (out_coord, in_triangs, out_triangs)
if isequal(in_triangs, out_triangs)
    x = out_coord(1);
    y = out_coord(2);
    return
end
%travel the output triangles and find which triangle will not generate
%the negative lambda.
index = 0;
[len,~,~] = size(out_triangs);
lambda = zeros(3,1);
for i = 1 : len
    X = reshape(out_triangs(i,:,:), [3, 3]);
    lambda = inv(X) * out_coord;
     if (lambda(1,1) >= 0) && (lambda(2,1) >= 0) && (lambda(3,1) >= 0)
         index = i;
         break
    end 
end
if(index > 0)
    U = reshape(in_triangs(index,:,:),[3,3]);
    in_coord = U*lambda;
    x = in_coord(1);
    y = in_coord(2);
else
    x = -1;
    y = -1;
end
end