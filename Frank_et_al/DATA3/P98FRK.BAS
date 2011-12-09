DECLARE SUB spparser ()
DIM SHARED ps$(200)'percept shaper
DIM SHARED ps3$(200)'PS avec /, pour interference
DIM SHARED ps4$(200)'PS avec /, pour tri de ps3
DIM SHARED bufint$(20)
DIM SHARED ps(200, 2) 'poids des mots en ps$
    '2 ordre dans lequel les unites sont trouvees
DIM SHARED ps2$(200), ps2(200, 2)'pour ordonner
DIM SHARED poss$(10), poss3$(10)
DIM SHARED dp(10)

COMMON SHARED nust, numt, syl, nsyl, nsyll, w1, w2, w3, sw, interf, name$
COMMON SHARED mvsp, corpus$, corpus3$, affich, pas, fait, fait2, nsujet
COMMON SHARED sujet, nbsyl, nbssuj, nbsysuj, stp, opt
COMMON SHARED lgps, longli, dp, fph, test, match, decal, commut, nbmt
DIM SHARED mot$(50)
'pastname1$ = "C:/PARSER/data.txt"
'pastname2$ = "C:/PARSER/result.txt"
pastname1$ = "C:/PARSER/Frank/DATA3/L6M.txt"
pastname2$ = "C:/PARSER/Frank/DATA3/L6R.txt"

pastmots = 6
pastsw$ = ".05"
pastinterf$ = ".005"
pastmode = 1
pastopt = 2
paststp = 0
start:
running = running + 1
CLS
PRINT
PRINT "************************************************************************"
PRINT
PRINT "  There are two modes to enter the speech flow:"
PRINT
PRINT "  Mode 1: Loading the text file(s) comprising the entire sequence(s). "
PRINT "          The syllables must be separated by '/ ', e.g.: 'bu/pa/da/..',  "
PRINT "          or 'a/b/..', or '1/6/3/..', or 'par/ti/ci/pant/..'"
PRINT "          Insert '//' (instead of '/') to mark the boundary of sentences."
PRINT "          Max size: 32767 car. (usually around 40 mn of speech)"
PRINT
PRINT "  Mode 2: Entering the data needed to generate a sequence."
PRINT "          You will be asked to provide:"
PRINT "          - the number of different words (default= 6)"
PRINT "          - each word in succession,"
PRINT "            e.g.: bu/pa/da,  or a/b, or 1/2/3,  or par/ti/ci/pant"
PRINT "            (default= trisllabic words composed of different syllables,"
PRINT "            noted S1S2S3, S4S5S6, etc.)"
PRINT "          - the number of repetitions of each word"
PRINT
PRINT "    Note: When the initial default names or values are changed,"
PRINT " the new name or value serves as a default for subsequent simulations"
PRINT "  THE VALUES BY DEFAULT ARE OBTAINED BY PRESSING THE 'ENTER' KEY"
PRINT
PRINT "************************************************************************"
PRINT
PRINT " 1= text file, 2= on-line generation (default = "; pastmode; "): ";
INPUT mode
IF mode = 0 THEN mode = pastmode
pastmode = mode
IF mode = 1 THEN
CLS
PRINT "************************************************************************"
PRINT
PRINT " You have three options:"
PRINT
PRINT "1: Mode DEMO/ Checking:"
PRINT "   A single run on a single language."
PRINT "   Detailed information is displayed for each step of processing."
PRINT
PRINT "2: N runs on a single language."
PRINT
PRINT "3: A single run on N languages."
PRINT
PRINT "   When options 2 or 3 are selected, only the final states of the "
PRINT "   percept shaper is displayed and saved."
PRINT
PRINT "************************************************************************"
PRINT " Enter your choice (default = "; pastopt; "): ";
INPUT opt
IF opt = 0 THEN opt = pastopt
pastopt = opt

IF opt = 1 OR opt = 2 THEN
  PRINT
  PRINT "Enter the path and the name of the file containing the language"
  PRINT "(default = "; pastname1$; ") ";
  INPUT name$
  IF name$ = "" THEN name$ = pastname1$
  pastname1$ = name$
 nom$ = name$
  nsujet = 1
  stp = 1
  IF opt = 2 THEN
     PRINT
     INPUT "Number of runs (default = 1 ): "; nsujet
     IF nsujet = 0 THEN nsujet = 1
     PRINT
  PRINT "Do you want to stop scrolling after each run/language ?"
  PRINT "NO= 0, YES= 1(default = "; paststp; "): ";
  INPUT stp
  IF stp = 0 THEN stp = paststp
  paststp = stp

  END IF
