% Created by Sahil Pethe (ssp5329@rit.edu)

function Project_main()
% this function is used to get in input a set of images with sudoku in them
% on white background and we use a bunch of techniques to analyze the
% nunmbers in the sudokus and ouput the best guess using OCR and degree of
% confidence

% adding the directories
addpath( '../TEST_IMAGES');
addpath( '../../TEST_IMAGES');

% the folder in which images exists
srcFiles = dir('*.jpg');           

% for loop iterates through each file in the folder specified by the line
% above and passes it to the run_analysis() function which then runs a
% bunch of techniques to analyze the sudoku
for i = 1 : length(srcFiles)
    
    filename = strcat('',srcFiles(i).name);
    disp('Input filename:');          
    % outputting the file name
    disp(srcFiles(i).name);
    % running the analysis on the image
    run_analysis(filename);                                         
    
end


end