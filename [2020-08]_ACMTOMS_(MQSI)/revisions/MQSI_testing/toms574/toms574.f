
c$$$C     PROGRAM MAINDR                                                    MAIN  10
c$$$      REAL X(100),Y(100),XVAL(152),YVAL(152),M(100),XVAL1(200),         MAIN  20
c$$$     *     DELTAH,EPS                                                   MAIN  30
c$$$      INTEGER OUT,ERR                                                   MAIN  40
c$$$C                                                                       MAIN  50
c$$$C THIS PROGRAM IS A TEST DRIVER FOR THE SHAPE PRESERVING QUADRATIC      MAIN  60
c$$$C SPLINES BY D.F.MCALLISTER AND J.A.ROULIER.                            MAIN  70
c$$$C                                                                       MAIN  80
c$$$C ON INPUT--                                                            MAIN  90
c$$$C                                                                       MAIN 100
c$$$C   X CONTAINS THE ABSCISSAS OF THE POINTS OF INTERPOLATION.            MAIN 110
c$$$C                                                                       MAIN 120
c$$$C   Y CONTAINS THE ORDINATES OF THE POINTS OF INTERPOLATION.            MAIN 130
c$$$C                                                                       MAIN 140
c$$$C   N IS THE NUMBER OF DATA POINTS.                                     MAIN 150
c$$$C                                                                       MAIN 160
c$$$C   K IS THE NUMBER OF POINTS AT WHICH THE SPLINE IS TO BE EVALUATED.   MAIN 170
c$$$C                                                                       MAIN 180
c$$$C                                                                       MAIN 190
c$$$C UPON EXIT FROM SUBROUTINE 'SLOPES'--                                  MAIN 200
c$$$C                                                                       MAIN 210
c$$$C   M CONTAINS THE COMPUTED FIRST DERIVATIVES AT EACH DATA POINT.       MAIN 220
c$$$C                                                                       MAIN 230
c$$$C-----------------------------------------------------------------------MAIN 240
c$$$C                                                                       MAIN 250
c$$$C SUPPLY THE UNIT NUMBERS FOR I/O OPERATIONS.                           MAIN 260
c$$$      IN=1                                                              MAIN 270
c$$$      OUT=3                                                             MAIN 280
c$$$C                                                                       MAIN 290
c$$$      READ (IN,10)N                                                     MAIN 300
c$$$  10  FORMAT (I4)                                                       MAIN 310
c$$$      READ (IN,20) (X(I),Y(I),I=1,N)                                    MAIN 320
c$$$  20  FORMAT (2(E20.8,5X))                                              MAIN 330
c$$$C                                                                       MAIN 340
c$$$C CALCULATE THE SLOPES AT EACH DATA POINT.                              MAIN 350
c$$$      CALL SLOPES(X,Y,M,N)                                              MAIN 360
c$$$      WRITE (OUT,30)                                                    MAIN 370
c$$$  30  FORMAT('1','THESE ARE THE POINTS OF INTERPOLATION AND THE COMPUTEDMAIN 380
c$$$     * SLOPES.' //)                                                     MAIN 390
c$$$      WRITE (OUT,40) (I,X(I),Y(I),M(I),I=1,N)                           MAIN 400
c$$$  40  FORMAT('0','I=',I4,2X,'X=',E15.6,2X,'Y=',E15.6,2X,'M=',E15.6)     MAIN 410
c$$$C                                                                       MAIN 420
c$$$C SET THE ERROR TOLERANCE EPS, WHICH IS USED IN SUBROUTINE 'CHOOSE'.    MAIN 430
c$$$      EPS=1.E-04                                                        MAIN 440
c$$$C                                                                       MAIN 450
c$$$C TEST 1-- TEST FOR A SINGLE POINT WHICH IS LESS THAN THE ABSCISSA OF   MAIN 460
c$$$C          OF THE FIRST DATA POINT.                                     MAIN 470
c$$$      K=1                                                               MAIN 480
c$$$      XVAL(1)= -1.E0                                                    MAIN 490
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN 500
c$$$      WRITE (OUT,50)                                                    MAIN 510
c$$$  50  FORMAT('1','TEST 1-- ERR SHOULD EQUAL 1.' //)                     MAIN 520
c$$$      WRITE (OUT,60)XVAL(1),YVAL(1),ERR                                 MAIN 530
c$$$  60  FORMAT('0','XVAL(1)=',E15.6,3X,'YVAL(1)=',E15.6,3X,'ERR=',I4 ////)MAIN 540
c$$$C                                                                       MAIN 550
c$$$C TEST 2-- TEST FOR A SINGLE POINT WHICH IS GREATER THAN THE ABSCISSA   MAIN 560
c$$$C          OF THE LAST DATA POINT.                                      MAIN 570
c$$$      XVAL(1)=12.E0                                                     MAIN 580
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN 590
c$$$      WRITE(OUT,70)                                                     MAIN 600
c$$$  70  FORMAT('0','TEST 2-- ERR SHOULD EQUAL 1.' //)                     MAIN 610
c$$$      WRITE(OUT,80)XVAL(1),YVAL(1),ERR                                  MAIN 620
c$$$  80  FORMAT('0','XVAL(1)=',E15.6,3X,'YVAL(1)=',E15.6,3X,'ERR=',I4 ////)MAIN 630
c$$$C                                                                       MAIN 640
c$$$C TEST 3-- TEST FOR A SINGLE POINT WHICH IS IN RANGE BUT IS NOT A DATA  MAIN 650
c$$$C          POINT.                                                       MAIN 660
c$$$      XVAL(1)= 5.6E0                                                    MAIN 670
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN 680
c$$$      WRITE(OUT,90)                                                     MAIN 690
c$$$  90  FORMAT('0','TEST 3-- ERR SHOULD EQUAL 0.' //)                     MAIN 700
c$$$      WRITE(OUT,100)XVAL(1),YVAL(1),ERR                                 MAIN 710
c$$$  100 FORMAT('0','XVAL(1)=',E15.6,3X,'YVAL(1)=',E15.6,3X,'ERR=',I4 ////)MAIN 720
c$$$C                                                                       MAIN 730
c$$$C TEST 4-- TEST FOR POINTS OF EVALUATION WHICH ARE DECREASING.          MAIN 740
c$$$      K=2                                                               MAIN 750
c$$$      XVAL(1)=5.E0                                                      MAIN 760
c$$$      XVAL(2)=4.E0                                                      MAIN 770
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN 780
c$$$      WRITE (OUT,110)                                                   MAIN 790
c$$$  110 FORMAT('0','TEST 4-- ERR SHOULD EQUAL 2.' //)                     MAIN 800
c$$$      WRITE(OUT,120)ERR                                                 MAIN 810
c$$$  120 FORMAT('0','ERR=',I4 ////)                                        MAIN 820
c$$$C                                                                       MAIN 830
c$$$C TEST 5-- TEST FOR CORRECT EVALUATION OF SUCCESSIVE POINTS NOT IN      MAIN 840
c$$$C          ADJACENT INTERVALS.                                          MAIN 850
c$$$      XVAL(1)=1.2E0                                                     MAIN 860
c$$$      XVAL(2)=9.9E0                                                     MAIN 870
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN 880
c$$$      WRITE (OUT,130)                                                   MAIN 890
c$$$  130 FORMAT('0','TEST 5-- ERR SHOULD EQUAL 0.' //)                     MAIN 900
c$$$      WRITE(OUT,140)XVAL(1),YVAL(1),XVAL(2),YVAL(2),ERR                 MAIN 910
c$$$  140 FORMAT('0','XVAL(1)=',E15.6,3X,'YVAL(1)=',E15.6,3X,'XVAL(2)=',    MAIN 920
c$$$     *       E15.6,3X,'YVAL(2)=',E15.6,3X,'ERR=',I4 ////)               MAIN 930
c$$$C                                                                       MAIN 940
c$$$C TEST 6-- EVALUATE EQUALLY SPACED POINTS IN THE ENTIRE INTERVAL        MAIN 950
c$$$C          DETERMINED BY THE DATA.                                      MAIN 960
c$$$C                                                                       MAIN 970
c$$$C COMPUTE THE POINTS OF EVALUATION.                                     MAIN 980
c$$$      K=150                                                             MAIN 990
c$$$      XVAL(1)=X(1)                                                      MAIN1000
c$$$      DELTAH=(X(N)-X(1))/FLOAT(K-1)                                     MAIN1010
c$$$      DO 150 I=2,K                                                      MAIN1020
c$$$          XVAL(I)= X(1) + FLOAT(I-1)*DELTAH                             MAIN1030
c$$$  150 CONTINUE                                                          MAIN1040
c$$$C                                                                       MAIN1050
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN1060
c$$$      WRITE (OUT,160)                                                   MAIN1070
c$$$  160 FORMAT('1','TEST 6-- ERR SHOULD EQUAL 0.' //)                     MAIN1080
c$$$      WRITE(OUT,170)ERR                                                 MAIN1090
c$$$  170 FORMAT('0','ERR=',I4 ////)                                        MAIN1100
c$$$      WRITE(OUT,180) (I,XVAL(I),YVAL(I),I=1,K)                          MAIN1110
c$$$  180 FORMAT('0','I=',I4,3X,'XVAL=',E15.6,3X,'YVAL=',E15.6)             MAIN1120
c$$$C                                                                       MAIN1130
c$$$C TEST 7--EVALUATE EQUALLY SPACED POINTS IN THE INTERVAL                MAIN1140
c$$$C          X(1)-3.,X(N)+3. .  EXTRAPOLATION IS TESTED HERE.             MAIN1150
c$$$C                                                                       MAIN1160
c$$$C COMPUTE THE POINTS OF EVALUATION.                                     MAIN1170
c$$$      K=150                                                             MAIN1180
c$$$      XVAL1(1)=X(1)-3.E0                                                MAIN1190
c$$$      DELTAH=((X(N)+3.E0)-XVAL1(1))/FLOAT(K-1)                          MAIN1200
c$$$      DO 190 I=2,K                                                      MAIN1210
c$$$          XVAL1(I)= XVAL1(1) + FLOAT(I-1)*DELTAH                        MAIN1220
c$$$  190 CONTINUE                                                          MAIN1230
c$$$C                                                                       MAIN1240
c$$$      CALL MEVAL(XVAL1,YVAL,X,Y,M,N,K,EPS,ERR)                          MAIN1250
c$$$      WRITE(OUT,200)                                                    MAIN1260
c$$$  200 FORMAT('1','TEST 7-- ERR SHOULD EQUAL 1.' //)                     MAIN1270
c$$$      WRITE(OUT,210)ERR                                                 MAIN1280
c$$$  210 FORMAT('0','ERR=',I4 ////)                                        MAIN1290
c$$$      WRITE(OUT,220) (I,XVAL1(I),YVAL(I),I=1,K)                         MAIN1300
c$$$  220 FORMAT('0','I=',I4,3X,'XVAL=',E15.6,3X,'YVAL=',E15.6)             MAIN1310
c$$$C                                                                       MAIN1320
c$$$C TEST 8-- OVERIDE THE CALCULATED SLOPES AND USE THE SAME POINTS OF     MAIN1330
c$$$C          EVALUATION AS IN TEST 6.                                     MAIN1340
c$$$      READ(IN,230) (M(I),I=1,N)                                         MAIN1350
c$$$  230 FORMAT(E20.6)                                                     MAIN1360
c$$$      WRITE (OUT,240)                                                   MAIN1370
c$$$  240 FORMAT('1','THE SLOPES USED IN TEST 8 ARE GIVEN BELOW.' //)       MAIN1380
c$$$      WRITE(OUT,250) (M(I),I=1,N)                                       MAIN1390
c$$$  250 FORMAT('0','M=',E15.6)                                            MAIN1400
c$$$C                                                                       MAIN1410
c$$$      CALL MEVAL(XVAL,YVAL,X,Y,M,N,K,EPS,ERR)                           MAIN1420
c$$$      WRITE (OUT,260)                                                   MAIN1430
c$$$  260 FORMAT('1','TEST 8-- ERR SHOULD EQUAL 0.' //)                     MAIN1440
c$$$      WRITE(OUT,270)ERR                                                 MAIN1450
c$$$  270 FORMAT('0','ERR=',I4 ////)                                        MAIN1460
c$$$      WRITE(OUT,280) (I,XVAL(I),YVAL(I),I=1,K)                          MAIN1470
c$$$  280 FORMAT('0','I=',I4,3X,'XVAL=',E15.6,3X,'YVAL=',E15.6)             MAIN1480
c$$$C                                                                       MAIN1490
c$$$      STOP                                                              MAIN1500
c$$$      END                                                               MAIN1510

      SUBROUTINE SLOPES(XTAB, YTAB, MTAB, NUM)                          SLO   10
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C                                       N.C.STATE UNIVERSITY
C
C
C SLOPES CALCULATES THE DERIVATIVE AT EACH OF THE DATA POINTS.  THE
C SLOPES PROVIDED WILL INSURE THAT AN OSCULATORY QUADRATIC SPLINE WILL
C HAVE ONE ADDITIONAL KNOT BETWEEN TWO ADJACENT POINTS OF INTERPOLATION.
C CONVEXITY AND MONOTONICITY ARE PRESERVED WHEREVER THESE CONDITIONS
C ARE COMPATIBLE WITH THE DATA.
C
C ON INPUT--
C
C   XTAB CONTAINS THE ABSCISSAS OF THE DATA POINTS.
C
C   YTAB CONTAINS THE ORDINATES OF THE DATA POINTS.
C
C   NUM IS THE NUMBER OF DATA POINTS (DIMENSION OF XTAB,YTAB).
C
C
C ON OUTPUT--
C
C   MTAB CONTAINS THE VALUE OF THE FIRST DERIVATIVE AT EACH DATA POINT.
C
C AND
C
C   SLOPES DOES NOT ALTER XTAB,YTAB,NUM.
C
C-----------------------------------------------------------------------
      REAL XTAB(NUM), YTAB(NUM), MTAB(NUM), M1, M2, XBAR, XHAT, YDIF1,
     * YDIF2, YXMID, XMID, M1S, M2S

      NUM1 = NUM - 1
      IM1 = 1
      I = 2
      I1 = 3
C
C CALCULATE THE SLOPES OF THE TWO LINES JOINING THE FIRST THREE DATA
C POINTS.
      YDIF1 = YTAB(2) - YTAB(1)
      YDIF2 = YTAB(3) - YTAB(2)
      M1 = YDIF1/(XTAB(2)-XTAB(1))
      M1S = M1
      M2 = YDIF2/(XTAB(3)-XTAB(2))
      M2S = M2
C
C IF ONE OF THE PRECEDING SLOPES IS ZERO OR IF THEY HAVE OPPOSITE SIGN,
C ASSIGN THE VALUE ZERO TO THE DERIVATIVE AT THE MIDDLE POINT.
   10 IF (M1.EQ.0.E0.OR.M2.EQ.0.E0.OR.(M1*M2).LE.0.E0) GO TO 20
      IF (ABS(M1).GT.ABS(M2)) GO TO 30
      GO TO 40
   20 MTAB(I) = 0.E0
      GO TO 50
C
C CALCULATE THE SLOPE BY EXTENDING THE LINE WITH SLOPE M1.
   30 XBAR = (YDIF2/M1) + XTAB(I)
      XHAT = (XBAR+XTAB(I1))/2.E0
      MTAB(I) = YDIF2/(XHAT-XTAB(I))
      GO TO 50
C
C CALCULATE THE SLOPE BY EXTENDING THE LINE WITH SLOPE M2.
   40 XBAR = (-YDIF1/M2) + XTAB(I)
      XHAT = (XTAB(IM1)+XBAR)/2.E0
      MTAB(I) = YDIF1/(XTAB(I)-XHAT)
C
C INCREMENT COUNTERS.
   50 IM1 = I
      I = I1
      I1 = I1 + 1
      IF (I.GT.NUM1) GO TO 60
C
C CALCULATE THE SLOPES OF THE TWO LINES JOINING THREE CONSECUTIVE DATA
C POINTS.
      YDIF1 = YTAB(I) - YTAB(IM1)
      YDIF2 = YTAB(I1) - YTAB(I)
      M1 = YDIF1/(XTAB(I)-XTAB(IM1))
      M2 = YDIF2/(XTAB(I1)-XTAB(I))
      GO TO 10
C
C CALCULATE THE SLOPE AT THE LAST POINT, XTAB(NUM).
   60 IF ((M1*M2).LT.0.E0) GO TO 80
      XMID = (XTAB(NUM1)+XTAB(NUM))/2.E0
      YXMID = MTAB(NUM1)*(XMID-XTAB(NUM1)) + YTAB(NUM1)
      MTAB(NUM) = (YTAB(NUM)-YXMID)/(XTAB(NUM)-XMID)
      IF ((MTAB(NUM)*M2).LT.0.E0) GO TO 70
      GO TO 90
   70 MTAB(NUM) = 0.E0
      GO TO 90
   80 MTAB(NUM) = 2.E0*M2
C
C CALCULATE THE SLOPE AT THE FIRST POINT, XTAB(1).
   90 IF ((M1S*M2S).LT.0.E0) GO TO 110
      XMID = (XTAB(1)+XTAB(2))/2.E0
      YXMID = MTAB(2)*(XMID-XTAB(2)) + YTAB(2)
      MTAB(1) = (YXMID-YTAB(1))/(XMID-XTAB(1))
      IF ((MTAB(1)*M1S).LT.0.E0) GO TO 100
      RETURN
  100 MTAB(1) = 0.E0
      RETURN
  110 MTAB(1) = 2.E0*M1S
      RETURN
C
      END
      SUBROUTINE MEVAL(XVAL, YVAL, XTAB, YTAB, MTAB, NUM, NUME, EPS,    MEV   10
     * ERR)
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C                                       N.C. STATE UNIVERSITY
C
C
C MEVAL CONTROLS THE EVALUATION OF AN OSCULATORY QUADRATIC SPLINE.  THE
C USER MAY PROVIDE HIS OWN SLOPES AT THE POINTS OF INTERPOLATION OR USE
C THE SUBROUTINE 'SLOPES' TO CALCULATE SLOPES WHICH ARE CONSISTENT WITH
C THE SHAPE OF THE DATA.
C
C
C
C ON INPUT--
C
C   XVAL MUST BE A NONDECREASING VECTOR OF POINTS AT WHICH THE SPLINE
C   WILL BE EVALUATED.
C
C   XTAB CONTAINS THE ABSCISSAS OF THE DATA POINTS TO BE INTERPOLATED.
C   XTAB MUST BE INCREASING.
C
C   YTAB CONTAINS THE ORDINATES OF THE DATA POINTS TO BE INTERPOLATED.
C
C   MTAB CONTAINS THE SLOPE OF THE SPLINE AT EACH POINT OF INTERPOLA-
C   TION.
C
C   NUM IS THE NUMBER OF DATA POINTS (DIMENSION OF XTAB AND YTAB).
C
C   NUME IS THE NUMBER OF POINTS OF EVALUATION (DIMENSION OF XVAL AND
C   YVAL).
C
C   EPS IS A RELATIVE ERROR TOLERANCE USED IN SUBROUTINE 'CHOOSE'
C   TO DISTINGUISH THE SITUATION MTAB(I) OR MTAB(I+1) IS RELATIVELY
C   CLOSE TO THE SLOPE OR TWICE THE SLOPE OF THE LINEAR SEGMENT
C   BETWEEN XTAB(I) AND XTAB(I+1).  IF THIS SITUATION OCCURS,
C   ROUNDOFF MAY CAUSE A CHANGE IN CONVEXITY OR MONOTONICITY OF THE
C   RESULTING SPLINE AND A CHANGE IN THE CASE NUMBER PROVIDED BY
C   CHOOSE.  IF EPS IS NOT EQUAL TO ZERO, THEN EPS SHOULD BE GREATER
C   THAN OR EQUAL TO MACHINE EPSILON.
C
C
C ON OUTPUT--
C
C YVAL CONTAINS THE IMAGES OF THE POINTS IN XVAL.
C
C   ERR IS AN ERROR CODE--
C      ERR=0 - MEVAL RAN NORMALLY.
C      ERR=1 - XVAL(I) IS LESS THAN XTAB(1) FOR AT LEAST ONE I OR
C              XVAL(I) IS GREATER THAN XTAB(NUM) FOR AT LEAST ONE I.
C              MEVAL WILL EXTRAPOLATE TO PROVIDE FUNCTION VALUES FOR
C              THESE ABSCISSAS.
C      ERR=2 - XVAL(I+1) .LT. XVAL(I) FOR SOME I.
C
C AND
C
C   MEVAL DOES NOT ALTER XVAL,XTAB,YTAB,MTAB,NUM,NUME.
C
C
C   MEVAL CALLS THE FOLLOWING SUBROUTINES OR FUNCTIONS:
C      SEARCH
C      CASES
C      CHOOSE
C      SPLINE
C
C-----------------------------------------------------------------------
      REAL XVAL(NUME), YVAL(NUME), XTAB(NUM), YTAB(NUM), MTAB(NUM), V1,
     * V2, W1, W2, Z1, Z2, Y1, Y2, E1, E2, SPLINE, EPS
      INTEGER START, START1, END, END1, ERR, FND

      START = 1
      END = NUME
      ERR = 0
      IF (NUME.EQ.1) GO TO 20
C
C DETERMINE IF XVAL IS NONDECREASING.
      NUME1 = NUME - 1
      DO 10 I=1,NUME1
        IF (XVAL(I+1).GE.XVAL(I)) GO TO 10
        ERR = 2
        GO TO 230
   10 CONTINUE
C
C
C IF XVAL(I) .LT. XTAB(1), THEN XVAL(I)=YTAB(1).
C IF XVAL(I) .GT. XTAB(NUM), THEN XVAL(I)=YTAB(NUM).
C
C DETERMINE IF ANY OF THE POINTS IN XVAL ARE LESS THAN THE ABSCISSA OF
C THE FIRST DATA POINT.
   20 DO 30 I=1,NUME
        IF (XVAL(I).GE.XTAB(1)) GO TO 40
        START = I + 1
   30 CONTINUE
C
C
   40 NUME1 = NUME + 1
C
C DETERMINE IF ANY OF THE POINTS IN XVAL ARE GREATER THAN THE ABSCISSA
C OF THE LAST DATA POINT.
      DO 50 I=1,NUME
        IND = NUME1 - I
        IF (XVAL(IND).LE.XTAB(NUM)) GO TO 60
        END = IND - 1
   50 CONTINUE
C
C
C CALCULATE THE IMAGES OF POINTS OF EVALUATION WHOSE ABSCISSAS
C ARE LESS THAN THE ABSCISSA OF THE FIRST DATA POINT.
   60 IF (START.EQ.1) GO TO 80
C SET THE ERROR PARAMETER TO INDICATE THAT EXTRAPOLATION HAS OCCURRED.
      ERR = 1
      CALL CHOOSE(XTAB(1), YTAB(1), MTAB(1), MTAB(2), XTAB(2), YTAB(2),
     * EPS, NCASE)
      CALL CASES(XTAB(1), YTAB(1), MTAB(1), MTAB(2), XTAB(2), YTAB(2),
     * E1, E2, V1, V2, W1, W2, Z1, Z2, Y1, Y2, NCASE)
      START1 = START - 1
      DO 70 I=1,START1
        YVAL(I) = SPLINE(XVAL(I),Z1,Z2,XTAB(1),YTAB(1),XTAB(2),YTAB(2),
     *   Y1,Y2,E2,W2,V2,NCASE)
   70 CONTINUE
      IF (NUME.EQ.1) GO TO 230
C
C
C SEARCH LOCATES THE INTERVAL IN WHICH THE FIRST IN-RANGE POINT OF
C EVALUATION LIES.
   80 IF ((NUME.EQ.1) .AND. (END.NE.NUME)) GO TO 200
      CALL SEARCH(XTAB, NUM, XVAL(START), LCN, FND)
C
      LCN1 = LCN + 1
C
C
C IF THE FIRST IN-RANGE POINT OF EVALUATION IS EQUAL TO ONE OF THE DATA
C POINTS, ASSIGN THE APPROPRIATE VALUE FROM YTAB.  CONTINUE UNTIL A
C POINT OF EVALUATION IS FOUND WHICH IS NOT EQUAL TO A DATA POINT.
      IF (FND.EQ.0) GO TO 130
   90 YVAL(START) = YTAB(LCN)
      START1 = START
      START = START + 1
      IF (START.GT.NUME) GO TO 230
      IF (XVAL(START1).EQ.XVAL(START)) GO TO 90
C
  100 IF (XVAL(START)-XTAB(LCN1)) 130, 110, 120
C
  110 YVAL(START) = YTAB(LCN1)
      START1 = START
      START = START + 1
      IF (START.GT.NUME) GO TO 230
      IF (XVAL(START).NE.XVAL(START1)) GO TO 120
      GO TO 110
C
  120 LCN = LCN1
      LCN1 = LCN1 + 1
      GO TO 100
C
C
C
C CALCULATE THE IMAGES OF ALL THE POINTS WHICH LIE WITHIN RANGE OF THE
C DATA.
C
  130 IF ((LCN.EQ.1) .AND. (ERR.EQ.1)) GO TO 140
      CALL CHOOSE(XTAB(LCN), YTAB(LCN), MTAB(LCN), MTAB(LCN1),
     * XTAB(LCN1), YTAB(LCN1), EPS, NCASE)
      CALL CASES(XTAB(LCN), YTAB(LCN), MTAB(LCN), MTAB(LCN1),
     * XTAB(LCN1), YTAB(LCN1), E1, E2, V1, V2, W1, W2, Z1, Z2, Y1, Y2,
     * NCASE)
C
  140 DO 190 I=START,END
C
C IF XVAL(I) -XTAB(LCN1) IS NEGATIVE, DO NOT RECALCULATE THE PARAMETERS
C FOR THIS SECTION OF THE SPLINE SINCE THEY ARE ALREADY KNOWN.
        IF (XVAL(I)-XTAB(LCN1)) 150, 160, 170
C
  150   YVAL(I) = SPLINE(XVAL(I),Z1,Z2,XTAB(LCN),YTAB(LCN),XTAB(LCN1),
     *   YTAB(LCN1),Y1,Y2,E2,W2,V2,NCASE)
        GO TO 190
C
C  IF XVAL(I) IS A DATA POINT, ITS IMAGE IS KNOWN.
  160   YVAL(I) = YTAB(LCN1)
        GO TO 190
C
C INCREMENT THE POINTERS WHICH GIVE THE LOCATION IN THE DATA VECTOR.
  170   LCN = LCN1
        LCN1 = LCN + 1
C
C DETERMINE THAT THE ROUTINE IS IN THE CORRECT PART OF THE SPLINE.
        IF (XVAL(I)-XTAB(LCN1)) 180, 160, 170
C
C CALL CHOOSE TO DETERMINE THE APPROPRIATE CASE AND THEN CALL
C CASES TO COMPUTE THE PARAMETERS OF THE SPLINE.
  180   CALL CHOOSE(XTAB(LCN), YTAB(LCN), MTAB(LCN), MTAB(LCN1),
     *   XTAB(LCN1), YTAB(LCN1), EPS, NCASE)
        CALL CASES(XTAB(LCN), YTAB(LCN), MTAB(LCN), MTAB(LCN1),
     *   XTAB(LCN1), YTAB(LCN1), E1, E2, V1, V2, W1, W2, Z1, Z2, Y1,
     *   Y2, NCASE)
        GO TO 150
  190 CONTINUE
C
C
C CALCULATE THE IMAGES OF THE POINTS OF EVALUATION WHOSE ABSCISSAS
C ARE GREATER THAN THE ABSCISSA OF THE LAST DATA POINT.
      IF (END.EQ.NUME) GO TO 230
      IF ((LCN1.EQ.NUM) .AND. (XVAL(END).NE.XTAB(NUM))) GO TO 210
C SET THE ERROR PRARMETER TO INDICATE THAT EXTRAPOLATION HAS OCCURRED.
  200 ERR = 1
      NUM1 = NUM - 1
      CALL CHOOSE(XTAB(NUM1), YTAB(NUM1), MTAB(NUM1), XTAB(NUM),
     * XTAB(NUM), YTAB(NUM), EPS, NCASE)
      CALL CASES(XTAB(NUM1), YTAB(NUM1), MTAB(NUM1), MTAB(NUM),
     * XTAB(NUM), YTAB(NUM), E1, E2, V1, V2, W1, W2, Z1, Z2, Y1, Y2,
     * NCASE)
  210 END1 = END + 1
      DO 220 I=END1,NUME
        YVAL(I) = SPLINE(XVAL(I),Z1,Z2,XTAB(NUM1),YTAB(NUM1),XTAB(NUM),
     *   YTAB(NUM),Y1,Y2,E2,W2,V2,NCASE)
  220 CONTINUE
C
C
  230 RETURN
      END
      SUBROUTINE SEARCH(XTAB, NUM, S, LCN, FND)                         SEA   10
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C                                       N.C. STATE UNIVERSITY
C
C
C SEARCH CONDUCTS A BINARY SEARCH FOR S.  SEARCH IS CALLED ONLY IF S IS
C BETWEEN XTAB(1) AND XTAB(NUM).
C
C ON INPUT--
C
C   XTAB CONTAINS THE ABSCISSAS OF THE DATA POINTS OF INTERPOLATION.
C
C   NUM IS THE DIMENSION OF XTAB.
C
C   S IS THE VALUE WHOSE RELATIVE POSITION IN XTAB IS LOCATED BY SEARCH.
C
C
C ON OUTPUT--
C
C   FND IS SET EQUAL TO 1 IF S IS FOUND IN XTAB AND IS SET EQUAL TO 0
C   OTHERWISE.
C
C   LCN IS THE INDEX OF THE LARGEST VALUE IN XTAB FOR WHICH XTAB(I)
C   .LT. S.
C
C AND
C
C   SEARCH DOES NOT ALTER XTAB,NUM,S.
C
C-----------------------------------------------------------------------
      REAL XTAB(NUM), S
      INTEGER FND, FIRST

      FIRST = 1
      LAST = NUM
      FND = 0
C
      IF (XTAB(1).NE.S) GO TO 10
      LCN = 1
      FND = 1
      RETURN
C
   10 IF (XTAB(NUM).NE.S) GO TO 20
      LCN = NUM
      FND = 1
      RETURN
C
C IF (LAST-FIRST) .EQ. 1, S IS NOT IN XTAB.  SET POSITION EQUAL TO
C FIRST.
   20 IF ((LAST-FIRST).EQ.1) GO TO 30
C
      MIDDLE = (FIRST+LAST)/2
C
C CHECK IF S .EQ. XTAB(MIDDLE).  IF NOT, CONTINUE THE SEARCH IN THE
C APPROPRIATE HALF OF THE VECTOR XTAB.
      IF (XTAB(MIDDLE)-S) 40, 50, 60
C
   30 LCN = FIRST
      RETURN
   40 FIRST = MIDDLE
      GO TO 20
   50 LCN = MIDDLE
      FND = 1
      RETURN
   60 LAST = MIDDLE
      GO TO 20
      END
      SUBROUTINE CHOOSE(P1, P2, M1, M2, Q1, Q2, EPS, NCASE)             CHO   10
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C
C
C CHOOSE DETERMINES THE CASE NEEDED FOR THE COMPUTATION OF THE PARAME-
C TERS OF THE QUADRATIC SPLINE AND RETURNS THE VALUE IN THE VARIABLE
C NCASE.
C
C ON INPUT--
C
C   (P1,P2) GIVES THE COORDINATES OF ONE OF THE POINTS OF INTERPOLATION.
C
C   M1 SPECIFIES THE DERIVATIVE CONDITION AT (P1,P2).
C
C   (Q1,Q2) GIVES THE COORDINATES OF ONE OF THE POINTS OF INTERPOLATION.
C
C   M2 SPECIFIES THE DERIVATIVE CONDITION AT (Q1,Q2).
C
C   EPS IS AN ERROR TOLERANCE USED TO DISTINGUISH CASES WHEN M1 OR M2 IS
C   RELATIVELY CLOSE TO THE SLOPE OR TWICE THE SLOPE OF THE LINE
C   SEGMENT JOINING (P1,P2) AND (Q1,Q2).  IF EPS IS NOT EQUAL TO ZERO,
C   THEN EPS SHOULD BE GREATER THAN OR EQUAL TO MACHINE EPSILON.
C
C
C ON OUTPUT--
C
C   NCASE CONTAINS THE VALUE WHICH CONTROLS HOW THE PARAMETERS OF THE
C   QUADRATIC SPLINE ARE EVALUATED.
C
C AND
C
C   CHOOSE DOES NOT ALTER P1,P2,Q1,Q2,M1,M2,EPS.
C
C-----------------------------------------------------------------------
      REAL P1, P2, M1, M2, Q1, Q2, MREF, MREF1, MREF2, SPQ, PROD,
     * PROD1, PROD2, EPS
C
C CALCULATE THE SLOPE SPQ OF THE LINE JOINING (P1,P2),(Q1,Q2).
      SPQ = (Q2-P2)/(Q1-P1)
C
C CHECK WHETHER OR NOT SPQ IS 0.
      IF (SPQ.NE.0.E0) GO TO 20
      IF ((M1*M2).GE.0.E0) GO TO 10
      NCASE = 1
      RETURN
   10 NCASE = 2
      RETURN
C
   20 PROD1 = SPQ*M1
      PROD2 = SPQ*M2
C
C FIND THE ABSOLUTE VALUES OF THE SLOPES SPQ,M1,AND M2.
      MREF = ABS(SPQ)
      MREF1 = ABS(M1)
      MREF2 = ABS(M2)
C
C IF THE RELATIVE DEVIATION OF M1 OR M2 FROM SPQ IS LESS THAN EPS, THEN
C CHOOSE CASE 2 OR CASE 3.
      IF ((ABS(SPQ-M1).LE.EPS*MREF) .OR. (ABS(SPQ-M2).LE.EPS*MREF)) GO
     * TO 30
C
C COMPARE THE SIGNS OF THE SLOPES SPQ,M1, AND M2.
      IF ((PROD1.LT.0.E0).OR.(PROD2.LT.0.E0)) GO TO 80
      PROD = (MREF-MREF1)*(MREF-MREF2)
      IF (PROD.GE.0.E0) GO TO 40
C
C L1, THE LINE THROUGH (P1,P2) WITH SLOPE M1, AND L2, THE LINE THROUGH
C (Q1,Q2) WITH SLOPE M2, INTERSECT AT A POINT WHOSE ABSCISSA IS BETWEEN
C P1 AND Q1.  THE ABSCISSA BECOMES A KNOT OF THE SPLINE.
      NCASE = 1
      RETURN
C
   30 IF ((PROD1.LT.0.E0).OR.(PROD2.LT.0.E0)) GO TO 80
   40 IF (MREF1.GT.(2.E0*MREF)) GO TO 50
      IF (MREF2.GT.(2.E0*MREF)) GO TO 60
C
C BOTH L1 AND L2 CROSS THE LINE THROUGH (P1+Q1/2.,P2) AND (P1+Q1/2.,Q2),
C WHICH IS THE MIDLINE OF THE RECTANGLE FORMED BY (P1,P2),(Q1,P2),
C (Q1,Q2), AND (P1,Q2), OR BOTH M1 AND M2 HAVE SIGNS DIFFERENT THAN THE
C SIGN OF SPQ, OR ONE OF M1 AND M2 HAS OPPOSITE SIGN FROM SPQ AND L1
C AND L2 INTERSECT TO THE LEFT OF P1 OR TO THE RIGHT OF Q1.  THE POINT
C (P1+Q1)/2. IS A KNOT OF THE SPLINE.
      NCASE = 2
      RETURN
C
C CHOOSE CASE 4 IF MREF2 IS GREATER THAN (2.-EPS)*MREF; OTHERWISE,
C CHOOSE CASE 3.
   50 IF (MREF2.GT.(2.E0-EPS)*MREF) GO TO 70
      NCASE = 3
      RETURN
C
C IN CASES 3 AND 4, SIGN(M1)=SIGN(M2)=SIGN(SPQ).
C
C EITHER L1 OR L2 CROSSES THE MIDLINE, BUT NOT BOTH.
C CHOOSE CASE 4 IF MREF1 IS GREATER THAN (2.-EPS)*MREF; OTHERWISE,
C CHOOSE CASE 3.
   60 IF (MREF1.GT.(2.E0-EPS)*MREF) GO TO 70
      NCASE = 3
      RETURN
C
C IF NEITHER L1 NOR L2 CROSSES THE MIDLINE, THE SPLINE REQUIRES TWO
C KNOTS BETWEEN P1 AND Q1.
   70 NCASE = 4
      RETURN
C
C THE SIGN OF AT LEAST ONE OF THE SLOPES M1,M2 DOES NOT AGREE WITH THE
C SIGN OF THE SLOPE SPQ.
   80 IF ((PROD1.LT.0.E0).AND.(PROD2.LT.0.E0)) GO TO 130
C
      IF (PROD1.LT.0.E0) GO TO 90
      GO TO 110
C
   90 IF (MREF2.GT.((1.E0+EPS)*MREF)) GO TO 100
      NCASE = 2
      RETURN
C
  100 NCASE = 1
      RETURN
C
  110 IF (MREF1.GT.((1.E0+EPS)*MREF)) GO TO 120
      NCASE = 2
      RETURN
C
  120 NCASE = 1
      RETURN
C
  130 NCASE = 2
      RETURN
C
      END
      SUBROUTINE CASES(P1, P2, M1, M2, Q1, Q2, E1, E2, V1, V2, W1, W2,  CAS   10
     * Z1, Z2, Y1, Y2, NCASE)
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C                                       N.C. STATE UNIVERSITY
C
C
C CASES COMPUTES THE KNOTS AND OTHER PARAMETERS OF THE SPLINE ON THE
C INTERVAL (P1,Q1).
C
C
C ON INPUT--
C
C   (P1,P2) AND (Q1,Q2) ARE THE COORDINATES OF THE POINTS OF
C   INTERPOLATION.
C
C   M1 IS THE SLOPE AT (P1,P2).
C
C   M2 IS THE SLOPE AT (Q1,Q2)
C
C   NCASE CONTROLS THE NUMBER AND LOCATION OF THE KNOTS.
C
C
C ON OUTPUT--
C
C   (V1,V2),(W1,W2),(Z1,Z2), AND (E1,E2) ARE THE COORDINATES OF THE
C   KNOTS AND OTHER PARAMETERS OF THE SPLINE ON (P1,Q1).  (E1,E2)
C   AND (Y1,Y2) ARE USED ONLY IF NCASE=4.
C
C AND
C
C   CASES DOES NOT ALTER P1,P2,M1,M2,Q1,Q2.
C
C-----------------------------------------------------------------------
      REAL P1, P2, M1, M2, Q1, Q2, V1, V2, Z1, Z2, W1, W2, E1, E2,
     * MBAR1, MBAR2, MBAR3, C1, D1, H1, J1, Y1, Y2, K1, ZTWO

      IF ((NCASE.EQ.3) .OR. (NCASE.EQ.4)) GO TO 20
      IF (NCASE.EQ.2) GO TO 10
C
C CALCULATE THE PARAMETERS FOR CASE 1.
      Z1 = (P2-Q2+M2*Q1-M1*P1)/(M2-M1)
      ZTWO = P2 + M1*(Z1-P1)
      V1 = (P1+Z1)/2.E0
      V2 = (P2+ZTWO)/2.E0
      W1 = (Z1+Q1)/2.E0
      W2 = (ZTWO+Q2)/2.E0
      Z2 = V2 + ((W2-V2)/(W1-V1))*(Z1-V1)
      RETURN
C
C CALCULATE THE PARAMETERS FOR CASE 2.
   10 Z1 = (P1+Q1)/2.E0
      V1 = (P1+Z1)/2.E0
      V2 = P2 + M1*(V1-P1)
      W1 = (Z1+Q1)/2.E0
      W2 = Q2 + M2*(W1-Q1)
      Z2 = (V2+W2)/2.E0
      RETURN
C
C CALCULATE THE PARAMETERS USED IN BOTH CASES 3 AND 4.
   20 C1 = P1 + (Q2-P2)/M1
      D1 = Q1 + (P2-Q2)/M2
      H1 = 2.E0*C1 - P1
      J1 = 2.E0*D1 - Q1
      MBAR1 = (Q2-P2)/(H1-P1)
      MBAR2 = (P2-Q2)/(J1-Q1)
C
      IF (NCASE.EQ.4) GO TO 50
C
C CALCULATE THE PARAMETERS FOR CASE 3.
      K1 = (P2-Q2+Q1*MBAR2-P1*MBAR1)/(MBAR2-MBAR1)
      IF (ABS(M1).GT.ABS(M2)) GO TO 30
      Z1 = (K1+Q1)/2.E0
      GO TO 40
   30 Z1 = (K1+P1)/2.E0
   40 V1 = (P1+Z1)/2.E0
      V2 = P2 + M1*(V1-P1)
      W1 = (Q1+Z1)/2.E0
      W2 = Q2 + M2*(W1-Q1)
      Z2 = V2 + ((W2-V2)/(W1-V1))*(Z1-V1)
      RETURN
C
C CALCULATE THE PARAMETERS FOR CASE 4.
   50 Y1 = (P1+C1)/2.E0
      V1 = (P1+Y1)/2.E0
      V2 = M1*(V1-P1) + P2
      Z1 = (D1+Q1)/2.E0
      W1 = (Q1+Z1)/2.E0
      W2 = M2*(W1-Q1) + Q2
      MBAR3 = (W2-V2)/(W1-V1)
      Y2 = MBAR3*(Y1-V1) + V2
      Z2 = MBAR3*(Z1-V1) + V2
      E1 = (Y1+Z1)/2.E0
      E2 = MBAR3*(E1-V1) + V2
      RETURN
C
      END
      FUNCTION SPLINE(XVALS, Z1, Z2, XTABS, YTABS, XTABS1, YTABS1, Y1,  SPL   10
     * Y2, E2, W2, V2, NCASE)
C
C                                 SHAPE PRESERVING QUADRATIC SPLINES
C                                   BY D.F.MCALLISTER & J.A.ROULIER
C                                     CODED BY S.L.DODD & M.ROULIER
C                                       N.C. STATE UNIVERSITY
C
C
C   SPLINE FINDS THE IMAGE OF A POINT IN XVAL.
C
C ON INPUT--
C
C   XVALS CONTAINS THE VALUE AT WHICH THE SPLINE IS EVALUATED.
C
C   (XTABS,YTABS) ARE THE COORDINATES OF THE LEFT-HAND DATA POINT
C   USED IN THE EVALUATION OF XVALS.
C
C   (XTABS1,YTABS1) ARE THE COORDINATES OF THE RIGHT-HAND DATA POINT
C   USED IN THE EVALUATION OF XVALS.
C
C   Z1,Z2,Y1,Y2,E2,W2,V2 ARE THE PARAMETERS OF THE SPLINE.
C
C   NCASE CONTROLS THE EVALUATION OF THE SPLINE BY INDICATING WHETHER
C   ONE OR TWO KNOTS WERE PLACED IN THE INTERVAL (XTABS,XTABS1).
C
C
C ON OUTPUT--
C
C   SPLINE IS THE IMAGE OF XVALS.
C
C AND
C
C   SPLINE DOES NOT ALTER ANY OF THE INPUT PARAMETERS.
C
C-----------------------------------------------------------------------
      REAL XVALS, Z1, Z2, XTABS, YTABS, XTABS1, YTABS1, V2, W2, Y1, Y2,
     * E2

C
C IF NCASE .EQ. 4, MORE THAN ONE KNOT WAS PLACED IN THE INTERVAL.
      IF (NCASE.EQ.4) GO TO 40
C
C CASES 1,2, OR 3.
C
C DETERMINE THE LOCATION OF XVALS RELATIVE TO THE KNOT.
      IF (Z1-XVALS) 10, 20, 30
C
   10 SPLINE = (Z2*(XTABS1-XVALS)**2+W2*2.E0*(XVALS-Z1)*(XTABS1-XVALS)
     * +YTABS1*(XVALS-Z1)**2)/(XTABS1-Z1)**2
      RETURN
C
   20 SPLINE = Z2
      RETURN
C
   30 SPLINE = (YTABS*(Z1-XVALS)**2+V2*2.E0*(XVALS-XTABS)*(Z1-XVALS)+Z2*
     * (XVALS-XTABS)**2)/(Z1-XTABS)**2
      RETURN
C
C CASE 4.
C
C DETERMINE THE LOCATION OF XVALS RELATIVE TO THE FIRST KNOT.
   40 IF (Y1-XVALS) 70, 60, 50
C
   50 SPLINE = (YTABS*(Y1-XVALS)**2+V2*2.E0*(XVALS-XTABS)*(Y1-XVALS)+Y2*
     * (XVALS-XTABS)**2)/(Y1-XTABS)**2
      RETURN
C
   60 SPLINE = Y2
      RETURN
C
C DETERMINE THE LOCATION OF XVALS RELATIVE TO THE SECOND KNOT.
   70 IF (Z1-XVALS) 100, 90, 80
C
   80 SPLINE = (Y2*(Z1-XVALS)**2+E2*2.E0*(XVALS-Y1)*(Z1-XVALS)+Z2*
     * (XVALS-Y1)**2)/(Z1-Y1)**2
      RETURN
C
   90 SPLINE = Z2
      RETURN
C
  100 SPLINE = (Z2*(XTABS1-XVALS)**2+W2*2.E0*(XVALS-Z1)*(XTABS1-XVALS)
     * +YTABS1*(XVALS-Z1)**2)/(XTABS1-Z1)**2
      RETURN
C
C
      END
c$$$  12
c$$$  0.E0                    0.E0
c$$$  1.E0                    .3E0
c$$$  2.E0                    .5E0
c$$$  3.E0                    .2E0
c$$$  4.E0                    .6E0
c$$$  5.E0                    1.2E0
c$$$  6.E0                    1.3E0
c$$$  7.E0                    1.E0
c$$$  8.E0                    1.E0
c$$$  9.E0                    1.E0
c$$$  10.E0                   0.E0
c$$$  11.E0                   -1.E0
c$$$  .5E0
c$$$  1.E0
c$$$  0.E0
c$$$  -.2E0
c$$$  5.E0
c$$$  4.E0
c$$$  0.E0
c$$$  -.2E0
c$$$  -.2E0
c$$$  .3E0
c$$$  -.9999E0
c$$$  -1.001E0
