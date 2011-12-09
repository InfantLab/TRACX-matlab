function Av_All_runs_W = run_SRN_Giroux_Rey(no_of_hiddens)

global BIAS_VALUE;

global NO_OF_RUNS;
global NO_OF_SUBJECTS;
global MAX_EPOCHS
global NO_OF_WORDS
global NO_OF_NONWORDS
global NO_OF_SYLLABLES

global epoch_ctr;
global ALL_ERRORS

NO_OF_DATA_CYCLES = 30;
SRN_set_params;

NO_OF_WORDS = 10;
NO_OF_PARTWORDS = 6;

NO_OF_SYLLABLES = 18;
HIDDENS = no_of_hiddens;
INPUTS = NO_OF_SYLLABLES + HIDDENS;    % the number of syllables is set in the main file
TARGET_OUTPUTS = NO_OF_SYLLABLES;

all_word_delta_data = [];  %zeros(NO_OF_RUNS, NO_OF_WORDS);
all_partword_delta_data = zeros(NO_OF_RUNS, NO_OF_NONWORDS);

file_type = 'L1';

for run_no = 1:NO_OF_RUNS
  fprintf('\n Run no.: %d \n', run_no);

  for subject_no = 1:NO_OF_SUBJECTS
    fprintf('%d ', subject_no);
    str_file = strcat('DATA1/L1M', int2str(subject_no), '.txt');
    sentence_cell_array = convert_LxMx(str_file);
    sentence_cell_array = repmat(sentence_cell_array, [NO_OF_DATA_CYCLES,1]);

    no_of_sentences = length(sentence_cell_array);
    sentence_cell_array(randperm(no_of_sentences)) = sentence_cell_array;
    if (subject_no == 1) && (run_no == 1)
      Av_All_W = zeros(no_of_sentences, NO_OF_WORDS);
      Av_All_runs_W = zeros(no_of_sentences, NO_OF_WORDS);
    end;

    ALL_ERRORS = [];

    % test words
    test_word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klm'}, {'klmn'}, {'opqr'}, {'kl'}, {'lm'}, {'mn'}];
    test_partword_list = [{'bc'}, {'da'}, {'fgh'}, {'jef'}, {'mnop'}, {'rklm'}];

    All_W = zeros(no_of_sentences, length(test_word_list));

    SRN_wt_matrices;

    for s = 1:no_of_sentences
      if mod(s, 100) == 0
        fprintf('subject: %d, sentence: %d \n', subject_no, s);
      end;
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


      % >>>>>>>>
      %       word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klm'}, {'klmn'}, {'opqr'}, {'kl'}, {'lm'}, {'mn'}];
      %       partword_list = [{'bc'}, {'da'}, {'fgh'}, {'jef'}, {'mnop'}, {'rklm'}];
      %
      for i = 1:length(test_word_list)
        test_word_array = convert_str_to_array(cell2mat(test_word_list(i)));
        test_word_delta = test_delta(test_word_array);
        all_word_delta_data = [all_word_delta_data, test_word_delta];
      end;

      All_W(s, :) = all_word_delta_data;
      all_word_delta_data = [];

      for i = 1:length(test_partword_list)
        test_partword_array = convert_str_to_array(cell2mat(test_partword_list(i)));
        test_partword_delta = test_delta(test_partword_array);
        all_partword_delta_data(subject_no, i) = test_partword_delta;
      end;
    end;


    if (subject_no == 1) && (run_no == 1)
      Av_All_W = All_W;
    else
      Av_All_W = ((subject_no-1)*Av_All_W + All_W)/subject_no;
    end;
  end;
  
  if run_no == 1
    Av_All_runs_W = Av_All_W;
  else
    Av_All_runs_W = ((run_no-1)*Av_All_runs_W + Av_All_W)/run_no;
  end;
end;

xlswrite(strcat(num2str(HIDDENS), '_SRN_Giroux_Rey.xls'), [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klm'}, {'klmn'}, {'opqr'}, {'kl'}, {'lm'}, {'mn'}], file_type, 'a1');
xlswrite(strcat(num2str(HIDDENS), '_SRN_Giroux_Rey.xls'), Av_All_runs_W, file_type, 'a2')

fprintf('\n');
return;

%>>>
function delta = test_delta(word_array)
global BIAS_VALUE;
global HIDDENS;

no_of_syllables = size(word_array,1);
syll_no = 1;

In_t1 = word_array(1,:);
In_t2 = zeros(1,HIDDENS);
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

