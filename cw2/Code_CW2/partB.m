clc
clear
close all

% read image
I = imread('fish.jpg');
I = rgb2gray(I);
[row,col] = size(I);

order = 2;
% choose a appropriate scale
scale = 20;
sigma = scale/8;
Gaussian_filtering = DtG(order, scale, sigma);
[m,n,dim]= size(Gaussian_filtering);

output = zeros(row,col);

figure,
for d=1:dim
    out(:,:,d) = conv2(im2double(I), Gaussian_filtering(:,:,d), 'same');
    out_abs = abs(out(:,:,d));
    subplot(1,dim,d),
    imshow(out_abs./max(out_abs(:)));
    % avoid pixel value less than zero
    output = output + out(:,:,d).^2;
end

output= output.^(1/2);
output = output./max(output(:));

figure, 
subplot(1,2,1), 
imshow(I), 
title('Original Image');
subplot(1,2,2),
imshow(output),
title('2nd Order Result');
