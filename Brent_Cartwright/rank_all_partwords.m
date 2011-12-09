function [biphon_partword_list, triphon_partword_list] = rank_all_partwords(corpus_file)

% creates a rank-ordered dictionary and gives num. of occ. of each word in
% dict
corpus_list = create_wordcell_list(corpus_file);
len_corpus = length(corpus_list);
biphon_partword_list = [];
triphon_partword_list = [];

for n = 1:len_corpus-1
  cellword1 = corpus_list(n);
  cellword2 = corpus_list(n+1);

  matword1 = cell2mat(cellword1);
  matword2 = cell2mat(cellword2);

  if (length(matword1) > 1) && (length(matword2) > 1)
    partword_phoneme1 = matword1(end);
    if rand() < 0.5
      partword_phoneme2 = matword2(1);
      new_biphon = {[partword_phoneme1, partword_phoneme2]};
      biphon_partword_list = [biphon_partword_list, new_biphon];
    else
      partword_phonemes2 = matword2(1:2);
      new_triphon = {[partword_phoneme1, partword_phonemes2]};
      triphon_partword_list = [triphon_partword_list, new_triphon];
    end;
  end;
end;
return;