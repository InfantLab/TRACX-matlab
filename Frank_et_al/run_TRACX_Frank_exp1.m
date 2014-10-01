function [mean_delta_words, mean_delta_nonwords, all_runs_word_delta_data, all_runs_nonword_delta_data] = ...
  run_TRACX_Frank_exp1 (language_type)

global CRITERION;
global BIAS_VALUE;
global NO_OF_SYLLABLES
global NO_OF_RUNS;
global MAX_EPOCHS
global epoch_ctr;
global ALL_ERRORS
global REINFORCEMENT_THRESHOLD

NO_OF_SYLLABLES = 18;
set_params;

NO_OF_WORDS = 6;
NO_OF_NONWORDS = 6;

tic
for run_no = 1:NO_OF_RUNS
  if run_no == 1
    fprintf('\n Run no.: %d \n', run_no);
  else
    fprintf('%d ', run_no);
  end;

  fprintf('Subject: ');
  for subject_no = 1:NO_OF_SUBJECTS
    str_file = strcat('DATA1/', language_type, 'M', int2str(subject_no), '.txt');
    % fprintf('\n');
    if subject_no == NO_OF_SUBJECTS
      fprintf('%d \n', subject_no);
    else
      fprintf('%d ', subject_no);
    end;

    if (run_no == 1) && (subject_no == 1)
      all_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_nonword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_NONWORDS);
      all_runs_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_nonword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_NONWORDS);
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
      %word_list = unique(sentence_cell_array);

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
    word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klmn'}, {'opqr'}];
    nonword_list = [{'bc'}, {'da'}, {'fgh'}, {'jef'}, {'mnop'}, {'rklm'}];

    for i = 1:length(word_list)
      word_array = convert_str_to_array(cell2mat(word_list(i)));
      word_delta = test_delta(word_array);
      all_word_delta_data(subject_no, i) = word_delta;
    end;
    
    for i = 1:length(nonword_list)
      nonword_array = convert_str_to_array(cell2mat(nonword_list(i)));
      nonword_delta = test_delta(nonword_array);
      all_nonword_delta_data(subject_no, i) = nonword_delta;
    end;
  end;

  all_runs_word_delta_data = ((run_no-1)*all_runs_word_delta_data + all_word_delta_data)/run_no;
  all_runs_nonword_delta_data = ((run_no-1)*all_runs_nonword_delta_data + all_nonword_delta_data)/run_no;

end;
mean_delta_words = mean(all_runs_word_delta_data);
mean_delta_nonwords = mean(all_runs_nonword_delta_data);

xlswrite('Frank_Expt_1.xls', [{'word av.'}, {'partword av.'}]', language_type, 'a2:a3');
xlswrite('Frank_Expt_1.xls', [mean(mean_delta_words), mean(mean_delta_nonwords)]', language_type, 'b2:b3');
xlswrite('Frank_Expt_1.xls', mean_delta_words, language_type, 'd2:i2');
xlswrite('Frank_Expt_1.xls', mean_delta_nonwords, language_type, 'd3:i3');

xlswrite('Frank_Expt_1.xls', [{'word data'}], language_type, 'a7');
xlswrite('Frank_Expt_1.xls', word_list, language_type, 'a8');
xlswrite('Frank_Expt_1.xls', all_runs_word_delta_data, language_type, 'a9')

xlswrite('Frank_Expt_1.xls', [{'partword data'}], language_type, 'h7');
xlswrite('Frank_Expt_1.xls', nonword_list, language_type, 'h8');
xlswrite('Frank_Expt_1.xls', all_runs_nonword_delta_data, language_type, 'h9')

fprintf('\n');

toc
return;

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
Target = Input_pat(1:end-1); % take off the Bias Node
delta =  max(abs(Target - Out));
return;



