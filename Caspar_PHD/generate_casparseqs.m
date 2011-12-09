function S = generate_casparseqs(seq_len, version, condition)
   
seq = generatesequence(seq_len,version,condition);
seq = seq' + 96;
S = char(seq);

sid = fopen('casparsequence.txt', 'w');
fprintf(sid, '%s', S);
fclose(sid);

return