function [bipolar_array, bit_array] = convert_brent_str_to_array (str)
  
bit_array = [];
bipolar_array = [];
len_str = length(str);
all_symbols = '#%&()*3679ADEGILMNOQRSTUWZabcdefghiklmnoprstuvwyz~';
no_symbols = length(all_symbols);
zero_vec = zeros(1,no_symbols);

for i = 1:len_str
  letter = str(i);
  sym_index = find(all_symbols == letter);
  bitvec = zero_vec;
  bitvec(sym_index) = 1;
  bit_array = [bit_array; bitvec]; 
end;

  bipolar_array = bit_array;
  bipolar_array(find(bit_array == 0)) = -1;
  
  
    