END IF
IF opt = 3 THEN
  PRINT
  PRINT "Enter the path and the root of the names of the files containing the"
  PRINT "languages. The root will be automatically incremented from 1 to N"
  PRINT "(default = "; pastname1$; ") ";
  INPUT name$
  IF name$ = "" THEN name$ = pastname1$
  pastname1$ = name$
 nomsource$ = name$
  PRINT
  INPUT "Number of languages: "; nsujet
  IF nsujet = 0 THEN nsujet = 1
  PRINT
  PRINT "Do you want to stop scrolling after each language ?"
  PRINT "NO= 0, YES= 1(default = "; paststp; "): ";
  INPUT stp
  IF stp = 0 THEN stp = paststp
  paststp = stp

END IF

ELSE

  PRINT
  PRINT "Number of different words (default = "; pastmots; ") ";
  INPUT mots
  IF mots = 0 THEN mots = pastmots
  pastmots = mots
  PRINT "Enter the words as bu/pa/da,  or a/b, or 1/2/3,  or par/ti/ci/pant"
  FOR i = 1 TO mots
    PRINT "Word #"; i; " "; ";"
    INPUT mot$(i)
    mot$(i) = mot$(i) + "/"
  NEXT i
  FOR i = 1 TO mots
   IF mot$(i) = "/" THEN
     mot$(i) = ""
     FOR j = 1 TO 3
      nusy = nusy + 1
      nusy$ = STR$(nusy)
      nusy$ = RIGHT$(nusy$, LEN(nusy$) - 1)
      nusy$ = "S" + nusy$
      mot$(i) = mot$(i) + nusy$ + "/"
    NEXT j
   END IF
  NEXT i

    INPUT "Number of repetitions of each word (default= 100)"; los
    IF los = 0 THEN los = 100

  nmot = los * mots
  PRINT " (the length of the sequences will be: "; nmot; " words)"

  INPUT "Number of runs (default= 1)"; nsujet
  IF nsujet = 0 THEN nsujet = 1
  
END IF

PRINT
PRINT "Enter the path and the name of the file for saving the results"
PRINT "(default= "; pastname2$; ") ";
  INPUT name$
  IF name$ = "" THEN name$ = pastname2$
  pastname2$ = name$
  PRINT
  PRINT "rate of decay (default= "; pastsw$; ") ";
  INPUT sw$
  IF sw$ = "" THEN sw$ = pastsw$
  pastsw$ = sw$
  sw = VAL(sw$)
  PRINT
  PRINT "rate of interference (default= "; pastinterf$; ") ";
  INPUT interf$
  IF interf$ = "" THEN interf$ = pastinterf$
  pastinterf$ = interf$
  interf = VAL(interf$)

IF running = 1 THEN
 PRINT
 PRINT "Enter the seed for randomization (default= timer)"
 PRINT "  Note: 'timer' ensures a different randomization in any case."
 PRINT "  Entering the same seed (any integer number) allows to have"
 PRINT "  the same random number sequence WHEN STARTING AGAIN the program"

 PRINT
 INPUT "  Seed (default= timer) "; G$
 IF G$ = "" THEN
  RANDOMIZE TIMER
 ELSE
  G = VAL(G$)
  RANDOMIZE G
 END IF
END IF


nsyl = 10'nb max de syllabes par unite
w1 = 1 'initial weight (creation)
w2 = .5 'additional weight when percept is shaped
w3 = 1 'additional weight when repetition by random
'sw = .05      ' suppressed weight
'interf = .005  'Interference
mvsp = 1   'minimal value for shaping percept
affich = 0


' dp = pt de depart, incrementer
' syl = numero des syllabes, de 1 a 4


IF opt = 1 OR opt = 2 THEN

 OPEN nom$ FOR INPUT AS #1
   INPUT #1, corpus2$
 CLOSE #1

 DO WHILE ASC(corpus2$) > 240 OR ASC(corpus2$) < 40
  corpus2$ = RIGHT$(corpus2$, LEN(corpus2$) - 1)
 LOOP
 DO WHILE RIGHT$(corpus2$, 2) <> "//"
      corpus2$ = corpus2$ + "/"
 LOOP
 IF opt = 1 THEN
  PRINT
  PRINT "Your corpus:"
  PRINT corpus2$
  PRINT
  INPUT "           Press ENTER to continue "; a$
 END IF
