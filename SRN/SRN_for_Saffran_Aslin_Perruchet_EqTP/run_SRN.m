function [mean_delta_words, mean_delta_partwords, all_word_delta_data, all_partword_delta_data] = ...
  run_SRN (str_file)

global BIAS_VALUE;

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global NO_OF_RUNS;
global epoch_ctr;
global ALL_ERRORS

ALL_ERRORS = [];

fid = fopen(str_file, 'r');
char_str = fgets(fid);
fclose(fid);

%  char_str = char_str(end:-1:1);
SRN_set_params;

%bipolar_array = convert_str_to_array(char_str);
if ~isempty(strfind(str_file, 'bkwd')) || ~isempty(strfind(str_file, 'fwd'))
  bipolar_array = convert_bkwd_str_to_array(char_str);
else
  bipolar_array = convert_str_to_array(char_str);
end;
str_len = size(bipolar_array, 1);

INPUTS = 2*size(bipolar_array, 2);
HIDDENS = size(bipolar_array, 2);
TARGET_OUTPUTS = size(bipolar_array, 2);

fprintf('\n Run no.: ');
for run_no = 1:NO_OF_RUNS
  fprintf('%d ', run_no);
  SRN_wt_matrices;
  epoch_ctr = 0;

  i = 1;
  delta = 500;

  while i < str_len-1
    epoch_ctr = epoch_ctr+1;
    if i ==1
      Hid = [zeros(1, HIDDENS), BIAS_VALUE];
      Input_pat = [bipolar_array(1,:), Hid(1:end-1), BIAS_VALUE];
    else
      Input_pat = [bipolar_array(i,:), Hid(1:end-1), BIAS_VALUE];
    end;
    Target = bipolar_array(i+1,:);
    [Hid, Out] = SRN_tanh_feedforward(Input_pat);
    SRN_bp_tanh_backprop(Input_pat, Hid, Out, Target);
    i = i+1;
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
  else
    disp('No such list type');
  end;

  switch list_no
    case 0    %bkwd list
      namestr = 'bkwd';
      bkwd_word_list = [{'xb'}, {'xc'}, {'ye'}, {'yf'}, {'zh'}, {'zi'}];
      bkwd_partword_list = [{'ax'}, {'ay'}, {'dy'}, {'dz'}, {'gx'}, {'gz'}];
      for i = 1:length(bkwd_word_list)
        word_array = convert_bkwd_str_to_array(cell2mat(bkwd_word_list(i)));
        word_delta = test_bkwd_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;

      for i = 1:length(bkwd_partword_list)
        partword_array = convert_bkwd_str_to_array(cell2mat(bkwd_partword_list(i)));
        partword_delta = test_bkwd_delta(partword_array);
        all_partword_delta_data(run_no, i) = partword_delta;
      end;

    case 1  %fwd list
      namestr = 'fwd';
      fwd_word_list = [{'bx'}, {'cx'}, {'ey'}, {'fy'}, {'hz'}, {'iz'}];
      fwd_partword_list = [{'xa'}, {'xd'}, {'yd'}, {'yg'}, {'za'}, {'zg'}];
      for i = 1:length(fwd_word_list)
        %fwd and bkwd strings convert in the same way, Perruchet & Desaulty
        word_array = convert_bkwd_str_to_array(cell2mat(fwd_word_list(i)));
        word_delta = test_fwd_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
      %       fprintf('\n');
      for i = 1:length(fwd_partword_list)
        partword_array = convert_bkwd_str_to_array(cell2mat(fwd_partword_list(i)));
        partword_delta = test_fwd_delta(partword_array);
        all_partword_delta_data(run_no, i) = partword_delta;
      end;

    case 2  % saffran
      namestr = 'saffran';
      saffran_word_list = [{'abc'}, {'def'}, {'ghi'}, {'jkl'}];
      saffran_partword_list = [{'cde'}, {'fgh'}, {'ijk'}, {'lab'}];

      for i = 1:length(saffran_word_list)
        word_array = convert_str_to_array(cell2mat(saffran_word_list(i)));
        word_delta = test_saffran_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
      
      for i = 1:length(saffran_partword_list)
        partword_array = convert_str_to_array(cell2mat(saffran_partword_list(i)));
        partword_delta = test_saffran_delta(partword_array);
        all_partword_delta_data(run_no, i) = partword_delta;
      end;
      
    case 3  %aslin
      namestr = 'aslin';
      aslin_word_list = [{'abc'}, {'ghi'}, {'def'}, {'jkl'}];
      aslin_partword_list = [{'cgh'}, {'iab'}, {'fab'}, {'fjk'}];

      for i = 1:length(aslin_word_list)
        word_array = convert_str_to_array(cell2mat(aslin_word_list(i)));
        word_delta = test_aslin_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
        %    fprintf('%s: %f \n', cell2mat(word_list(i)), test_aslin_delta(word_array));
      end;
      %   fprintf('\n');
      for i = 1:length(aslin_partword_list)
        partword_array = convert_str_to_array(cell2mat(aslin_partword_list(i)));
        partword_delta = test_aslin_delta(partword_array);
        all_partword_delta_data(run_no, i) = partword_delta;
      end;

    case 4  % eq_TP
      namestr = 'eq_TP';
      eq_TP_word_list = [{'ab'}, {'ac'}, {'de'}, {'df'}, {'gh'}, {'gi'}];
      eq_TP_partword_list = [{'bd'}, {'bg'}, {'cd'}, {'cg'}, {'eg'}, {'ea'}, ...
        {'fg'}, {'fa'}, {'ha'}, {'hd'}, {'ia'}, {'id'}];
      for i = 1:length(eq_TP_word_list)
        word_array = convert_str_to_array(cell2mat(eq_TP_word_list(i)));
        word_delta = test_eq_TP_delta(word_array);
        all_word_delta_data(run_no, i) = word_delta;
      end;
      
      for i = 1:length(eq_TP_partword_list)
        partword_array = convert_str_to_array(cell2mat(eq_TP_partword_list(i)));
        partword_delta = test_eq_TP_delta(partword_array);
        all_partword_delta_data(run_no, i) = partword_delta;
      end;
  end;
