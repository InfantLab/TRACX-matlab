
function [Hid, Out] = tanh_feedforward (Input)
  
  global IH_wts
  global HO_wts
  
  global BIAS_VALUE

  Hid_net_in_acts = Input * IH_wts;
  Hid_out_acts = tanh_squash(Hid_net_in_acts);

  Hid_out_acts = [Hid_out_acts, BIAS_VALUE];
  Output_net_in_acts = Hid_out_acts * HO_wts;
  Output_out_acts = tanh_squash(Output_net_in_acts);

  Hid = Hid_out_acts;
  Out = Output_out_acts;

 [Hid, Out];
  
  