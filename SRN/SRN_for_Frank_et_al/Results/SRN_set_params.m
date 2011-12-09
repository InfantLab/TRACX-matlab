global INPUTS
global HIDDENS
global TARGET_OUTPUTS

global NO_OF_RUNS
global NO_OF_SUBJECTS
global MAX_EPOCHS

global NO_OF_SYLLABLES

global CRITERION
global LEARNING_RATE
global MOMENTUM

global Temperature
global Fahlman_offset
global BIAS_VALUE

NO_OF_RUNS = 25;  %25; 
NO_OF_SUBJECTS = 12;
MAX_EPOCHS = 6; 

% NO_OF_SYLLABLES = 18;   %for Exp1
%NO_OF_SYLLABLES = 27;   %for Exp3

CRITERION = 0.4;  
LEARNING_RATE = .01;   
MOMENTUM = 0.9;    %default 

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 

% INPUTS = 2*NO_OF_SYLLABLES;    % the number of syllables is set in the main file
% HIDDENS = NO_OF_SYLLABLES;
% TARGET_OUTPUTS = NO_OF_SYLLABLES;


