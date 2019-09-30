% read image
I = imread('cameraman.tif');

f = double(I(:,70));
% choose a number of point N
N = length(f);
% initialise N*N matrix
A = zeros(N,N);

% implement A representing Laplacian
for i = 1:N
    for j = 1:N
        if(i == j)
            % first element
            if(i == 1)
                A(i,j)   = -1;
                A(i+1,j) =  1;
            % last element
            elseif(i == N)
                A(i,j)   = -1;
                A(i-1,j) =  1;
            else
                A(i,j)   = -2;
                A(i-1,j) =  1;
                A(i+1,j) =  1;
            end
        end
    end
end

% obtain the bound of f
yceil = max(f(:));
yfloor = min(f(:));

% Initialize first step f_explicit, f_implicit and f_gaussian
f_explicit = f;
f_implicit = f;
f_gaussian = f;


deltaT = 0.5;
iteration = 10;
% standard deviation
std = sqrt(2*deltaT);
% generate a Gaussian filter
gaussian = gaussmf(-1:1:1,[std 0]);

% set the position and scale of the result figure
set (gcf,'Position',[200 200 1000 500]);
for i = 1:iteration
    % test explicit scheme
    f_explicit = explicit(f_explicit,A,deltaT);
    subplot(1,3,1);
    plot(f_explicit);
    title({['Explicit Scheme'],['Iteration:',num2str(i),' deltaT:',num2str(deltaT)]});
    set(gca, 'XLim', [0 N]);
    set(gca, 'YLim', [yfloor yceil]);
    drawnow;
    
    % test implicit scheme
    f_implicit = implicit(f_implicit,A,deltaT,N);
    subplot(1,3,2);plot(f_implicit);
    title({['Implicit Scheme'],['Iteration:',num2str(i),' deltaT:',num2str(deltaT)]});
    set(gca, 'XLim', [0 N]);
    set(gca, 'YLim', [yfloor yceil]);
    drawnow;
    
    % convolution of f0 with a Gaussian filter
    f_gaussian = conv(f_gaussian,gaussian,'same');
    subplot(1,3,3);plot(f_implicit);
    title({['Gaussian Filter'],['Iteration:',num2str(i)]});
    set(gca, 'XLim', [0 N]);
    set(gca, 'YLim', [yfloor yceil]);
    drawnow;
end

% Explicit scheme
function [fkp1] = explicit(f,A,deltaT)
    fkp1 = f + deltaT*A*f;
end

% Implicit schem
function fkp1 = implicit(f,A,deltaT,N)
    fkp1 = inv(eye(N)-deltaT*A)*f;
end