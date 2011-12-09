function av_proportion_correct = calculate_hits(full_result_filename)
  [nums_words] = xlsread(full_result_filename, 'Words', 'b2:g26');
  [nums_partwords] = xlsread(full_result_filename, 'Partwords', 'b2:g26');
  
  
  no_of_rows = size(nums_words, 1);
  av_prop = 0;
  
  for r = 1:no_of_rows
    wrow = nums_words(r,:);
    pwrow = nums_partwords(r, :);
    [wrow_mesh, pwrow_mesh] = meshgrid(wrow, pwrow);
    diff_mat = gt(pwrow_mesh, wrow_mesh);
    prop_discriminated = length(find(diff_mat))/prod(size(diff_mat));
    av_prop = ((r-1)/r)*av_prop + prop_discriminated/r;
  end;
  av_proportion_correct = av_prop;
  return;
  