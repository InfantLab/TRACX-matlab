function [mean_delta_words, mean_delta_nonwords] = run_TRACX (str_file)

global CRITERION;
global BIAS_VALUE;
global LEARNING_RATE
global REINFORCEMENT_THRESHOLD

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global NO_OF_RUNS;
global MAX_EPOCHS

set_params;

fid = fopen(str_file, 'r');
char_str = fgets(fid);
fclose(fid);

fprintf('%s \n', str_file);

if ~isempty(strfind(str_file, 'bkwd')) || ~isempty(strfind(str_file, 'fwd'))
  %bcs these two use x, y, z letters, as in the original sequences in
  %Perruchet & Desaulty.
  bipolar_array = convert_bkwd_str_to_array(char_str);
else
  bipolar_array = convert_str_to_array(char_str);
end;
str_len = length(char_str);

INPUTS = 2*size(bipolar_array, 2);
HIDDENS = INPUTS/2;
TARGET_OUTPUTS = INPUTS;

all_word_delta_data = [];
all_nonword_delta_data = [];

tic
fprintf('\n Run no.: ');
for run_no = 1:NO_OF_RUNS
  fprintf('%d ', run_no);
  wt_matrices;

  for ep = 1:MAX_EPOCHS
    In_t1 = bipolar_array(1,:);
    In_t2 = bipolar_array(2,:);

    i = 1;
    delta = 500;   % some very big delta to start with

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
      i = i+1;
    end;
  end;

  if strfind(str_file, 'bkwd')
    list_no = 0;
  elseif strfind(str_file, 'fwd')
    list_no = 1;
  elseif strfind(str_file, 'saffran')
    list_no = 2;
  elseif strfind(str_file, 'aslin')
    list_no = 3;
  elseif strfind(str_file, 'eq_TP')
    list_no = 4;
  elseif strfind(str_file, 'kirkham')
    list_no = 5;
  else
    disp('No such list type');
  end;

  switch list_no
    case 0    %bkwd list
      namestr = 'bkwd';
      bkwd_word_list = [{'xb'}, {'xc'}, {'ye'}, {'yf'}, {'zh'}, {'zi'}];
      bkwd_nonword_list = [{'ax'}, {'ay'}, {'dy'}, {'dz'}, {'gx'}, {'gz'}];
      for i = 1:length(bkwd_word_list)
        word_array = convert_bkwd_str_to_array(cell2mat(bkwd_word_list(i)));
        word_delta = test_bkwd_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
     
      for i = 1:length(bkwd_nonword_list)
        nonword_array = convert_bkwd_str_to_array(cell2mat(bkwd_nonword_list(i)));
        nonword_delta = test_bkwd_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;

    case 1  %fwd list
      namestr = 'fwd';
      fwd_word_list = [{'bx'}, {'cx'}, {'ey'}, {'fy'}, {'hz'}, {'iz'}];
      fwd_nonword_list = [{'xa'}, {'xd'}, {'yd'}, {'yg'}, {'za'}, {'zg'}];
      for i = 1:length(fwd_word_list)
        word_array = convert_fwd_str_to_array(cell2mat(fwd_word_list(i)));
        word_delta = test_fwd_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
      
      for i = 1:length(fwd_nonword_list)
        nonword_array = convert_fwd_str_to_array(cell2mat(fwd_nonword_list(i)));
        nonword_delta = test_fwd_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;

    case 2  % saffran
      namestr = 'saffran';
      saffran_word_list = [{'abc'}, {'def'}, {'ghi'}, {'jkl'}];
      saffran_nonword_list = [{'cde'}, {'fgh'}, {'ijk'}, {'lab'}];

      for i = 1:length(saffran_word_list)
        word_array = convert_str_to_array(cell2mat(saffran_word_list(i)));
        word_delta = test_saffran_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
      
      for i = 1:length(saffran_nonword_list)
        nonword_array = convert_str_to_array(cell2mat(saffran_nonword_list(i)));
        nonword_delta = test_saffran_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;

    case 3  %aslin
      namestr = 'aslin';
      aslin_word_list = [{'def'}, {'jkl'}, {'abc'}, {'ghi'} ];  % corresponds to A,B,C,D
      aslin_nonword_list = [{'cgh'}, {'iab'}, {'kfe'}, {'lje'}]; % -> CD, DC, LF1, LF2 (never seen nonwords)

      for i = 1:length(aslin_word_list)
        word_array = convert_str_to_array(cell2mat(aslin_word_list(i)));
        word_delta = test_aslin_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;

      for i = 1:length(aslin_nonword_list)
        nonword_array = convert_str_to_array(cell2mat(aslin_nonword_list(i)));
        nonword_delta = test_saffran_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;

    case 4  % eq_TP
      namestr = 'eq_TP';
      eq_TP_word_list = [{'ab'}, {'ac'}, {'de'}, {'df'}, {'gh'}, {'gi'}];
      eq_TP_nonword_list = [{'bd'}, {'bg'}, {'cd'}, {'cg'}, {'eg'}, {'ea'}, ...
        {'fg'}, {'fa'}, {'ha'}, {'hd'}, {'ia'}, {'id'}];
      for i = 1:length(eq_TP_word_list)
        word_array = convert_str_to_array(cell2mat(eq_TP_word_list(i)));
        word_delta = test_eq_TP_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;

      for i = 1:length(eq_TP_nonword_list)
        nonword_array = convert_str_to_array(cell2mat(eq_TP_nonword_list(i)));
        nonword_delta = test_eq_TP_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;
    case 5  % eq_TP
      namestr = 'kirkham';
      word_list = [{'ca'}, {'bd'}, {'ef'} ];
      nonword_list = [{'cd'}, {'cf'}, {'ba'}, {'bf'}, {'ea'}, {'ed'}];
      for i = 1:length(word_list)
        word_array = convert_str_to_array(cell2mat(word_list(i)));
        word_delta = test_eq_TP_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;

      for i = 1:length(nonword_list)
        nonword_array = convert_str_to_array(cell2mat(nonword_list(i)));
        nonword_delta = test_eq_TP_delta(nonword_array);
        all_nonword_delta_data(run_no, i) = nonword_delta;
      end;


  end;
