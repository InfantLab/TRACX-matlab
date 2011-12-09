function S = generate_eq_TP_seq(seq_len)
   
no = ceil(9*rand());
S = [char(96+no)];

for i = 1:seq_len
  switch no
    case 1
      rand_no = rand();
      no = 2 + round(rand_no);
    case {2, 3}
      rand_no = rand();
      if rand_no <= 0.5
        no = 4;
      else
        no = 7;
      end;
    case 4
      rand_no = rand();
      no = 5 + round(rand_no);
    case {5, 6}
      rand_no = rand();
      if rand_no <= 0.5
        no = 1;
      else
        no = 7;
      end;
    case 7
      rand_no = rand();
      no = 8 + round(rand_no);
    case {8, 9}
      rand_no = rand();
      if rand_no <= 0.5
        no = 1;
      else
        no = 4;
      end;
  end;
  S = [S, char(96+no)];
end;

sid = fopen('eq_TP.txt', 'w');
fprintf(sid, '%s', S);
fclose(sid);

return