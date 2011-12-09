global INPUTS
global HIDDENS
global OUTPUTS

global NO_OF_RUNS
global MAX_EPOCHS
global NO_OF_WORDS
global NO_OF_NONWORDS
global NO_OF_SYLLABLES

global LEARNING_RATE
global MOMENTUM

global Temperature
global Fahlman_offset
global BIAS_VALUE
global REINFORCEMENT_THRESHOLD

NO_OF_SYLLABLES = 18;   % 12 for Aslin, Saffran, Fwd, Bkwd ;  18 for Cognition Exp1, Arnaud; 27 for expt3, last data set
INPUTS = 2*NO_OF_SYLLABLES;
HIDDENS = NO_OF_SYLLABLES;
OUTPUTS = INPUTS;

NO_OF_SUBJECTS = 12;
NO_OF_RUNS = 5;   
MAX_EPOCHS = 1;   
CRITERION = 0.4;  
LEARNING_RATE = .04;  
MOMENTUM = 0;    
REINFORCEMENT_THRESHOLD = 0.25;

NO_OF_WORDS = 10;     %  this is the max no. of words
NO_OF_NONWORDS = 6;  %  this is the no. of nonwords tested.

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 