end;
mean_delta_words = mean(all_word_delta_data);
mean_delta_nonwords = mean(all_nonword_delta_data);

xlswrite(strcat(namestr, '_data.xls'), mean(mean_delta_words), 'Main', 'A2');
xlswrite(strcat(namestr, '_data.xls'), mean(mean_delta_nonwords), 'Main', 'A3');
xlswrite(strcat(namestr, '_data.xls'), all_word_delta_data, 'Words', 'B2');
xlswrite(strcat(namestr, '_data.xls'), all_nonword_delta_data, 'Partwords', 'B2');


fprintf('\n');
toc

return;

%>>>>>>>>>>>>>>>>
%Auxiliary functions
%>>>>>>>>>>>>>>>>
function delta = test_bkwd_delta(word_array)
global BIAS_VALUE;
In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
Target = Input_pat(1:end-1); % take of the Bias Node
delta =  max(abs(Target - Out));
return;

function delta = test_fwd_delta(word_array)
global BIAS_VALUE;
In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
Target = Input_pat(1:end-1); % take of the Bias Node
delta =  max(abs(Target - Out));
return;

function delta = test_saffran_delta(word_array)
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
delta =  max(abs(Target - Out));
return;

function delta = test_aslin_delta(word_array)
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
delta =  max(abs(Target - Out));
return;

function delta = test_eq_TP_delta(word_array)
global BIAS_VALUE;
In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
Target = Input_pat(1:end-1); % take of the Bias Node
delta =  max(abs(Target - Out));
return;

