function outstring = parsesequencestring(instring)

  [temp, len] = size(instring);
  j=0;
  k=0;
  parsedchain = [];
  ignore = false;
  while k < len
      k=k+1;
      if strcmp(instring(k),' ') == 1 || strcmp(instring(k),'"') == 1 
          %do nothing
      elseif strcmp(instring(k),'(') ==1
          ignore = true;
      elseif strcmp(instring(k),')') == 1
          ignore = false;
      else
          if ~ignore 
              j=j+1;                     
              parsedchain(j) = instring(k);
          end
      end
  end
  outstring = parsedchain;