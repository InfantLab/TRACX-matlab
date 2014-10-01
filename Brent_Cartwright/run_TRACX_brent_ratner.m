function [mean_delta_words, mean_delta_partwords] = ...
  run_TRACX_brent_ratner(infile, outfile)  % runs TRACX

% the infile name can be: br_phono_coded_v_short.txt  401 sentences
%                         br_phono_coded_short.txt   1242 sentences
%                         br_phono_coded.txt    the full 9700 sentence text
%                         br_phono_coded_5x.txt five repetitions of this.
% In all of the above texts, each phoneme is separated by a / and each
% sentence by a //
% the dictionary is: dict_coded.txt    this is a bit confusing, because
% it is not coded like the main source texts.  It is just a list of the
% phonetic transcriptions of each word.

global CRITERION;
global BIAS_VALUE;

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;
global NO_OF_SYLLABLES;
global REINFORCEMENT_THRESHOLD;
global NO_OF_RUNS;
global MAX_EPOCHS

global epoch_ctr;

set_params;

% we produce the dictionary, rank ordered and according to length.
% almost certainly another better way to do this, but whatever
corpus_file = 'DATA_brent_ratner/br_phono_corpus_one_col.txt';

rank_ordered_dict = rank_all_words(corpus_file);
word_NumOcc_len = [rank_ordered_dict, num2cell(cellfun(@length, rank_ordered_dict(:,1)))];
col2 = word_NumOcc_len(:,2);
col2_neg = num2cell(-1*cell2mat(col2));
word_NumOcc_len(:,2) = col2_neg;
word_NumOcc_len_sorted = sortcell(word_NumOcc_len, [3,2]);
col2 = word_NumOcc_len_sorted(:,2);
col2_pos = num2cell(-1*cell2mat(col2));
word_NumOcc_len_sorted(:,2) = col2_pos;

dict_list = word_NumOcc_len_sorted(:,1);
len_of_words = cellfun('length', dict_list);
non_singletons_index = find(len_of_words ~= 1);
dict_list = dict_list(non_singletons_index);
word_NumOcc_len_sorted = word_NumOcc_len_sorted(non_singletons_index, :);

len_dict_list = size(dict_list, 1);

word_len = 1;
i = 1;
while i < len_dict_list
  word_len = cell2mat(word_NumOcc_len_sorted(i, 3));
  if word_len >= 4
    break;
  end;
  i = i+1;
end;
end_index = i-1;
dict_list = dict_list(1:end_index);

% find 2- and 3-phoneme partwords to test against the 2- and 3-phoneme
% words.
[PW2_list, PW3_list] = find_partwords(corpus_file);

PW2_list = setdiff(PW2_list, dict_list);
PW3_list = setdiff(PW3_list, dict_list);
len_PW2 = length(PW2_list);
len_PW3 = length(PW3_list);


% if you want to shorten the dictionary to test on.
%   [Y, I] = sort(cellfun(@length, dict_list));
%   new_dict_list = dict_list(I);
%   short_words_I = find((cellfun(@length, new_dict_list) <= 3) & ...
%                        (cellfun(@length, new_dict_list) > 1));
%   short_words_I = find((cellfun(@length, new_dict_list) == 2));
%
%   dict_list = new_dict_list(short_words_I);

NO_OF_NONWORDS = 90;

