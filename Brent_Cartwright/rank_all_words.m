function rank_ordered_dict = rank_all_words(corpus_file)   
  
% creates a rank-ordered dictionary and gives num. of occ. of each word in
% dict
  corpus_list = create_wordcell_list(corpus_file);   
  dict_list = unique(corpus_list);
  dict_length = length(dict_list);
  
  dict_ranking_mat = [];
  
  for n = 1:dict_length
    word = dict_list(n);
    no_of_w = sum(strcmp(word, corpus_list));
    if no_of_w ~= 0
      dict_ranking_mat = [dict_ranking_mat; word, no_of_w];
    end;
  end;
  
  [sorted_nos, sort_index] = sort(cell2mat(dict_ranking_mat(:,2)), 'descend');
  rank_ordered_dict = dict_ranking_mat(sort_index,:);
    
  return;