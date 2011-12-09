function [bipolar_array, bit_array] = convert_bkwd_str_to_array (str)
  
bit_array = [];
bipolar_array = [];
len_str = length(str);

for i = 1:len_str
  letter = str(i);
  switch letter
    case 'a' 
      bitvec = [1 0 0 0 0 0 0 0 0 0 0 0];
    case 'b' 
      bitvec = [0 1 0 0 0 0 0 0 0 0 0 0];
    case 'c'
      bitvec = [0 0 1 0 0 0 0 0 0 0 0 0];
    case 'd' 
      bitvec = [0 0 0 1 0 0 0 0 0 0 0 0]; 
    case 'e' 
      bitvec = [0 0 0 0 1 0 0 0 0 0 0 0];
    case 'f' 
      bitvec = [0 0 0 0 0 1 0 0 0 0 0 0];
    case 'g'
      bitvec = [0 0 0 0 0 0 1 0 0 0 0 0];
    case 'h' 
      bitvec = [0 0 0 0 0 0 0 1 0 0 0 0]; 
    case 'i' 
      bitvec = [0 0 0 0 0 0 0 0 1 0 0 0];
    case 'x' 
      bitvec = [0 0 0 0 0 0 0 0 0 1 0 0];
    case 'y'
      bitvec = [0 0 0 0 0 0 0 0 0 0 1 0];
    case 'z' 
      bitvec = [0 0 0 0 0 0 0 0 0 0 0 1];
  end;
  
  bit_array = [bit_array; bitvec]; 
end;

  bipolar_array = bit_array;
  bipolar_array(find(bit_array == 0)) = -1;
  
  
    