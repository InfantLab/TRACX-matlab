function [mean_delta_words, mean_delta_nonwords] = run_TRACX_SEQUENCES (seq_csv_file)

% an adaptation of Bob French's TRACX code to simuluate/fit data from my
% PHD infant sequence learning tasks. 
% the model is fed the exact sequence of shapes that the infants saw and
% outputs a error score after each one. We wish to see if this score is
% predicitive of the end of trials. 


global CRITERION;
global BIAS_VALUE;
global LEARNING_RATE
global REINFORCEMENT_THRESHOLD

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global NO_OF_RUNS;
global MAX_EPOCHS

global NO_OF_SYLLABLES

global LEARNING_RATE
global MOMENTUM
global REINFORCEMENT_THRESHOLD

global Temperature
global Fahlman_offset
global BIAS_VALUE

% set_params;
NO_OF_SYLLABLES = 6;   % 12 for Aslin, Saffran, Fwd, Bkwd ;  18 for Cognition Exp1, Arnaud; 27 for expt3, last data set
NO_OF_SUBJECTS = 1;
NO_OF_RUNS = 20;   % default 10 for Arnaud, Expt1, Expt3; 25 for fwd, bkwd, saffran, aslin
MAX_EPOCHS = 1;   %default 3 for the Cognition expts where after each sentence, there is a refresh.  1 in bkwd, fwd, saffran, aslin
CRITERION = 0.3;  
LEARNING_RATE = .04;  
MOMENTUM = 0;    %default 
REINFORCEMENT_THRESHOLD = 0.25;

Temperature = 1;
Fahlman_offset = 0.1;
BIAS_VALUE = -1; 


%read in the actual infant data
NUM_BABIES = 20;
NUM_TRIALS = 6;
% 5 by 120(6trials* 20infants)
% columns are
% ID	Trial	COND	PATTERN	SEQUENCE
allsequencedata = readparticipantchains(seq_csv_file);

%now group the data by participant. have each of their six trials strung
%together into one long string.
row = 0;
for baby = 1:NUM_BABIES
    stimuli = [];
    trialend  = 0;
    for trial = 1:6
        row=row+1;
        trialitems = parsesequencestring(allsequencedata{row, 5});
        trialend = trialend + length(trialitems);
        %make a note of where the baby looked away/trial ended
        trialends(baby,trial) = trialend;
        stimuli = [stimuli trialitems];
    end
    babystimuli{baby} = stimuli;
    %recode the inputs for this baby
    [bipolar_array, bit_array] = convert_str_to_array(stimuli);
    bipolar_baby{baby} = bipolar_array;
    bit_baby{baby}= bit_array;
end


NO_RUNS = 1; % just once through the data

INPUTS = 12; %2 syllables each taking one of six values
HIDDENS = INPUTS/2;
TARGET_OUTPUTS = INPUTS;



delta_data = [];
babytrialenddeltas = [];

tic
fprintf('\n Run no.: ');
for run_no = 1:NO_OF_RUNS
  fprintf('%d ', run_no);
  wt_matrices;

  for baby = 1:NUM_BABIES
    bipolar_array = bipolar_baby{baby};
    bit_array = bit_baby{baby};
      
    str_len = length(babystimuli{baby}); 
    In_t1 = bipolar_array(1,:);
    In_t2 = bipolar_array(2,:);

    i = 1;
    delta = 500;   % some very big delta to start with
    stepdelta = ones(str_len,1) * 500; % initialise the array to save deltas
    
    while i < str_len-1
      if delta < CRITERION
        In_t1 = Hid(1:end-1);
      else
        In_t1 = bipolar_array(i,:);
      end;
      In_t2 = bipolar_array(i+1,:);

      Input_pat = [In_t1, In_t2, BIAS_VALUE];
      [Hid, Out] = tanh_feedforward(Input_pat);
      Target = Input_pat(1:end-1); % take off the Bias Node

      % if on input the LHS comes from an internal representation then only
      % do a learning pass 25% of the time, since internal representations,
      % since internal representations are attentionally weaker than input
      % from the real, external world.
      if (delta > CRITERION) || (rand() <= REINFORCEMENT_THRESHOLD)
        bp_tanh_backprop(Input_pat, Hid, Out, Target, LEARNING_RATE);
        [Hid, Out] = tanh_feedforward(Input_pat);
      end;
      delta =  max(abs(Target - Out));
      stepdelta(i) = delta;
      i = i+1;
    end;
    
%     babydeltas{baby} = stepdelta;
    trialenddeltas = zeros(6,6);
    for trial = 1:6
        lastitem = trialends(baby,trial) -2; %-2 since network starts output on third item it sees
        trialenddeltas(trial,1:6) = stepdelta(lastitem -5:lastitem);
    end
    babytrialenddeltas = [babytrialenddeltas ;trialenddeltas];
    mean(trialenddeltas,1);
  end;
    meandeltas = mean(babytrialenddeltas,1)
    stderrors = std(babytrialenddeltas,0,1)*1.96/(120)^0.5
end;


%csvwrite('alldeltaout.csv',babytrialenddeltas);

% mean_delta_words = mean(all_word_delta_data);
% mean_delta_nonwords = mean(all_nonword_delta_data);
% 
% xlswrite(strcat(namestr, '_data.xls'), mean(mean_delta_words), 'Main', 'A2');
% xlswrite(strcat(namestr, '_data.xls'), mean(mean_delta_nonwords), 'Main', 'A3');
% xlswrite(strcat(namestr, '_data.xls'), all_word_delta_data, 'Words', 'B2');
% xlswrite(strcat(namestr, '_data.xls'), all_nonword_delta_data, 'Partwords', 'B2');


fprintf('\n');
toc

return;


