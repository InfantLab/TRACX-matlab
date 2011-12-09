function a = tanh_squash(x)
% squashes the incoming activations between -1 and 1
global Temperature;
a = tanh(Temperature*x);

%std squashing function
%function a = squash(x)
% squashes the incoming activations between 0 and 1
%global Temperature;
%a = (1+exp(-x./Temperature)).^(-1);

