function prepareData()
% prepareData Extract relevant data from the zpped dataset
% This function reads and re-organizes the dataset and saves it in a new set
% of MATLAB data (.mat) files.
% 
% Dataset courtesy
% 
% Code originally by:
% Copyright 2014-2015 The MathWorks, Inc.

classes = 8;
MAX_CELLS = 200;

addpath('Data/Prepared')

% Path of current function
fcnpath = mfilename('fullpath');

% Default source path for original data
bs = strfind(fcnpath, '\');
defaultOriginalDataPath = fullfile(fcnpath(1:bs(end)-1),'Original');

% Identify archived data file
sourcePath = uigetdir(defaultOriginalDataPath, 'Select the Dataset Archive');

% Define destination path
destDataPath = fullfile(fcnpath(1:bs(end)-1),'Prepared');

fnames = dir(fullfile(sourcePath, '*.csv'));
subjects = length(fnames);
data = cell(subjects, classes + 1);
sequence_indices = cell(subjects, classes + 1);
for K = 1:subjects
  dataset = csvread(fullfile(sourcePath, fnames(K).name));
  o_class = 0;
  start_index = 1;
  end_index = 1;
  indices = ones(classes + 1, 1);
  for J = 1:length(dataset)
    class = dataset(J, end) + 1;
    if indices(class) == 1
        data{K, class} = cell(MAX_CELLS, 1);
        sequence_indices{K, class} = cell(MAX_CELLS, 1);
    end
    
    LOWEST_STRETCH = 400;
    HIGHEST_STRETCH = 600;
    if dataset(J, 4) < LOWEST_STRETCH || dataset(J, 4) > HIGHEST_STRETCH
       if (J ~= 1)
            dataset(J, 4) = dataset(J-1, 4);
       else
           dataset(J, 4) = LOWEST_STRETCH;
       end
    end
       
    if ((class == o_class || o_class == 0) && J ~= length(dataset))
        end_index = end_index + 1;
    else % If the class changed or it is the last element in sequence    
        d = [dataset(start_index:end_index, 1:5), ones(size(dataset(start_index:end_index, 1:5), 1), 1)*indices(o_class)];
        
        data{K, o_class}{indices(o_class)} = d;
        data{K, classes + 1}{indices(classes + 1)} = d;
        
        sequence_indices{K, o_class}{indices(o_class)} = [start_index,end_index];
        sequence_indices{K, classes + 1}{indices(classes + 1)} = [start_index,end_index];
        
        indices(o_class) = indices(o_class) + 1;
        indices(classes + 1) = indices(classes + 1) + 1;
        start_index = end_index;
        end_index = end_index + 1;
    end
    o_class = class;
  end
  
  for J = [1:length(indices)]
    data{K, J} = data{K, J}(1: (indices(J)-1)); % shorten size of cell array to the size needed
    sequence_indices{K, J} = sequence_indices{K, J}(1:(indices(J)-1));
  end
end

% Save relevant arrays to MAT file BufferedAccelerations.mat
fprintf('Saving buffered data...')
save(fullfile(destDataPath,'dataset.mat'),...
    'data', 'subjects', 'sequence_indices')
fprintf('Done.\n')