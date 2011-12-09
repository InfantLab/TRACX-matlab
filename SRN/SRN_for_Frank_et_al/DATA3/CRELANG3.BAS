DIM mot$(9), ordre(600)

nsujet = 12

'PRINT "Nombre de mots? (max= "; INT(32767 / 9); ") ",
'INPUT Nbm
Nbm = 6


mots = 9

DATA a/b/
DATA e/f/g/ 
DATA k/l/m/n/
DATA h/i/j/
DATA c/d/
DATA o/p/q/r/
DATA s/t/
DATA u/v/w/
DATA x/y/z/@/


FOR i = 1 TO mots
  READ mot$(i)
NEXT i

N = 144'Nb de mots dans le language

         FOR sujet = 1 TO nsujet'********************************
sujet$ = STR$(sujet)
sujet$ = RIGHT$(sujet$, LEN(sujet$) - 1)

c = 0

FOR i = 1 TO N / 3
  FOR j = 1 TO 3
    c = c + 1
    ordre(c) = j
  NEXT j
NEXT i
DO

 FOR i = N TO 1 STEP -1 '++++++++++++
   iter = 0
     DO                  '------------
      recom = 0
      has = INT(RND * i) + 1
      IF ordre(has) = prov THEN recom = 1

      iter = iter + 1
     LOOP UNTIL recom = 0 OR iter = 100 '---------

     prov = ordre(has)
     ordre(has) = ordre(i)
     ordre(i) = prov

   NEXT i           '+++++++++++++
LOOP UNTIL iter < 100
                           
 corpus$ = ""
 FOR i = 1 TO N
   IF INT(i / 4) = i / 4 THEN
    corpus$ = corpus$ + mot$(ordre(i)) + "/"
   ELSE
    corpus$ = corpus$ + mot$(ordre(i))
   END IF
 NEXT i
'corpus$ = corpus$ + "/"
nom$ = "C:/PARSER/Frank/DATA3/L3M" + sujet$ + ".txt"

OPEN nom$ FOR OUTPUT AS #1
  PRINT #1, corpus$
CLOSE #1


c = 0

FOR i = 1 TO N / 4
  FOR j = 1 TO 4
    c = c + 1
    ordre(c) = j
  NEXT j
NEXT i
DO

 FOR i = N TO 1 STEP -1 '++++++++++++
   iter = 0
     DO                  '------------
      recom = 0
      has = INT(RND * i) + 1
      IF ordre(has) = prov THEN recom = 1

      iter = iter + 1
     LOOP UNTIL recom = 0 OR iter = 100 '---------

     prov = ordre(has)
     ordre(has) = ordre(i)
     ordre(i) = prov

   NEXT i           '+++++++++++++
LOOP UNTIL iter < 100
                          
 corpus$ = ""
 FOR i = 1 TO N
   IF INT(i / 4) = i / 4 THEN
    corpus$ = corpus$ + mot$(ordre(i)) + "/"
   ELSE
    corpus$ = corpus$ + mot$(ordre(i))
   END IF
 NEXT i
'corpus$ = corpus$ + "/"
nom$ = "C:/PARSER/Frank/DATA3/L4M" + sujet$ + ".txt"

OPEN nom$ FOR OUTPUT AS #1
  PRINT #1, corpus$
CLOSE #1

c = 0

FOR i = 1 TO N / 5
  FOR j = 1 TO 5
    c = c + 1
    ordre(c) = j
  NEXT j
NEXT i
DO

 FOR i = N TO 1 STEP -1 '++++++++++++
   iter = 0
     DO                  '------------
      recom = 0
      has = INT(RND * i) + 1
      IF ordre(has) = prov THEN recom = 1

      iter = iter + 1
     LOOP UNTIL recom = 0 OR iter = 100 '---------

     prov = ordre(has)
     ordre(has) = ordre(i)
     ordre(i) = prov

   NEXT i           '+++++++++++++
LOOP UNTIL iter < 100
                          
 corpus$ = ""
 FOR i = 1 TO N
   IF INT(i / 4) = i / 4 THEN
    corpus$ = corpus$ + mot$(ordre(i)) + "/"
   ELSE
    corpus$ = corpus$ + mot$(ordre(i))
   END IF
 NEXT i
'corpus$ = corpus$ + "/"
nom$ = "C:/PARSER/Frank/DATA3/L5M" + sujet$ + ".txt"

OPEN nom$ FOR OUTPUT AS #1
  PRINT #1, corpus$
CLOSE #1


c = 0

FOR i = 1 TO N / 6
  FOR j = 1 TO 6
    c = c + 1
    ordre(c) = j
  NEXT j
NEXT i
DO

 FOR i = N TO 1 STEP -1 '++++++++++++
   iter = 0
     DO                  '------------
      recom = 0
      has = INT(RND * i) + 1
      IF ordre(has) = prov THEN recom = 1

      iter = iter + 1
     LOOP UNTIL recom = 0 OR iter = 100 '---------

     prov = ordre(has)
     ordre(has) = ordre(i)
     ordre(i) = prov

   NEXT i           '+++++++++++++
LOOP UNTIL iter < 100
                            
 corpus$ = ""
 FOR i = 1 TO N
   IF INT(i / 4) = i / 4 THEN
    corpus$ = corpus$ + mot$(ordre(i)) + "/"
   ELSE
    corpus$ = corpus$ + mot$(ordre(i))
   END IF
 NEXT i
'corpus$ = corpus$ + "/"
nom$ = "C:/PARSER/Frank/DATA3/L6M" + sujet$ + ".txt"

OPEN nom$ FOR OUTPUT AS #1
  PRINT #1, corpus$
CLOSE #1


c = 0

FOR i = 1 TO N / 9
  FOR j = 1 TO 9
    c = c + 1
    ordre(c) = j
  NEXT j
NEXT i
DO

 FOR i = N TO 1 STEP -1 '++++++++++++
   iter = 0
     DO                  '------------
      recom = 0
      has = INT(RND * i) + 1
      IF ordre(has) = prov THEN recom = 1

      iter = iter + 1
     LOOP UNTIL recom = 0 OR iter = 100 '---------

     prov = ordre(has)
     ordre(has) = ordre(i)
     ordre(i) = prov

   NEXT i           '+++++++++++++
LOOP UNTIL iter < 100
                           
 corpus$ = ""
 FOR i = 1 TO N
   IF INT(i / 4) = i / 4 THEN
    corpus$ = corpus$ + mot$(ordre(i)) + "/"
   ELSE
    corpus$ = corpus$ + mot$(ordre(i))
   END IF
 NEXT i
'corpus$ = corpus$ + "/"
nom$ = "C:/PARSER/Frank/DATA3/L9M" + sujet$ + ".txt"

OPEN nom$ FOR OUTPUT AS #1
  PRINT #1, corpus$
CLOSE #1



                   NEXT sujet'***************************************

