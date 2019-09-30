function Gaussian_filtering = DtG(order, scale, sigma)
    % 0th order
    X = [1:scale]-scale/2;
    gauss_x = 1/(sqrt(2*pi)*sigma)*exp(-0.5*X.^2/(sigma^2));
    gauss_y = gauss_x';
    
    F0 = gauss_y * gauss_x;
    F0 = F0./(max(F0(:)));
    
    if order==0
        Gaussian_filtering = F0;
    end
    
    % 1st order
    grad_x = [1,-1];
    F1_x = conv2(F0, grad_x, 'same');
    
    grad_y = [-1,1]';
    F1_y = conv2(F0, grad_y, 'same');
    
    if order==1
        Gaussian_filtering(:,:,1) = F1_x;
        Gaussian_filtering(:,:,2) = F1_y;
    end
    
    % 2nd order
    G2_xx = conv2(F1_x,grad_x,'same');
    G2_xy = conv2(F1_x,grad_y,'same');
    G2_yy = conv2(F1_y,grad_y,'same');
    
    if order==2
        Gaussian_filtering(:,:,1) = G2_xx;
        Gaussian_filtering(:,:,2) = G2_xy;
        Gaussian_filtering(:,:,3) = G2_yy;
    end
end