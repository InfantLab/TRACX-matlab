global NO_OF_RUNS
global MAX_EPOCHS

global NO_OF_SYLLABLES

global LEARNING_RATE
global MOMENTUM
global REINFORCEMENT_THRESHOLD

global Temperature
global Fahlman_offset
global BIAS_VALUE

NO_OF_SYLLABLES = 6;   % 12 for Aslin, Saffran, Fwd, Bkwd ;  18 for Cognition Exp1, Arnaud; 27 for expt3, last data set
NO_OF_SUBJECTS = 1;
NO_OF_RUNS = 20;   % default 10 for Arnaud, Expt1, Expt3; 25 for fwd, bkwd, saffran, aslin
MAX_EPOCHS = 1;   %default 3 for the Cognition expts where after each sentence, there is a refresh.  1 in bkwd, fwd, saffran, aslin
CRITERION = 0.4;  
LEARNING_RATE = .04;  
MOMENTUM = 0;    %default 
REINFORCEMENT_THRESHOLD = 0.25;

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 



