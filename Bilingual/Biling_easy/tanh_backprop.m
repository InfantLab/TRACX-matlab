function a = bp_tanh_backprop(Hidden_out_activations, Output_out_activations, Target)

global Learning_rate;
global Momentum;
global HIDDENS;
global IH_wts;
global HO_wts;
global IH_dwts;
global HO_dwts;
global Old_IH_wts;
global Old_HO_wts;
global Old_IH_dwts;
global Old_HO_dwts;
global Input_pattern;

  Errors_RAW = Output_out_activations - Target;
  Errors_OUTPUT = Errors_RAW.*tanh_deriv(Output_out_activations);
  
  dE_dw = Hidden_out_activations' * Errors_OUTPUT;
  HO_dwts = -1 * Learning_rate*dE_dw + Momentum*Old_HO_dwts;
  HO_wts = HO_wts + HO_dwts;  
  Old_HO_dwts = HO_dwts;

  Errors_HIDDEN = Errors_OUTPUT * HO_wts';
%   Errors_HIDDEN = HO_wts * Errors_OUTPUT';
%   Errors_HIDDEN = Errors_HIDDEN';
  Errors_HIDDEN = Errors_HIDDEN.*tanh_deriv(Hidden_out_activations);
  
  dE_dw = Input_pattern' * Errors_HIDDEN(1:HIDDENS);  % no IH_dwts associated with the bias
  IH_dwts = -1*Learning_rate*dE_dw + Momentum*Old_IH_dwts;
  IH_wts = IH_wts + IH_dwts; 
  Old_IH_dwts = IH_dwts;


  



