function [mean_delta_words, mean_delta_partwords, all_word_delta_data, all_partword_delta_data] = ...
  run_SRN_Frank_exp3(language_type)

global BIAS_VALUE;

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global NO_OF_RUNS;
global epoch_ctr;
global ALL_ERRORS

ALL_ERRORS = [];

%  char_str = char_str(end:-1:1);
SRN_set_params;

NO_OF_WORDS = 9;
NO_OF_PARTWORDS = 9;

NO_OF_SYLLABLES = 27;   %for Exp3
INPUTS = 2*NO_OF_SYLLABLES;    % the number of syllables is set in the main file
HIDDENS = NO_OF_SYLLABLES;
TARGET_OUTPUTS = NO_OF_SYLLABLES;


tic
fprintf('\n Run no.: ');
for run_no = 1:NO_OF_RUNS
  fprintf('%d ', run_no);
  SRN_wt_matrices;
  epoch_ctr = 0;

  i = 1;
  delta = 500;

  fprintf('Subject: ');
  for subject_no = 1:NO_OF_SUBJECTS
    str_file = strcat('DATA3/', language_type, 'M', int2str(subject_no), '.txt');
    % fprintf('\n');
    if subject_no == NO_OF_SUBJECTS
      fprintf('%d \n', subject_no);
    else
      fprintf('%d ', subject_no);
    end;

    if (run_no == 1) && (subject_no == 1)
      all_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_PARTWORDS);
      all_runs_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_PARTWORDS);
    end;

    ALL_ERRORS = [];
    sentence_cell_array = convert_LxMx(str_file);
    no_of_sentences = length(sentence_cell_array);

    SRN_wt_matrices;
    %   for no_of_cycles = 1:3
    for s = 1:no_of_sentences
      char_str = cell2mat(sentence_cell_array(s));
      bipolar_array = convert_str_to_array(char_str);
      sentence_len = length(char_str);

      epoch_ctr = 0;
      word_list = unique(sentence_cell_array);

      for epoch = 1:MAX_EPOCHS        % sentence level
        i = 1;
        while i < sentence_len
          epoch_ctr = epoch_ctr+1;
          if i == 1
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
      end;
    end;


    if strfind(str_file, 'L3')
      list_no = 3;
    elseif strfind(str_file, 'L4')
      list_no = 4;
    elseif strfind(str_file, 'L5')
      list_no = 5;
    elseif strfind(str_file, 'L6')
      list_no = 6;
    elseif strfind(str_file, 'L9')
      list_no = 9;
    else
      disp('No such list type');
    end;

    switch list_no
      case 3
        word_list = [{'ab'}, {'efg'}, {'klmn'}];
        partword_list = [{'be'}, {'fgk'}, {'mnef'}];
      case 4
        word_list = [{'ab'}, {'efg'}, {'hij'}, {'klmn'}];
        partword_list = [{'be'}, {'fgh'}, {'ijk'}, {'mnef'}];
      case 5
        word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klmn'}];
        partword_list = [{'be'}, {'dh'}, {'fgh'}, {'ijk'}, {'mnef'}];
      case 6
        word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klmn'}, {'opqr'}];
        partword_list = [{'be'}, {'dh'}, {'fgh'}, {'ijk'}, {'mnef'}, {'qrhi'}];
      case 9
        word_list = [{'ab'}, {'cd'}, {'st'}, {'efg'}, {'hij'}, {'uvw'}, {'klmn'}, {'opqr'}, {'xyz@'}];
        partword_list = [{'be'}, {'dh'}, {'tu'}, {'fgk'}, {'ijo'}, {'vwx'}, {'mnef'}, {'qrhi'}, {'z@uv'}];
    end;


    for i = 1:length(word_list)
      word_array = convert_str_to_array(cell2mat(word_list(i)));
      word_delta = test_delta(word_array);
      all_word_delta_data(subject_no, i) = word_delta;
    end;

    for i = 1:length(partword_list)
      partword_array = convert_str_to_array(cell2mat(partword_list(i)));
      partword_delta = test_delta(partword_array);
      all_partword_delta_data(subject_no, i) = partword_delta;
    end;
  end;

  all_runs_word_delta_data = ((run_no-1)*all_runs_word_delta_data + all_word_delta_data)/run_no;

  all_runs_partword_delta_data = ((run_no-1)*all_runs_partword_delta_data + all_partword_delta_data)/run_no;
end;

mean_delta_words = mean(all_runs_word_delta_data);
mean_delta_partwords = mean(all_runs_partword_delta_data);

xlswrite('SRN_Frank_Expt_3.xls', [{'word av.'}, {'partword av.'}]', language_type, 'a2:a3');
xlswrite('SRN_Frank_Expt_3.xls', [mean(mean_delta_words), mean(mean_delta_partwords)]', language_type, 'b2:b3');
xlswrite('SRN_Frank_Expt_3.xls', mean_delta_words, language_type, 'd2:i2');
xlswrite('SRN_Frank_Expt_3.xls', mean_delta_partwords, language_type, 'd3:i3');

xlswrite('SRN_Frank_Expt_3.xls', [{'word data'}], language_type, 'a7');
xlswrite('SRN_Frank_Expt_3.xls', word_list, language_type, 'a8');
xlswrite('SRN_Frank_Expt_3.xls', all_runs_word_delta_data, language_type, 'a9')

xlswrite('SRN_Frank_Expt_3.xls', [{'partword data'}], language_type, 'h7');
xlswrite('SRN_Frank_Expt_3.xls', partword_list, language_type, 'h8');
xlswrite('SRN_Frank_Expt_3.xls', all_runs_partword_delta_data, language_type, 'h9')

fprintf('\n');
toc

return;

%>>>
function delta = test_delta(word_array)
global BIAS_VALUE;
global NO_OF_SYLLABLES

no_of_syllables = size(word_array,1);
syll_no = 1;

In_t1 = word_array(1,:);
In_t2 = zeros(1,NO_OF_SYLLABLES);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = SRN_tanh_feedforward(Input_pat);

syll_no = syll_no+1;
while syll_no < no_of_syllables
  In_t1 = word_array(syll_no, :);
  In_t2 = Hid(1:end-1);   %remove bias value
  Input_pat = [In_t1, In_t2, BIAS_VALUE];
  [Hid, Out] = SRN_tanh_feedforward(Input_pat);
  syll_no = syll_no+1;
end;
Target = word_array(no_of_syllables,:); % take off the Bias Node
delta =  max(abs(Target - Out));
return;

