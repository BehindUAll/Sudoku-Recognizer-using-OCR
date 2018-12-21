% Created by Sahil Pethe (ssp5329@rit.edu)

function run_analysis(filename)
% this function is used to run the analysis on the images by using im2bw 
% thresholding and then using function find_angle() to find the angle after
% which the entire image is rotated after which bwlabel is used to 
% get the coordinates of the connected areas and then using max(r) and
% min(r) to get the min and max values of the rows and same for columns. We
% use this to get the square area we are trying to foucs on. After this, we
% use OCR to find the best guess for the number in the square. 

% adding the test images path
addpath( '../TEST_IMAGES');
addpath( '../../TEST_IMAGES');

% reading the file name
img = imread(filename);

% converting to black and white using thresholding
img1 = im2bw(img);

% finding angle to rotate the entire image by
angle = find_angle(img1);

% rotating the original image as well as the modified image
img = imrotate(img, -angle);
img1 = imrotate(img1, -angle);
imshow(img);

% finding all the connected components in the image and filling the largest
% white space with black
CC = bwconncomp(img1);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
img1(CC.PixelIdxList{idx}) = 0;

% using opening to find the white islands
se = strel('disk', 3);
img4 = imopen(img1, se);


% the resulting image might not be free of white specs or salt noise but we
% are using a certain condition to filter out the low area regions early on
% befored doing analysis

% we use bwlabel to get the number of total islands in the image (this may 
% be higher or equal to the number of cells in the sudokus in the image)
[L, num] = bwlabel(img4, 8);

% we use this for loop to iterate through each cell and perform recogntion
% of the numbers in the cell 
for i = 1:num
    % iterating through each cell given by the label number
    [r, c] = find(L == i);
    
    % ignoring artifacts small enough to not be considered as a die
    if max(r) - min(r) > 30 && max(c) - min(c) > 30
        try
            
                                          
            
            % cropping image to further analyze the cell in question. we
            % decrease the boundary by 2 pixel on each side for better 
            % character recognition. We use try to ignore the index out of 
            % bounds exception when providing indices to crop the image
            % (just in case this happens. Though it shouldn't)
            cropped_part = img(min(r)+2: max(r)-2, min(c)+2:max(c)-2);
            
            % show the cropped part
            imshow(cropped_part);
            
            % in the below block of code, we perform OCR 4 times, each time
            % rotating the image by 90 degrees and storing the results of
            % the recognition
            
            % OCR #1
            ocrResults = ocr(cropped_part,'CharacterSet','123456789', 'TextLayout','word');
            aa = deblank(ocrResults.Text);
            ab = ocrResults.WordConfidences;
            
            cropped_part = imrotate(cropped_part, -90);
            
            % show the cropped part
            imshow(cropped_part);
            
            % OCR #2
            ocrResults = ocr(cropped_part,'CharacterSet','123456789','TextLayout','word');
            ba = deblank(ocrResults.Text);
            bb = ocrResults.WordConfidences;
            
            cropped_part = imrotate(cropped_part, -90);
            
            % show the cropped part
            imshow(cropped_part);

            
            % OCR #3
            ocrResults = ocr(cropped_part,'CharacterSet','123456789','TextLayout','word');
            ca = deblank(ocrResults.Text);
            cb = ocrResults.WordConfidences;
            
            cropped_part = imrotate(cropped_part, -90);
            
            % show the cropped part
            imshow(cropped_part);
            
            % OCR #4
            ocrResults = ocr(cropped_part,'CharacterSet','123456789','TextLayout','word');
            da = deblank(ocrResults.Text);
            db = ocrResults.WordConfidences;

            max_confidence = single(0);

            
            % below block of if statements is used to find the maximum
            % degree of confidence
            if max_confidence < ab
               max_confidence = ab; 
            end
            if max_confidence < bb
               max_confidence = bb; 
            end
            if max_confidence < cb
               max_confidence = cb; 
            end
            if max_confidence < db
               max_confidence = db; 
            end
            
            
            % below block of if statements will get the text identified by
            % OCR with the corresponding maximum degree of confidence
            if max_confidence == ab
                disp(aa);
            end
            if max_confidence == bb
                disp(ba);
            end
            if max_confidence == cb
                disp(ca);
            end
            if max_confidence == db
                disp(da);
            end
           
            % show the cropped part 
            imshow(cropped_part);
            pause(0.2);
            
            
        catch
            
        end
    end
    
end

end