end;

 mean_delta_words = mean(all_word_delta_data);
 mean_delta_partwords = mean(all_partword_delta_data);
 
 str_file = str_file(1:end-8);   % takes off the _seq.txt from the filenames
 xlswrite(strcat('SRN_', str_file, '_data.xls'), {'Words'}, 'Main', 'a2');
 xlswrite(strcat('SRN_', str_file, '_data.xls'), {'Partwords'}, 'Main', 'a3');
 xlswrite(strcat('SRN_', str_file, '_data.xls'), mean(mean_delta_words), 'Main', 'B2');
 xlswrite(strcat('SRN_', str_file, '_data.xls'), mean(mean_delta_partwords), 'Main', 'B3');
 xlswrite(strcat('SRN_', str_file, '_data.xls'), all_word_delta_data, 'Words' , 'B2');
 xlswrite(strcat('SRN_', str_file, '_data.xls'), all_partword_delta_data, 'Partwords', 'B2');

  
  fprintf('\n');

fprintf('\n');
return;

%>>>
function delta = test_delta(word_array)
global BIAS_VALUE;
no_of_prims = size(word_array, 2);

In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);
In_t1 = Hid(1:end-1);
In_t2 = word_array(3,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat, 'Auto');
Target = Input_pat(1:end-1); % take of the Bias Node
delta =  max(abs(Target - Out));
return;

function delta = test_bkwd_delta(word_array) %all Perr/Desaulty words/partwords have 2 syllables
global BIAS_VALUE;
Word = word_array(1,:);
Context = zeros(1, size(word_array, 2));
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);
Target = word_array(2,:);
delta =  max(abs(Target - Out));
return;

function delta = test_fwd_delta(word_array) %all Perr/Desaulty words/partwords have 2 syllables
global BIAS_VALUE;
Word = word_array(1,:);
Context = zeros(1, size(word_array, 2));
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);
Target = word_array(2,:);
delta =  max(abs(Target - Out));
return;


function delta = test_saffran_delta(word_array)  %all Saffran and Aslin words/partwords have 3 syllables
global BIAS_VALUE;
Word = word_array(1,:);
Context = zeros(1, size(word_array, 2));
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);

Word = Out;
Context = Hid(1:end-1);
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);

Target = word_array(3,:);
delta =  max(abs(Target - Out));
return;

function delta = test_aslin_delta(word_array)   %all Aslin words/partwords have 3 syllables
global BIAS_VALUE;
Word = word_array(1,:);
Context = zeros(1, size(word_array, 2));
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);

Word = Out;
Context = Hid(1:end-1);
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);

Target = word_array(3,:);
delta =  max(abs(Target - Out));
return;

function delta = test_eq_TP_delta(word_array) %all Perr/Desaulty words/partwords have 2 syllables
global BIAS_VALUE;
Word = word_array(1,:);
Context = zeros(1, size(word_array, 2));
Input_pat = [Word, Context, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);
Target = word_array(2,:);
delta =  max(abs(Target - Out));
return;
