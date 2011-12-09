function a = SRN_wt_matrices ()

global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global IH_wts;
global HO_wts;
global IH_dwts;
global Old_IH_dwts;
global HO_dwts;
global Old_HO_dwts;

IH_wts = rand(INPUTS+1, HIDDENS) - 0.5;           
HO_wts = rand(HIDDENS+1, TARGET_OUTPUTS) - 0.5;

IH_dwts = zeros(INPUTS+1, HIDDENS);
Old_IH_dwts = zeros(INPUTS+1, HIDDENS);
HO_dwts = zeros(HIDDENS+1, TARGET_OUTPUTS);
Old_HO_dwts = zeros(HIDDENS+1, TARGET_OUTPUTS);


return;



