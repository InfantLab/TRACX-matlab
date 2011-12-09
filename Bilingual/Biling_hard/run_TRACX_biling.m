function [p, mean_delta_words, all_word_delta_data, all_word_hid_data] = run_TRACX_biling (no_of_words_in_str, switch_rate, use_prev_str)
% , all_word_delta_data, all_nonword_delta_data
global CRITERION;
global BIAS_VALUE;

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global NO_OF_SYLLABLES
global LEARNING_RATE
global REINFORCEMENT_THRESHOLD;

global NO_OF_RUNS;

global MAX_EPOCHS

global epoch_ctr;

set_params;

tic

%The six words left out of the training sequence were: adg, beh, cfi, dag,
%ebh, fci.
[S, str_file] = generate_biling_seq_w_same_syllables(no_of_words_in_str, switch_rate);

if nargin == 3
  bipolar_array = load('bipolar_array.txt', 'bipolar_array');
else
  fid = fopen(str_file, 'r');
  char_str = fgets(fid);
  fclose(fid);
  bipolar_array = convert_str_to_array(char_str);
  save 'bipolar_array.txt' -ascii bipolar_array ;
end;

str_len = size(bipolar_array, 1);

INPUTS = 2*size(bipolar_array, 2);
HIDDENS = INPUTS/2;
TARGET_OUTPUTS = INPUTS;

for run_no = 1:NO_OF_RUNS

  wt_matrices;
  epoch_ctr = 0;

% In_t1 is the LHS of the input vector
% In_t2 is the RHS of the input vector
  for ep = 1:MAX_EPOCHS
    In_t1 = bipolar_array(1,:);
    In_t2 = bipolar_array(2,:);
    Input_pat = [In_t1, In_t2, BIAS_VALUE];
    [Hid, Out] = tanh_feedforward(Input_pat);
    Target = Input_pat(1:end-1); % take off the Bias Node

    i = 1;
    delta = 500;   % some very big value to start with.

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
      rand_no = rand();
      if (delta > CRITERION) || (rand_no <= REINFORCEMENT_THRESHOLD)
        bp_tanh_backprop(Input_pat, Hid, Out, Target);
        [Hid, Out] = tanh_feedforward(Input_pat);
      end;
      delta =  max(abs(Target - Out));
      i = i+1;
    end;
  end;


% we test on all 57 possible words, including the six excluded words and
% produce a dendrogram of the hidden unit representations.
           
word_list = [
   % all Alpha words (first 3 lines) and then all Beta words (last 3 lines)  
             {'adg'}, {'adh'}, {'adi'}, {'aeg'}, {'aeh'}, {'aei'}, {'afg'}, {'afh'}, {'afi'}, ...
             {'bdg'}, {'bdh'}, {'bdi'}, {'beg'}, {'beh'}, {'bei'}, {'bfg'}, {'bfh'}, {'bfi'}, ...
             {'cdg'}, {'cdh'}, {'cdi'}, {'ceg'}, {'ceh'}, {'cei'}, {'cfg'}, {'cfh'}, {'cfi'}, ...
             {'dag'}, {'dah'}, {'dai'}, {'eag'}, {'eah'}, {'eai'}, {'fag'}, {'fah'}, {'fai'}, ...  
             {'dbg'}, {'dbh'}, {'dbi'}, {'ebg'}, {'ebh'}, {'ebi'}, {'fbg'}, {'fbh'}, {'fbi'}, ...
             {'dcg'}, {'dch'}, {'dci'}, {'ecg'}, {'ech'}, {'eci'}, {'fcg'}, {'fch'}, {'fci'}];
           
% Sb = 'abc'; 
% Vb = 'def';   % Alpha language
% Ob = 'ghi';

% Sb = 'def'; 
% Vb = 'abc';   % Beta language
% Ob = 'ghi';
         
  no_of_words = length(word_list);
  all_word_delta_data = [];
  all_word_hid_data = [];

  for i = 1:no_of_words
    word_array = convert_str_to_array(cell2mat(word_list(i)));
    [word_delta, hid_rep] = test_delta(word_array);
    all_word_delta_data(run_no, i) = word_delta;
    all_word_hid_data(i, :) = hid_rep(1:end-1);  % last elt is bias node value, always BIAS_VALUE
  end;
end;

mean_delta_words = mean(all_word_delta_data);

parameter_vec = zeros(no_of_words,1);
parameter_vec(1:3) = [no_of_words_in_str/100000; switch_rate; LEARNING_RATE];

% xlswrite('Biling_data.xls', mean(mean_delta_words), 'Mean', 'A1');
% xlswrite('Biling_data.xls', all_word_delta_data, 'Words', 'a1');
% xlswrite('Biling_data.xls', [all_word_hid_data, parameter_vec], 'Hid', 'a1');
% xlswrite('Biling_data.xls', parameter_vec, 'Hid', strcat(char(double('a')+NO_OF_SYLLABLES), '1'));

 Z = linkage(all_word_hid_data, 'ward', 'euclidean');
% 
 %figure(1);
 [H,T,perm] = dendrogram(Z, 0, 'orientation', 'right');

first_half_dendro = perm(1:ceil(no_of_words/2));
second_half_dendro = perm(ceil(no_of_words/2)+1:end);

n1 = length(find(first_half_dendro < ceil(no_of_words/2)));
n2 = length(find(second_half_dendro >= ceil(no_of_words/2)));

no_correct = [n1,n2]

bin_index_0 = find(perm < ceil(no_of_words/2));
bin_index_1 = find(perm >= ceil(no_of_words/2));

bin_perm(bin_index_0) = 0;
bin_perm(bin_index_1) = 1;

[H, p] = runstest(bin_perm);
p
fprintf('\n');
toc
return;

%>>>>>>>>>>>>>>>>
%Auxiliary functions
%>>>>>>>>>>>>>>>>

function [delta, Hid] = test_delta(word_array)
global BIAS_VALUE;
no_of_prims = size(word_array, 1);

In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
In_t1 = Hid(1:end-1);
In_t2 = word_array(3,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
Target = Input_pat(1:end-1); % take of the Bias Node
%delta =  max(abs(Target - Out));

delta =  mean(abs(Target - Out));
return;
