% read image
Image = imread('cameraman.tif');
Image = im2double(Image);
[row, col] = size(Image);
N = row;
deltaT = 0.1;
iteration = 100;

% reshape f into a N^2*1 vector
fkp1 = reshape(Image,N*N,1);

% construct dd metrix
dd = zeros(N*N,3);
dd(:,1) =   1;
dd(:,2) =  -2;
dd(:,3) =   1;
% use spdiags function to construct Ax and Ay
Ax = spdiags(dd,-1:1,N*N,N*N);
Ay = spdiags(dd,[-N,0,N],N*N,N*N);
I  = speye(N*N);

for i = 1:iteration
    % first step
    f_halfkp1 = (I-deltaT/2.*Ax)\((I+deltaT/2.*Ay)*fkp1);
    
    % second step, Ay is identical to Ax on the first step
    fkp1 = (I-deltaT/2.*Ay)\((I+deltaT/2.*Ax)*f_halfkp1);
    
    % output
    output = reshape(fkp1,N,N);
    imshow(output);
    title({['2D linear diffusion ','Iteration:',num2str(i),' deltaT:',num2str(deltaT)]});
    hold on;

    % find local maximum
    maximum = max(output(:));
    [x y] = find(output == maximum);
    plot(y,x,'*');
    drawnow;
end