function all_sentences = convert_LxMx(str_file)
  fid_in = fopen(str_file, 'r');
  V = fgets(fid_in);
  fclose(fid_in);
  
  len_V = length(V);
  sentence = [];
  all_sentences = [];
  for i = 1:len_V-1
    syllable = V(i);
    if syllable ~= '/'
      sentence = [sentence, syllable];
    else
      if V(i+1) == '/'
        all_sentences = [all_sentences; {sentence}];
        sentence = [];
      end;
    end;
  end;
  return
  
        