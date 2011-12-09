global NO_OF_SYLLABLES
global INPUTS
global HIDDENS
global OUTPUTS

global NO_OF_SUBJECTS
global NO_OF_RUNS
global MAX_EPOCHS
global CRITERION
global LEARNING_RATE
global MOMENTUM
global REINFORCEMENT_THRESHOLD

global Temperature
global Fahlman_offset
global BIAS_VALUE

INPUTS = 2*NO_OF_SYLLABLES;    % the number of syllables is set in the main file
HIDDENS = NO_OF_SYLLABLES;
OUTPUTS = INPUTS;

NO_OF_SUBJECTS = 12;
NO_OF_RUNS = 25;    
MAX_EPOCHS = 6;   
CRITERION = 0.4;  
LEARNING_RATE = .04;  
MOMENTUM = 0;
REINFORCEMENT_THRESHOLD = 0.25;

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 



