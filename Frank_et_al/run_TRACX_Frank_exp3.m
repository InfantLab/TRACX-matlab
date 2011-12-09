function [mean_delta_words, all_runs_word_delta_data, mean_delta_partwords, all_runs_partword_delta_data] = ...
  run_TRACX_Frank_exp3 (language_type)

global CRITERION;
global BIAS_VALUE;

global NO_OF_RUNS;
global NO_OF_SUBJECTS;
global NO_OF_SYLLABLES;

global MAX_EPOCHS

global epoch_ctr;
global ALL_ERRORS
global REINFORCEMENT_THRESHOLD

NO_OF_SYLLABLES = 27;
set_params;
tic;

for run_no = 1:NO_OF_RUNS
  fprintf('Run no.: %d \n', run_no);
  fprintf('Subject: ');
  for subject_no = 1:NO_OF_SUBJECTS
    str_file = strcat('DATA3/', language_type, 'M', int2str(subject_no), '.txt');
    % fprintf('\n');
    if subject_no == NO_OF_SUBJECTS
      fprintf('%d \n', subject_no);
    else
      fprintf('%d ', subject_no);
    end;

    if strfind(str_file, 'L3')
      NO_OF_WORDS = 3;
    elseif strfind(str_file, 'L4')
      NO_OF_WORDS = 4;
    elseif strfind(str_file, 'L5')
      NO_OF_WORDS = 5;
    elseif strfind(str_file, 'L6')
      NO_OF_WORDS = 6;
    elseif strfind(str_file, 'L9')
      NO_OF_WORDS = 9;
      NO_OF_SYLLABLES = 27;
    else
      disp('No such list type');
    end;
    NO_OF_PARTWORDS = NO_OF_WORDS;
    
    if (run_no == 1) && (subject_no == 1)
      all_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_PARTWORDS);
    end;

    ALL_ERRORS = [];
    sentence_cell_array = convert_LxMx(str_file);
    no_of_sentences = length(sentence_cell_array);
    wt_matrices;

    for s = 1:no_of_sentences
      char_str = cell2mat(sentence_cell_array(s));
      bipolar_array = convert_str_to_array(char_str);
      sentence_len = length(char_str);

      epoch_ctr = 0;
      word_list = unique(sentence_cell_array);

      for epoch = 1:MAX_EPOCHS        % sentence level
        In_t1 = bipolar_array(1,:);
        In_t2 = bipolar_array(2,:);
        Input_pat = [In_t1, In_t2, BIAS_VALUE];
        i = 1;
        delta = 500;
        chunk_len = 1;
        sentence_array = bipolar_array;
        word = sentence_array(1, :);
        sentence_array_length = size(sentence_array, 1);

        syll = 1;
        no_of_reinforcement_loops = 1;

        while ~isempty(sentence_array)
          epoch_ctr = epoch_ctr+1;
          i = i+1;
          Input_pat = [In_t1, In_t2, BIAS_VALUE];
          [Hid, Out] = tanh_feedforward(Input_pat);
          Target = Input_pat(1:end-1); % take off the Bias Node

          % if on input the LHS comes from an internal representation then only
          % do a learning pass 25% of the time, since internal representations,
          % since internal representations are attentionally weaker than input
          % from the real, external world. NOTE:  this is a very clunky way of 
          % implementing this, but is the original implementation.  For a
          % cleaner implementation see run_TRACX in the Saffran_Aslin_Perruchet
          % directory.  The two implementations are isomorphic.

          if delta > CRITERION
            bp_tanh_backprop(Input_pat, Hid, Out, Target);
          else
            if rand() >= REINFORCEMENT_THRESHOLD
              no_of_reinforcement_loops = 0;
            else
              no_of_reinforcement_loops = 1;
            end;
            for loop = 1:no_of_reinforcement_loops
              Input_pat = [In_t1, In_t2, BIAS_VALUE];
              [Hid, Out] = tanh_feedforward(Input_pat);
              Target = Input_pat(1:end-1); % take off the Bias Node
              bp_tanh_backprop(Input_pat, Hid, Out, Target);
            end;
          end;
          [Hid, Out] = tanh_feedforward(Input_pat);
          Target = Input_pat(1:end-1); % take off the Bias Node
          delta =  max(abs(Target - Out));

          syll = syll+1;
          if syll+1 > sentence_array_length
            break;
          end;

          if delta < CRITERION
            In_t1 = Hid(1:end-1);
            word = [word; In_t2];
            chunk_len = chunk_len + 1;
            In_t2 = sentence_array(syll+1,:);
          else
            sentence_array = sentence_array(chunk_len+1:end, :);
            sentence_array_length = size(sentence_array, 1);
            syll = 1;
            In_t1 = sentence_array(syll, :);
            word = [In_t1];
            In_t2 = sentence_array(syll+1,:);
            chunk_len = 0;
          end;
        end;
      end;
    end;

    % >>>>>>>>
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
      %       fprintf('%s: %f \n', cell2mat(word_list(i)), test_delta(word_array));
    end;
    for i = 1:length(partword_list)
      partword_array = convert_str_to_array(cell2mat(partword_list(i)));
      partword_delta = test_delta(partword_array);
      all_partword_delta_data(subject_no, i) = partword_delta;
      %       fprintf('%s: %f \n', cell2mat(partword_list(i)), test_delta(partword_array));
    end;

  end;
  all_runs_word_delta_data = ((run_no-1)*all_runs_word_delta_data + all_word_delta_data)/run_no;
  all_runs_partword_delta_data = ((run_no-1)*all_runs_partword_delta_data + all_partword_delta_data)/run_no;
end;

MW = mean(all_runs_word_delta_data);
MNW = mean(all_runs_partword_delta_data);

mean_delta_words = mean(MW);
mean_delta_partwords = mean(MNW);

xlswrite('Frank_Expt_3.xls', {language_type}, language_type, 'a1');
xlswrite('Frank_Expt_3.xls', {'Words'}, language_type, 'b1');
xlswrite('Frank_Expt_3.xls', word_list, language_type, 'b2');
xlswrite('Frank_Expt_3.xls', all_runs_word_delta_data, language_type, 'b3');
xlswrite('Frank_Expt_3.xls', MW, language_type, 'b16');

xlswrite('Frank_Expt_3.xls', {'Partwords'}, language_type, 'b23');
xlswrite('Frank_Expt_3.xls', partword_list, language_type, 'b24');
xlswrite('Frank_Expt_3.xls', all_runs_partword_delta_data, language_type, 'b25');
xlswrite('Frank_Expt_3.xls', MNW, language_type, 'b38');

responses_correct = length(find(all_runs_word_delta_data < all_runs_partword_delta_data));
total_responses = length(all_runs_word_delta_data(:));
percentage_correct = responses_correct/total_responses;

xlswrite('Frank_Expt_3.xls', {'% correct'}, language_type, 'd1');
xlswrite('Frank_Expt_3.xls', percentage_correct, language_type, 'e1');

toc
fprintf('\n');
return;

%>>>
%auxiliary fcn
function delta = test_delta(word_array)
global BIAS_VALUE;
no_of_syllables = size(word_array,1);

In_t1 = word_array(1,:);
In_t2 = word_array(2,:);
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);

for syllable = 3:no_of_syllables
  In_t1 = Hid(1:end-1);
  In_t2 = word_array(syllable,:);
  Input_pat = [In_t1, In_t2, BIAS_VALUE];
  [Hid, Out] = tanh_feedforward(Input_pat);
end;
Target = Input_pat(1:end-1); % take of the Bias Node
delta =  max(abs(Target - Out));
return;

