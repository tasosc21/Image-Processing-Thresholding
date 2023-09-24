tic;
clc;
clear;
close all;
format compact;

%import image
Filename = 'lena_gray.png';
I=imread(Filename);

%window R - dimantions r*r
r = 5;
%constant c
c = 5;

padding = floor(r/2);
R=zeros(r,r);

%padded image
I_padded = padarray(I,[padding padding],"replicate","both");
[rows, columns, ~] = size(I_padded);

%new binary image with mean value threshold
I_Final = zeros(size(I));
for i=padding+1:rows-padding

    for j=padding+1:columns-padding
        R=I_padded(i-padding:i+padding, j-padding:j+padding);

        if ((min(R,[],'all')+max(R,[],'all'))/2)-c <= I_padded(i,j)
            I_Final(i-padding, j-padding)=255;
        end

    end

end
 
title_text = [Filename, '    Method: (min+max)/2    R: ',num2str(r),' x ',num2str(r),', c = ',num2str(c)];
imshow(I_Final);
title(title_text);

toc;
