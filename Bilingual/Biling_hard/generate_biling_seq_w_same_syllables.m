function [S, str_file] = generate_biling_seq_w_same_syllables (no_of_sentences, switch_prob)

N = [];
old_no = 0;
word_len = 3;
sentence_len = 3;

S = [];

Sa = 'abc';
Va = 'def';
Oa = 'ghi';

Sb = 'def'; 
Vb = 'abc';   %abc
Ob = 'ghi';

languages = ['A', 'B'];
lang_no = round(rand)+1;
cur_lang = languages(lang_no);
w = 1;

while w <= no_of_sentences

  if rand() < switch_prob
    lang_no = mod(lang_no,2) + 1;
    cur_lang = languages(lang_no);
  end;

  if cur_lang == 'A'
    s = Sa(ceil(3*rand));
    v = Va(ceil(3*rand));
    o = Oa(ceil(3*rand));
  else
    s = Sb(ceil(3*rand));
    v = Vb(ceil(3*rand));
    o = Ob(ceil(3*rand));
  end;

  sentence = [s,v,o];
  
  if (strcmp(sentence, 'adg') == 1 || ...
      strcmp(sentence, 'beh') == 1 || ...
      strcmp(sentence, 'cfi') == 1 || ...
      strcmp(sentence, 'dag') == 1 || ...
      strcmp(sentence, 'ebh') == 1 || ...
      strcmp(sentence, 'fci') == 1) == false
    w = w+1;
    S = [S, sentence];
  end;  
end;

% S = strrep(S, 'bdg', []);   % This is where one cvc is taken out completely
% S = strrep(S, 'adg', []);
% S = strrep(S, 'beh', []);
% S = strrep(S, 'cfi', []);
% S = strrep(S, 'dag', []);
% S = strrep(S, 'ebh', []);
% S = strrep(S, 'fci', []);
%  {'adg'}, 1
%  {'beh'}, 14
%  {'cfi'}, 27
%  {'dag'}, 28
%  {'ebh'}, 41
%  {'fci'}, 54

str_file = strcat('biling_seq_', num2str(no_of_sentences), '.txt');
sid = fopen(str_file, 'w');
fprintf(sid, '%s', S);
fclose(sid);


return;