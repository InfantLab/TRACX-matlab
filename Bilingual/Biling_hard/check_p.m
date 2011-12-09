function fraction_correct = check_p (no_of_runs)
  correct = 0;
  
  for run = 1:no_of_runs 
     run
     p = run_TRACX_biling(10000, 0.025, 0.001);
     if p < 0.05
       correct = correct + 1;
     end;
  end;
  
  fraction_correct = correct/no_of_runs;
  return;