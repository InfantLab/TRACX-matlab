function a = tanh_deriv(squashed_output)
%derivative of the -1 to 1 tanh squashing fcn
global Fahlman_offset;
global Temperature;
a = Temperature * (1 - squashed_output.*squashed_output) + Fahlman_offset;
