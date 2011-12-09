function  calcallredundancies(seq1data, windowsize)

[r c] = size(seq1data);


results = cell(r,1);

L0mat  = zeros(r,90);
L1mat =  zeros(r,90);


for i =1:r
   %first process the chains to remove the missed items
  i
   
  thischain = char(seq1data(i,5));
  
  [temp, len] = size(thischain);
  j=0;
  k=0;
  parsedchain = [];
  ignore = false;
  
  while k < len
      k=k+1;
      if strcmp(thischain(k),' ') == 1 || strcmp(thischain(k),'"') == 1 
          %do nothing
      elseif strcmp(thischain(k),'(') ==1
          ignore = true;
      elseif strcmp(thischain(k),')') == 1
          ignore = false;
      else
          if ~ignore 
              j=j+1;                     
              parsedchain(j) = thischain(k);
          end
      end
  end
    [L0, L1]  = getredundancy(char(parsedchain),windowsize);

   results{i,1} = {L0};
%     results{i,2} = {L1}; 
%     [temp, len] = size(parsedchain);
%      
%     results(i) = len;

    [rs cs] = size(L0);
    L0mat(i,1:cs) = L0;
    
    [rs cs] = size(L1);
    L1mat(i,1:cs) = L1;
     
end

csvwrite(strcat('L0s_',num2str(windowsize),'.csv'),L0mat);
csvwrite(strcat('L1s_',num2str(windowsize),'.csv'),L1mat);