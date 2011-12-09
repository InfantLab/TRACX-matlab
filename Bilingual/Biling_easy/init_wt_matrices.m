function a = wt_matrices ()

global NO_OF_SYLLABLES;
global INPUTS;
global HIDDENS;
global TARGET_OUTPUTS;

global IH_wts;
global HO_wts;
global IH_dwts;
global Old_IH_dwts;
global HO_dwts;
global Old_HO_dwts;

INPUTS = 2*NO_OF_SYLLABLES;
HIDDENS = INPUTS/2;
TARGET_OUTPUTS = INPUTS;

IH_wts = rand(INPUTS+1, HIDDENS) - 0.5;           
HO_wts = rand(HIDDENS+1, TARGET_OUTPUTS) - 0.5;

IH_dwts = zeros(INPUTS+1, HIDDENS);
Old_IH_dwts = zeros(INPUTS+1, HIDDENS);
HO_dwts = zeros(HIDDENS+1, TARGET_OUTPUTS);
Old_HO_dwts = zeros(HIDDENS+1, TARGET_OUTPUTS);

% Hidden to Input network for unpacking chunks
% Recall_Net_net

global Recall_Net_INPUTS;
global Recall_Net_HIDDENS;
global Recall_Net_TARGET_OUTPUTS;

global Recall_Net_IH_wts;
global Recall_Net_HO_wts;
global Recall_Net_IH_dwts;
global Recall_Net_Old_IH_dwts;
global Recall_Net_HO_dwts;
global Recall_Net_Old_HO_dwts;

Recall_Net_INPUTS = NO_OF_SYLLABLES;
Recall_Net_HIDDENS = 3*NO_OF_SYLLABLES;
Recall_Net_TARGET_OUTPUTS = 2*NO_OF_SYLLABLES;  

Recall_Net_IH_wts = rand(Recall_Net_INPUTS+1, Recall_Net_HIDDENS) - 0.5;           
Recall_Net_HO_wts = rand(Recall_Net_HIDDENS+1, Recall_Net_TARGET_OUTPUTS) - 0.5;

Recall_Net_IH_dwts = zeros(Recall_Net_INPUTS+1, Recall_Net_HIDDENS);
Recall_Net_Old_IH_dwts = zeros(Recall_Net_INPUTS+1, Recall_Net_HIDDENS);
Recall_Net_HO_dwts = zeros(Recall_Net_HIDDENS+1, Recall_Net_TARGET_OUTPUTS);
Recall_Net_Old_HO_dwts = zeros(Recall_Net_HIDDENS+1, Recall_Net_TARGET_OUTPUTS);


% LR coherence network
global LR_INPUTS;
global LR_HIDDENS;
global LR_TARGET_OUTPUTS;

global LR_IH_wts;
global LR_HO_wts;
global LR_IH_dwts;
global LR_Old_IH_dwts;
global LR_HO_dwts;
global LR_Old_HO_dwts;

LR_INPUTS = NO_OF_SYLLABLES;
LR_HIDDENS = LR_INPUTS;
LR_TARGET_OUTPUTS = LR_INPUTS;

LR_IH_wts = rand(LR_INPUTS+1, LR_HIDDENS) - 0.5;           
LR_HO_wts = rand(LR_HIDDENS+1, LR_TARGET_OUTPUTS) - 0.5;

LR_IH_dwts = zeros(LR_INPUTS+1, LR_HIDDENS);
LR_Old_IH_dwts = zeros(LR_INPUTS+1, LR_HIDDENS);
LR_HO_dwts = zeros(LR_HIDDENS+1, LR_TARGET_OUTPUTS);
LR_Old_HO_dwts = zeros(LR_HIDDENS+1, LR_TARGET_OUTPUTS);


% RL coherence network
global RL_INPUTS;
global RL_HIDDENS;
global RL_TARGET_OUTPUTS;

global RL_IH_wts;
global RL_HO_wts;
global RL_IH_dwts;
global RL_Old_IH_dwts;
global RL_HO_dwts;
global RL_Old_HO_dwts;

RL_INPUTS = NO_OF_SYLLABLES;
RL_HIDDENS = RL_INPUTS;
RL_TARGET_OUTPUTS = RL_INPUTS;

RL_IH_wts = rand(RL_INPUTS+1, RL_HIDDENS) - 0.5;           
RL_HO_wts = rand(RL_HIDDENS+1, RL_TARGET_OUTPUTS) - 0.5;

RL_IH_dwts = zeros(RL_INPUTS+1, RL_HIDDENS);
RL_Old_IH_dwts = zeros(RL_INPUTS+1, RL_HIDDENS);
RL_HO_dwts = zeros(RL_HIDDENS+1, RL_TARGET_OUTPUTS);
RL_Old_HO_dwts = zeros(RL_HIDDENS+1, RL_TARGET_OUTPUTS);

return;



