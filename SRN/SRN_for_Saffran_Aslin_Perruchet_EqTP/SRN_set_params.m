% global INPUTS
% global HIDDENS
% global TARGET_OUTPUTS

global NO_OF_RUNS
global NO_OF_WORDS
global NO_OF_NONWORDS
global NO_OF_SYLLABLES
global NO_OF_SUBJECTS

global LEARNING_RATE
global MOMENTUM

global Temperature
global Fahlman_offset
global BIAS_VALUE

NO_OF_SYLLABLES = 12;   
NO_OF_RUNS = 30; 
NO_OF_SUBJECTS = 1;
CRITERION = 0.4;  
LEARNING_RATE = .01;   
MOMENTUM = 0.9;    

NO_OF_WORDS = 9;     %  this is the max no. of words
NO_OF_NONWORDS = 6;  %  this is the no. of nonwords tested.

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 

% INPUTS = 5;
% HIDDENS = 5;
% TARGET_OUTPUTS = INPUTS;