END IF
                             
         FOR sujet = 1 TO nsujet'********************************

             pas = 0
             lgps = 0
             fait = 0: fait2 = 0
             locspe = 0 'location is speech when MODE=1
             nbm = 0
             nbsyl = 0'nb de syllabes percue
             nbsylsuj = 0'qd lgps=6
             corpus$ = ""
             FOR i = 1 TO 100
                 ps$(i) = "": ps2$(i) = ""
                 FOR j = 1 TO 2
                         ps(i, j) = 0: ps2(i, j) = 0
                 NEXT j
             NEXT i
             iter = 0

      
IF opt = 3 THEN
 corpus2$ = ""
 nom3$ = RIGHT$(nomsource$, 4)
 nom4$ = LEFT$(nomsource$, LEN(nomsource$) - 4)
 nom5$ = nom4$ + RIGHT$(STR$(sujet), LEN(STR$(sujet)) - 1)
 nom2$ = nom5$ + nom3$

 'PRINT nom2$
 'INPUT a$
 OPEN nom2$ FOR INPUT AS #1
   INPUT #1, corpus2$
 CLOSE #1

 DO WHILE ASC(corpus2$) > 240 OR ASC(corpus2$) < 40
  corpus2$ = RIGHT$(corpus2$, LEN(corpus2$) - 1)
 LOOP
 DO WHILE RIGHT$(corpus2$, 2) <> "//"
      corpus2$ = corpus2$ + "/"
 LOOP

 PRINT
 PRINT "Your corpus:"
 PRINT corpus2$
 PRINT
 IF stp = 1 THEN INPUT "Press ENTER to continue "; a$
END IF


C = 0
DO WHILE locspe < LEN(corpus2$) - 1 AND f2ph = 0

DO
 IF mode = 2 THEN

  DO WHILE LEN(corpus$) < 61 AND nbm < nmot
       nbm = nbm + 1
       'IF nbm / 100 = INT(nbm / 100) THEN PRINT nbm
       DO
          has = INT(RND * mots) + 1
       LOOP UNTIL has <> anchas
       anchas = has

       corpus$ = corpus$ + mot$(has)

  LOOP
  IF nbm = nmot AND RIGHT$(corpus$, 2) <> "//" THEN
      corpus$ = corpus$ + "/"
  END IF

 ELSE

  DO WHILE LEN(corpus$) < 61 AND f2ph = 0
       x$ = ""
       DO
         locspe = locspe + 1
         ltt$ = MID$(corpus2$, locspe, 1)
         x$ = x$ + ltt$
       LOOP UNTIL ltt$ = "/"
       corpus$ = corpus$ + x$
       IF MID$(corpus2$, locspe + 1, 1) = "/" THEN
          f2ph = 1
          corpus$ = corpus$ + "/"
          locspe = locspe + 1
       END IF
 
  LOOP

      
 END IF

  dp = 0

  longli = LEN(corpus$)
   
      IF opt = 1 THEN
        PRINT
        PRINT "Corpus to be processed: "; corpus$
      END IF
               CALL spparser

  corpus$ = RIGHT$(corpus$, longli - dp)


LOOP UNTIL longli - dp < 2
IF f2ph = 1 AND corpus$ = "/" THEN
   f2ph = 0
   corpus$ = ""
END IF
LOOP

    'resultat

  PRINT
  PRINT "Run "; sujet; " "
  FOR i = 1 TO lgps
    IF ps(i, 1) >= 0 THEN
     PRINT ps$(i), ps(i, 1)
    END IF
  NEXT i
  PRINT
  IF opt = 1 OR stp = 1 THEN
    INPUT "           Press ENTER to continue "; a$
  END IF
 nom$ = name$
 OPEN nom$ FOR APPEND AS #1
   PRINT #1, "Run ", sujet
   FOR i = 1 TO lgps
     IF ps(i, 1) >= 0 THEN
       PRINT #1, ps$(i), ps(i, 1)
     END IF
   NEXT i
   PRINT #1,
 CLOSE #1

 '***********************************   ajout Frank
 mot$(1) = "ab"
 mot$(2) = "efg"
 mot$(3) = "klmn"
 mot$(4) = "hij"
 mot$(5) = "cd"
 mot$(6) = "opqr"
 mot$(7) = "st"
 mot$(8) = "uvw"
 mot$(9) = "xyz@"

 nmot$(1) = "be"
 nmot$(2) = "gkl"
 nmot$(3) = "mnab"
 nmot$(4) = "ije"
 nmot$(5) = "dh"
 nmot$(6) = "pqrk"
 nmot$(7) = "tu"
 nmot$(8) = "vwx"
 nmot$(9) = "yz@s"

 FOR i = 1 TO lgps
          IF ps(i, 1) >= 1 THEN
          FOR j = 1 TO 6
          'PRINT ps$(i), mot$(j)
            IF ps$(i) = mot$(j) THEN mot(j) = mot(j) + 1
            IF ps$(i) = nmot$(j) THEN nmot(j) = nmot(j) + 1
           NEXT j
           END IF
 NEXT i
 FOR i = 1 TO 6
 PRINT i, mot(i), nmot(i)
 NEXT i
