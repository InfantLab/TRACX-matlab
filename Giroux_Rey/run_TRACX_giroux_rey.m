function Av_All_runs_W = run_TRACX_giroux_rey()  
    
  global CRITERION;
  global LEARNING_RATE;
  global BIAS_VALUE;
  global REINFORCEMENT_THRESHOLD
  
  global NO_OF_RUNS;
  global NO_OF_SUBJECTS;
  global MAX_EPOCHS
  global NO_OF_WORDS
  global NO_OF_NONWORDS
  
  global epoch_ctr;
  global ALL_ERRORS
 
  NO_OF_DATA_CYCLES = 30;
  set_params;
   
  all_word_delta_data = zeros(NO_OF_RUNS, NO_OF_WORDS); 
  all_nonword_delta_data = zeros(NO_OF_RUNS, NO_OF_NONWORDS);
  
  file_type = 'L1';

  test_word_list = [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klm'}, {'klmn'}, {'opqr'}, {'kl'}, {'lm'}, {'mn'}];
  test_nonword_list = [{'bc'}, {'da'}, {'fgh'}, {'jef'}, {'mnop'}, {'rklm'}];

  tic
  for run_no = 1:NO_OF_RUNS
    fprintf('\n Run no.: %d \n', run_no);
    fprintf('Subject: ');
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
      All_W = zeros(no_of_sentences, length(test_word_list));
      %All_W = [];
      
      wt_matrices;

      for s = 1:no_of_sentences
        char_str = cell2mat(sentence_cell_array(s));
        bipolar_array = convert_str_to_array(char_str);

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
      % from the real, external world. NOTE:  this is a clunky way of 
      % implementing this, but is the original implementation.  For a
      % cleaner implementation see run_TRACX in the Saffran_Aslin_Perruchet
      % directory.  The two implementations are isomorphic.
        if delta > CRITERION   
           bp_tanh_backprop(Input_pat, Hid, Out, Target, LEARNING_RATE);
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
            bp_tanh_backprop(Input_pat, Hid, Out, Target, LEARNING_RATE);
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

      word_results = [];
       for i = 1:length(test_word_list)
          word_array = convert_str_to_array(cell2mat(test_word_list(i)));
          word_delta = test_delta(word_array);
          word_results = [word_results, word_delta];
       end;

       for i = 1:length(test_nonword_list)
          nonword_array = convert_str_to_array(cell2mat(test_nonword_list(i)));
          nonword_delta = test_delta(nonword_array);
          all_nonword_delta_data(subject_no, i) = nonword_delta;
       end;
      
       All_W(s, :) = word_results;
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

  xlswrite('Giroux_Rey.xls', [{'ab'}, {'cd'}, {'efg'}, {'hij'}, {'klm'}, {'klmn'}, {'opqr'}, {'kl'}, {'lm'}, {'mn'}], file_type, 'a1'); 
  xlswrite('Giroux_Rey.xls', Av_All_runs_W, file_type, 'a2')

  fprintf('\n'); 
  toc;
 return;

%>>>
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

  