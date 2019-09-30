clc
clear
close all
I = imread('house.jpg');
I = rgb2gray(I);
I = im2double(I);

scale = 40;
sigma = 6;
DtG_0 = DtG(0,scale,sigma);
DtG_1 = DtG(1,scale,sigma);
DtG_2 = DtG(2,scale,sigma);

% initial sysmmetry types
r00 = DtG_0;

r10 = DtG_1(:,:,1);
r01 = DtG_1(:,:,2);

r20 = DtG_2(:,:,1);
r02 = DtG_2(:,:,3);

r11 = DtG_2(:,:,2);

% convolve to image
r00 = conv2(I,r00,'same');
r10 = conv2(I,r10,'same');
r01 = conv2(I,r01,'same');
r11 = conv2(I,r11,'same');
r20 = conv2(I,r20,'same');
r02 = conv2(I,r02,'same');

s00 = sigma^0*r00;
s10 = sigma^1*r10;
s01 = sigma^1*r01;
s20 = sigma^2*r20;
s02 = sigma^2*r02;
s11 = sigma^2*r11;

lambda = s20+s02;
gamma = sqrt((s20-s02).^2+4*s11.^2);
e = 0.1;

% seven types of local symmetry
S = zeros(size(r00,1),size(r00,2),7);
S(:,:,1) = e*s00;
S(:,:,2) = 2*sqrt(s10.^2 + s01.^2);
S(:,:,3) = lambda;
S(:,:,4) = -lambda;
S(:,:,5) = 2^(-1/2).*(gamma + lambda);
S(:,:,6) = 2^(-1/2).*(gamma - lambda);
S(:,:,7) = gamma;

output = zeros(size(S,1),size(S,2),3);
hist = zeros(1,7);
for i = 1:size(S,1)
    for j = 1:size(S,2)
        colour = find(S(i,j,:) == max(S(i,j,:)));
        switch colour
            case 1
            % pink
            output(i,j,1) = 255;
            output(i,j,2) = 182;
            output(i,j,3) = 193;
            hist(1,1) = hist(1,1)+1;
            case 2
            % gray
            output(i,j,1) = 150;
            output(i,j,2) = 150;
            output(i,j,3) = 150;
            hist(1,2) = hist(1,2)+1;
            case 3
            % black
            output(i,j,1) = 0;
            output(i,j,2) = 0;
            output(i,j,3) = 0;
            hist(1,3) = hist(1,3)+1;
            case 4
            % white
            output(i,j,1) = 255;
            output(i,j,2) = 255;
            output(i,j,3) = 255;
            hist(1,4) = hist(1,4)+1;
            case 5
            % blue
            output(i,j,1) = 0;
            output(i,j,2) = 0;
            output(i,j,3) = 255;
            hist(1,5) = hist(1,5)+1;
            case 6
            % yellow 
            output(i,j,1) = 255;
            output(i,j,2) = 255;
            output(i,j,3) = 0;
            hist(1,6) = hist(1,6)+1;
            case 7
            % green
            output(i,j,1) = 0;
            output(i,j,2) = 255;
            output(i,j,3) = 0;
            hist(1,7) = hist(1,7)+1;
        end
    end
end

figure,
subplot(1,2,1),
imshow(I),
title('Natural Image');
subplot(1,2,2),
imshow(uint8(output)),
title({['Basic Image Features'];['sigma=',num2str(sigma),' e=',num2str(e)]});

figure,
bar(hist);
set(gca,'XTickLabel',{'pink','gray','black','white','blue','yellow','green'})
xlabel('colour')
ylabel('the number of pixels')
title({['The histogram of BIFs for natural image'];['sigma=',num2str(sigma),' e=',num2str(e)]})