'************************************
IF nsujet > 1 THEN

 DO
 name$ = LEFT$(name$, LEN(name$) - 1)
 LOOP UNTIL RIGHT$(name$, 1) = "/"
 name$ = name$ + "corpus.txt"
 nom$ = name$ + "-corpus"
 OPEN nom$ FOR OUTPUT AS #1
   PRINT #1, corpus3$
 CLOSE #1

END IF


                   NEXT sujet'***************************************
PRINT

INPUT "           For a new simulation, press ENTER "; a$
GOTO start

SUB spparser

             'diminue le poids de tous les mots
 IF lgps > 0 THEN
   FOR j = 1 TO lgps
           ps(j, 1) = ps(j, 1) - sw
   NEXT j
 END IF
                                         
             'debut


 pas = pas + 1

 NbASS = INT(RND * 3) + 1
 unit$ = ""
 Npm = 0
 fph = 0
 DO
 Npm = Npm + 1
 'FOR Npm = 1 TO NbASS

          syl = 0
          FOR j = 1 TO nsyl
                poss$(j) = ""
                poss3$(j) = ""
                dp(j) = 0
          NEXT j

   nup = nup + 1'compte le nb d'unite percues
   'fph = 0
   DO       'forme poss$()
          dp = dp + 1
          buf$ = MID$(corpus$, dp, 1)
          IF buf$ <> "/" THEN
             buffer$ = buffer$ + buf$
          ELSE
             syl = syl + 1
             dp(syl) = dp
             poss$(syl) = poss$(syl - 1) + buffer$
             '----------------
             poss3$(syl) = poss3$(syl - 1) + buffer$ + "/"
             '----------------
             buffer$ = ""
             IF dp = longli - 1 THEN fph = 1
             IF MID$(corpus$, dp + 1, 1) = "/" THEN fph = 1
          
          END IF
   LOOP UNTIL syl = nsyl OR fph = 1 OR buf$ = ""

                 'teste si la suite est dans ps$, ou si fin de phrase

   IF lgps > 0 AND syl > 0 THEN
          test = 0: match = 0
          nsyll = syl + 1

          DO
             nsyll = nsyll - 1
             ct = 0
             DO
                ct = ct + 1
               
                IF ps(ct, 1) > mvsp AND poss$(nsyll) = ps$(ct) THEN
                    test = 1
                    match = ct
                END IF
             LOOP UNTIL ct = lgps
          LOOP UNTIL nsyll = 1 OR test = 1
   END IF
       'test=1, dans la ligne precedente, conduit a choisir le + long
    
   IF fph = 1 THEN
      IF nsyll < syl THEN fph = 0

   END IF

           
             'augmente le pds des unites constitutives

   IF test = 1 AND lgps > 0 THEN       'perception guidee par ps$
                ps(match, 1) = ps(match, 1) + w2
                dp = dp(nsyll)
                unit$ = unit$ + ps$(match)
                unit3$ = unit3$ + ps3$(match)

                'interference
 '       FOR i = 1 TO LEN(ps$(match)) STEP 2
 '          s$ = MID$(ps$(match), i, 2)
 '          FOR j = 1 TO lgps
 '            IF j <> match THEN
 '              FOR k = 1 TO LEN(ps$(j)) STEP 2
 '                s2$ = MID$(ps$(j), k, 2)
 '                IF s$ = s2$ THEN ps(j, 1) = ps(j, 1) - interf
 '              NEXT k
 '            END IF
 '          NEXT j
 '       NEXT i

                'interference
        nbslash = 1
        FOR i = 1 TO LEN(ps3$(match))
            IF MID$(ps3$(match), i, 1) = "/" THEN
              nbslash = nbslash + 1
            ELSE
              bufint$(nbslash) = bufint$(nbslash) + MID$(ps3$(match), i, 1)
            END IF
        NEXT i
        
        FOR i = 1 TO nbslash
           s$ = bufint$(i)
           bufint$(i) = ""
           FOR j = 1 TO lgps
             IF j <> match THEN
               FOR k = 1 TO LEN(ps3$(j))

                IF MID$(ps3$(j), k, 1) = "/" THEN
                   IF s$ = s2$ THEN ps(j, 1) = ps(j, 1) - interf
                   s2$ = ""
                ELSE
                   s2$ = s2$ + MID$(ps3$(j), k, 1)
                END IF
               NEXT k
             END IF
           NEXT j
        NEXT i


   ELSE                                'perception guidee par primitives
        deja = 0
        IF lgps > 0 THEN
           FOR j = 1 TO lgps
             IF ps$(j) = poss$(1) THEN ps(j, 1) = ps(j, 1) + w3: deja = 1
           NEXT j
        END IF
        IF deja = 0 THEN
             lgps = lgps + 1
             ps$(lgps) = poss$(1)
             '------------
             ps3$(lgps) = poss3$(1)
             '--------------
             ps(lgps, 1) = w1
             ps(lgps, 2) = nup
        END IF

        dp = dp(1)
        unit$ = unit$ + poss$(1)
        '------------
        unit3$ = unit3$ + poss3$(1)
        '------------
   END IF
 'NEXT Npm

 LOOP UNTIL Npm = NbASS OR fph = 1


 nbsyl = nbsyl + LEN(unit$) / 2

 IF Npm > 1 THEN

      IF lgps > 0 THEN               'cherche si appariement de l'U composee
             test = 0
             ct = 0
             DO
                 ct = ct + 1
                 IF unit$ = ps$(ct) THEN test = 1
             LOOP UNTIL test = 1 OR ct = lgps
      END IF

      IF test = 1 AND lgps > 0 THEN   'si appariement trouve
             ps(ct, 1) = ps(ct, 1) + w3
            
      ELSE                             'si appariement non trouve (creation)

             lgps = lgps + 1
             ps$(lgps) = unit$
        '------------
        ps3$(lgps) = unit3$
        '------------

             ps(lgps, 1) = w1
             ps(lgps, 2) = nbsyl

      END IF
 END IF
          

     'reordonner ps et ps$, elimine si ps=0

   ct = 0
   FOR j = 1 TO lgps
        max = 0
        FOR k = 1 TO lgps
           IF ps(k, 1) > max THEN
              max = ps(k, 1)
              ps2(j, 1) = ps(k, 1)
              ps2$(j) = ps$(k)
              ps2(j, 2) = ps(k, 2)
              '-----------------------
              ps4$(j) = ps3$(k)
              '-----------------------
              mx = k
           END IF
        NEXT k
        IF max = 0 THEN ps2(j, 1) = 0
        IF max > 0 THEN ps(mx, 1) = 0
   NEXT j

   nlgps = 0
   FOR j = 1 TO lgps
          IF ps2(j, 1) > 0 THEN nlgps = nlgps + 1
   NEXT j
   lgps = nlgps

   FOR j = 1 TO lgps
          ps$(j) = ps2$(j)
          '----------------------
          ps3$(j) = ps4$(j)
          '----------------------
          ps(j, 1) = ps2(j, 1)
          ps(j, 2) = ps2(j, 2)
   NEXT j
   nbmt = nbmt + 1




   corpus3$ = corpus3$ + unit$ + "/"
IF opt = 1 THEN
   PRINT "Step ", pas
   PRINT "Percept size ", NbASS
   PRINT "Current Percept: "; unit$
   PRINT
   FOR i = 1 TO lgps
     IF ps(i, 1) >= 0 THEN
       PRINT ps$(i), ps(i, 1), ps3$(i)
     END IF
   NEXT i

          INPUT "           Press ENTER to continue "; a$
END IF

IF nsujet = 1 THEN
 nom$ = name$
 OPEN nom$ FOR APPEND AS #1
   PRINT #1, "Step ", pas
   PRINT #1, "Percept size ", NbASS
   PRINT #1,
   FOR i = 1 TO lgps
     IF ps(i, 1) >= 0 THEN
       PRINT #1, ps$(i), ps(i, 1)
     END IF
   NEXT i
   PRINT #1,
 CLOSE #1
END IF


      
END SUB

