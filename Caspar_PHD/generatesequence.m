function chain = generatesequence(sequencelength, version, cond)

%kirkham matrix

kmat = [0 1 0 0 0 0; 
        0.3333 0 0.3333 0 0.3334 0; 
        0 0 0 1 0 0; 
        0.3333 0 0.3333 0 0.3334 0; 
        0 0 0 0 0 1;
        0.3333 0 0.3333 0 0.3334 0] ;

%triplets matrix
tmat = [0 1 0 0 0 0; 
        0 0 1 0 0 0; 
        0.5 0 0 0.5 0 0;
        0 0 0 0 1 0; 
        0 0 0 0 0 1; 
        0.5 0 0 0.5 0 0; 
        ] ;
    
%nonrepeating matrix
nmat = [0 .2 .2 .2 .2 .2;
        .2 0 .2 .2 .2 .2;
        .2 .2 0 .2 .2 .2;
        .2 .2 .2 0 .2 .2;
        .2 .2 .2 .2 0 .2;
        .2 .2 .2 .2 .2 0];
           
if version == 1 % random vs pairs (i.e. original kirkham design)
    if cond == 1
        PROBS = kmat;
    else
        PROBS = nmat;
    end
elseif version == 2 % pairs vs triplets
    if cond == 1
        PROBS = kmat;
    else
        PROBS = tmat;
    end
else % random vs triplets
    if cond == 1
        PROBS = tmat;
    else
        PROBS = nmat;
    end    
end
[nfromstates ntostates] = size(PROBS); 

% we start in competely random state
rowidx = 1 + floor(6*rand(1));
chain =  rowidx  ;
    
for i=1:sequencelength -1        
    p = rand(1);
    q=0;
    for newrowidx = 1:ntostates
        q= q+  PROBS(rowidx, newrowidx);
        if p < q,            break, end
    end
    rowidx=newrowidx;
    chain = [chain; rowidx];
end
