% read image
Image = imread('cameraman.tif');
Image = im2double(Image);
[row, col] = size(Image);
N = row;
deltaT = 0.1;
iteration = 100;

% obtain the gradient of image
[gx, gy] = gradient(Image);
deltaf = sqrt(gx.^2+gy.^2);

% compute threshold
T = max(deltaf(:))/2;

% compute gamma
gamma = 1./(1+(deltaf./T).^2);
% compute gam
gam = spdiags(reshape(gamma,[],1),0:0,N*N,N*N);
% construct Dx
dx = zeros(N*N,3);
dx(:,1) =  1;
dx(:,2) = -1;
Dx = spdiags(dx,0:1,N*N,N*N);
% construct Dy
dy = zeros(N*N,3);
dy(:,1) =  1;
dy(:,2) = -1;
Dy = spdiags(dy,[0,N],N*N,N*N);

% compute PM
PM = -(Dx'*gam*Dx + Dy'*gam*Dy);

for i = 1:iteration   
   Image = reshape(Image,[],1);
   % Explicit scheme
   Image = Image + deltaT*PM*Image;
   Image = reshape(Image,N,N);
   imshow(Image); 
   title({['2D Anisotropic diffusion'],['Iteration:',num2str(i),' deltaT:',num2str(deltaT),' threshold:',num2str(T)]});
   hold on;
   
   maximum = max(Image(:));
   [x y] = find(Image == maximum);
   plot(y,x,'*');
   drawnow;
end