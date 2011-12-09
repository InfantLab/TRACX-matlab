function W_list = create_wordcell_list(filename)
%each word in the file must be on a separate line
fid = fopen(filename, 'r');
w = fgets(fid);
W_list = [];

if strfind(filename, 'dict')
  OFFSET = 4;
elseif strfind(filename, 'corpus')
  OFFSET = 2;
elseif strfind(filename, 'nonwords')
  OFFSET = 2;
else
  disp('Not dictionary or corpus');
  return;
end;

while ~feof(fid)
w = w(1:end-OFFSET);
W_list = [W_list, {w}];
w = fgets(fid);

end;
fclose(fid);

return;