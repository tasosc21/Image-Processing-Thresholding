tic;
clc;
clear;
close all;
format compact;

%import image
Filename = "lena_gray.png";
I=imread(Filename);

%Graylevels(L) & number  of pixels per graylevel
[counts, grayLevels] = imhist(I);
L=size(grayLevels,1);

%number of rows, columns & total pixels
[rows, columns, ~] = size(I);
total_pixels=numel(I);

%create matrix for probabolities of each graylevel
p=zeros(256,1);

%matrices for ω(probability per class), means, variance
omega0=zeros(L-1,1);
omega1=zeros(L-1,1);
m0=zeros(L-1,1);
m1=zeros(L-1,1);
var0=zeros(L-1,1);
var1=zeros(L-1,1);
var_within=zeros(L-1,1);

%calculate probabilities of graylevels
for t=1:L
    p(t)=counts(t)/total_pixels;
end

%calculation of ω, means, variances of each class &
%the variance within clase
for t=1:L-1

    %calculating probability and mean of class 0
    for i=1:t
        omega0(t) = omega0(t)+p(i);
        m0(t)=m0(t)+(i-1)*p(i);  
    end
    m0(t)=(1/omega0(t))*m0(t);

    %calculating variance of class 0
    for i=0:t-1
        var0(t)=var0(t)+((i-m0(t))^2)*p(i+1);
    end
    var0(t)=var0(t)/omega0(t);
    
    %calculating probability and mean of class 1
    omega1(t) = 1 - omega0(t);
    for j=t+1:L
        m1(t)=m1(t)+(j-1)*p(j);
    end
    m1(t)=(1/omega1(t))*m1(t);

    %calculating variance of class 1
    for j=t:L-1
        var1(t)=var1(t)+(((j-m1(t))^2)*p(j+1));        
    end
    var1(t)=var1(t)/omega1(t);

    %calculating variance within classes
    var_within(t)=omega0(t)*var0(t)+omega1(t)*var1(t);
    
end

%Threshold
threshold=grayLevels(find(var_within==min(var_within)));

% find values above threshold
above_threshold = (I >= threshold);

% initiate final image matrix and set values above threshold to white
I_Final=zeros(rows,columns);
I_Final(above_threshold) = 255;

%display unedited and binary image
%display histogram of unedited image with threshold
imshow(I);
figure, imshow(I_Final);
figure, imhist(I);
ylim([0 max(counts)]);
xline(threshold,'-',{'Threshold',threshold},LineWidth=1,Color='red', LabelOrientation='horizontal')

toc;