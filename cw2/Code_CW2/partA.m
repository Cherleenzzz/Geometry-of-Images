clc
clear 
close all

% read image
I = imread('dogs.jpg');
I = rgb2gray(I);
[row, col] = size(I);

%% computer phase and power spectrum for natural image
% fast Fourier transform
FFT = fft2(double(I));
power_natural = abs(fftshift(FFT));
phase = angle(fftshift(FFT));

subplot(3,3,1),
imshow(I),
title('Natural Image');
subplot(3,3,2),
imshow(log(power_natural+1),[]),
title('Natural Power Spectrum');
subplot(3,3,3),
imshow(phase, []),
title('Natural Phase Spectrum');

%% produce phase-randomized versions
for m = 1:row
    for n = 1:col
        length = abs(FFT(m,n));
        angle_random = rand(1)*2*pi;
        x = length*cos(angle_random);
        y = length*sin(angle_random);
        FFT(m,n) = x+1i*y;
    end
end

% inverse fast Fourier transform
IFFT = ifft2(FFT);
IFFT = abs(IFFT);

power = abs(fftshift(FFT));
phase_random = angle(fftshift(FFT));

% plot phase-randomized versions
subplot(3,3,4),
imshow(uint8(IFFT)),
title('Phase-randomized Image');
subplot(3,3,5),
imshow(log(power+1),[]),
title('Phase-randomized Power Spectrum');
subplot(3,3,6),
imshow(phase_random,[]),
title('Phase-randomized Phase Spectrum');

%% produce whitened versions
FFT = fft2(double(I));
power_natural = abs(fftshift(FFT));
phase = angle(fftshift(FFT));

for m = 1:row
    for n = 1:col
        length = abs(FFT(m,n));
        FFT(m,n) = FFT(m,n)./length;
    end
end

IFFT = ifft2(FFT);
IFFT = IFFT./max(IFFT(:));

% plot whitened versions
FFT = fft2(double(IFFT));
power_whitened = abs(fftshift(FFT));
phase_whitened = angle(fftshift(FFT));
subplot(3,3,7),
imshow(IFFT+0.6),
title('Whitened Image');
subplot(3,3,8),
imshow(log(power_whitened+1),[]),
title('Whitened Power Spectrum')
subplot(3,3,9),
imshow(phase_whitened,[]),
title('Whitened Phase Spectrum');
diff = phase - phase_random;
max(diff(:));