% Created by Sahil Pethe (ssp5329@rit.edu)

function angle = find_angle(img)
% This function is used to find the anlge we have to rotate the entire
% image by in order to get the individual squares to perform OCR on 

% finding all the connected components in the image and filling the largest
% white space with black
CC = bwconncomp(img);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
img(CC.PixelIdxList{idx}) = 0;

% code for hough lines
img = edge(img,'canny');
[H,T,R] = hough(img);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

% finding the hough lines using the T, R and P values we got using the
% hough function
lines = houghlines(img,T,R,P,'FillGap',10,'MinLength',7);

% finding the end points of the line. Here it doesn't matter which line we
% take because we to just find the angle. Even if the line is
% perpendicular, it is fine since we will rotate it by 90 degrees
point1 = lines(2).point1;
point2 = lines(2).point2;

% calculating the slope of the line and finding the angle of the line to
% know what angle to rotate it by 
slope = (point1(1)-point2(1))/(point1(2)-point2(2));
angle = atand(slope);

end