NO_OF_WORDS = length(dict_list);
for run_no = 1:NO_OF_RUNS
  if run_no == 1
    fprintf('\n Run no.: %d \n', run_no);
  else
    fprintf('%d ', run_no);
  end;

  fprintf('Subject: ');
  for subject_no = 1:NO_OF_SUBJECTS
    str_file = strcat('DATA_brent_ratner/', infile);
    if subject_no == NO_OF_SUBJECTS
      fprintf('%d \n', subject_no);
    else
      fprintf('%d ', subject_no);
    end;

    if (run_no == 1) && (subject_no == 1)
      all_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_word_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
      all_runs_partword_delta_data = zeros(NO_OF_SUBJECTS, NO_OF_WORDS);
    end

    sentence_cell_array = convert_raw_brent_ratner(str_file);
    no_of_sentences = length(sentence_cell_array);

    INPUTS = 2*NO_OF_SYLLABLES;
    HIDDENS = NO_OF_SYLLABLES;
    TARGET_OUTPUTS = INPUTS;

    wt_matrices;

    for s = 1:no_of_sentences
      if mod(s,50) == 0
        s
      end;
      char_str = cell2mat(sentence_cell_array(s));
      bipolar_array = convert_brent_str_to_array(char_str);
      sentence_len = length(char_str);

      epoch_ctr = 0;
      %word_list = unique(sentence_cell_array);

      for epoch = 1:MAX_EPOCHS        % sentence level
        In_t1 = bipolar_array(1,:);
        if size(bipolar_array,1) > 1
          In_t2 = bipolar_array(2,:);
        else
          In_t2 = zeros(1, NO_OF_SYLLABLES);
        end;
        Input_pat = [In_t1, In_t2, BIAS_VALUE];
        i = 1;
        delta = 500;    % start with an impossibly big delta
        sentence_array = bipolar_array;
        word = sentence_array(1, :);
        sentence_array_length = size(sentence_array, 1);
        
        while i < sentence_len-1
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
            % do a learning pass REINFORCEMENT_THRESHOLD proportion of the time, 
            % since internal representations, since internal representations 
            % are attentionally weaker than input from the real, external world.
            if (delta > CRITERION) || (rand() <= REINFORCEMENT_THRESHOLD)
              bp_tanh_backprop(Input_pat, Hid, Out, Target);
              [Hid, Out] = tanh_feedforward(Input_pat);
            end;
            delta =  max(abs(Target - Out));
            i = i+1;
          end;
      end;
    end;

    % if we wish to shorten the dictionary
    %   short_words_I = find((cellfun(@length, dict_list) <= 3) & ...
    %                        (cellfun(@length, dict_list) > 1));
    % %   short_words_I = find((cellfun(@length, dict_list) == 2));
    %
    %   dict_list = dict_list(short_words_I);

    %testing TRACX
    all_partwords = [];
    for i = 1:length(dict_list)

        word_array = convert_brent_str_to_array(cell2mat(dict_list(i)));
        word_len = size(word_array, 1);
        %        word_delta = test_delta(word_array);
      if (word_len == 2) || (word_len == 3)
        word_delta = new_test_delta(word_array);
        all_word_delta_data(subject_no, i) = word_delta;
      end;

      if word_len == 2
        rand_PW2_index = ceil(len_PW2*rand());
        partword = PW2_list(rand_PW2_index);
      elseif word_len == 3
        rand_PW3_index = ceil(len_PW3*rand());
        partword = PW3_list(rand_PW3_index);
      else
        disp('Not 2- or 3-phoneme word');
      end;

      if (word_len == 2) || (word_len == 3)
        all_partwords = [all_partwords; partword];
        partword_array = convert_brent_str_to_array(cell2mat(partword));
        partword_delta = new_test_delta(partword_array);
        all_partword_delta_data(subject_no, i) = partword_delta;
      end;
    end;
  end;
  all_runs_word_delta_data = ((run_no-1)*all_runs_word_delta_data + all_word_delta_data)/run_no;
  all_runs_partword_delta_data = ((run_no-1)*all_runs_partword_delta_data + all_partword_delta_data)/run_no;

end;

word_number_len_error = [word_NumOcc_len_sorted(1:end_index, :), num2cell(all_runs_word_delta_data')];
%write results here
xlswrite(outfile, [{'word'}, {'no. occ'}, {'length'}, {'error'}], 'Words', 'a1');
xlswrite(outfile, word_number_len_error, 'Words', 'a2');
mean_delta_words = mean(all_runs_word_delta_data);
fprintf('\n');

partword_number_len_error = [all_partwords, num2cell(all_runs_partword_delta_data')];
xlswrite(outfile, [{'partword'}, {'error'}], 'Partwords', 'a1');
xlswrite(outfile, partword_number_len_error, 'Partwords', 'a2');
mean_delta_partwords = mean(all_runs_partword_delta_data);
fprintf('\n');

return;

%>>>
function delta = test_delta(word_array)
global BIAS_VALUE;
no_of_syllables = size(word_array,1);

In_t1 = word_array(1,:);
if size(word_array, 1) == 1
  In_t2 = zeros(1,50);
else
  In_t2 = word_array(2,:);
end;
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

function delta = new_test_delta(word_array)
global BIAS_VALUE;
no_of_syllables = size(word_array,1);

In_t1 = word_array(1,:);
if size(word_array, 1) == 1
  In_t2 = zeros(1,50);
else
  In_t2 = word_array(2,:);
end;
Input_pat = [In_t1, In_t2, BIAS_VALUE];
[Hid, Out] = tanh_feedforward(Input_pat);

for syllable = 3:no_of_syllables
  In_t1 = Hid(1:end-1);
  In_t2 = word_array(syllable,:);
  Input_pat = [In_t1, In_t2, BIAS_VALUE];
  [Hid, Out] = tanh_feedforward(Input_pat);
end;

Target = Input_pat(1:end-1); % take off the Bias Node
delta =  mean(abs(Target - Out));
return;



