function [bipolar_array, bit_array] = convert_str_to_array (str)

global NO_OF_SYLLABLES

len_str = length(str);
bit_array = zeros(len_str, NO_OF_SYLLABLES);
bipolar_array = zeros(len_str, NO_OF_SYLLABLES);

for i = 1:len_str

%   if mod(i,250) == 0
%     fprintf('%d ', i);
%   end;
  letter = str(i);
  if (letter >= '@') && (letter <= 'z')
    zerovec = zeros(1, NO_OF_SYLLABLES);
    ascii_val = double(letter);
    if ascii_val == 64    %this is the '@' character Pierre used
      ascii_val = 123;
    end;
    a_val = 97;   % ascii value of 'a'
    one_position = ascii_val - a_val + 1;
    zerovec(one_position) = 1;
    bitvec = zerovec;
    bit_array(i,:) = bitvec;
  end;
end;

bipolar_array = bit_array;
bipolar_array(find(bit_array == 0)) = -1;


