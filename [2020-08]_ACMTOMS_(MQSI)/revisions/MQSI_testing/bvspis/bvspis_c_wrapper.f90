! This automatically generated Fortran wrapper file allows codes
! written in Fortran to be called directly from C and translates all
! C-style arguments into expected Fortran-style arguments (with
! assumed size, local type declarations, etc.).


SUBROUTINE C_DBVSIS(X_DIM_1, X, Y_DIM_1, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR_DIM_1, CONSTR, EPS, BETA, BETAI, RHO, RHOI, K&
&MAX, MAXSTP, XTAB_DIM_1, XTAB, NTAB, SBOPT, Y0OPT, Y1OPT, Y2OPT, ERRC, ERRE, D_DIM_1, D, D2_DIM_1, D2, DIAGN_DIM_1, DIAGN, Y0TAB_D&
&IM_1, Y0TAB, Y1TAB_DIM_1, Y1TAB, Y2TAB_DIM_1, Y2TAB, WORK_DIM_1, WORK, NWORK) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: X_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(X_DIM_1) :: X
  INTEGER, INTENT(IN) :: Y_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y_DIM_1) :: Y
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(INOUT) :: N
  INTEGER, INTENT(INOUT) :: K
  INTEGER, INTENT(INOUT) :: OPT
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D20
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D2NP
  INTEGER, INTENT(IN) :: CONSTR_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(CONSTR_DIM_1) :: CONSTR
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHO
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHOI
  INTEGER, INTENT(INOUT) :: KMAX
  INTEGER, INTENT(INOUT) :: MAXSTP
  INTEGER, INTENT(IN) :: XTAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(XTAB_DIM_1) :: XTAB
  INTEGER, INTENT(INOUT) :: NTAB
  INTEGER, INTENT(INOUT) :: SBOPT
  INTEGER, INTENT(INOUT) :: Y0OPT
  INTEGER, INTENT(INOUT) :: Y1OPT
  INTEGER, INTENT(INOUT) :: Y2OPT
  INTEGER, INTENT(INOUT) :: ERRC
  INTEGER, INTENT(INOUT) :: ERRE
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D
  INTEGER, INTENT(IN) :: D2_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D2_DIM_1) :: D2
  INTEGER, INTENT(IN) :: DIAGN_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(DIAGN_DIM_1) :: DIAGN
  INTEGER, INTENT(IN) :: Y0TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y0TAB_DIM_1) :: Y0TAB
  INTEGER, INTENT(IN) :: Y1TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y1TAB_DIM_1) :: Y1TAB
  INTEGER, INTENT(IN) :: Y2TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y2TAB_DIM_1) :: Y2TAB
  INTEGER, INTENT(IN) :: WORK_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(WORK_DIM_1) :: WORK
  INTEGER, INTENT(INOUT) :: NWORK

  INTERFACE
    SUBROUTINE DBVSIS(X, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR, EPS, BETA, BETAI, RHO, RHOI, KMAX, MAXSTP, XTAB, NTAB, SBOPT&
&, Y0OPT, Y1OPT, Y2OPT, ERRC, ERRE, D, D2, DIAGN, Y0TAB, Y1TAB, Y2TAB, WORK, NWORK)
      !  DBVSIS is merely a support routine which calls DBVSSC and DBVSSE
      !  for the computation of the needed parameters and for the evaluation
      !  of a shape-preserving, C(k), k=1,2 , interpolating spline,
      !  optionally subject to boundary conditions.
      !  The use of DBVSIS is not recommended when more evaluations of the
      !  same spline are required; in this case it is better to separately
      !  call DBVSSC and then DBVSSE repeatedly.
      !  For an explanation of input and output parameters, the user is
      !  referred to the comments of DBVSSC and DBVSSE.
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: X
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: Y
      INTEGER, INTENT(INOUT) :: NP
      INTEGER, INTENT(INOUT) :: N
      INTEGER, INTENT(INOUT) :: K
      INTEGER, INTENT(INOUT) :: OPT
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D20
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D2NP
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: CONSTR
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHO
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHOI
      INTEGER, INTENT(INOUT) :: KMAX
      INTEGER, INTENT(INOUT) :: MAXSTP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: XTAB
      INTEGER, INTENT(INOUT) :: NTAB
      INTEGER, INTENT(INOUT) :: SBOPT
      INTEGER, INTENT(INOUT) :: Y0OPT
      INTEGER, INTENT(INOUT) :: Y1OPT
      INTEGER, INTENT(INOUT) :: Y2OPT
      INTEGER, INTENT(INOUT) :: ERRC
      INTEGER, INTENT(INOUT) :: ERRE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D2
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: DIAGN
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y0TAB
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y1TAB
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y2TAB
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:NWORK) :: WORK
      INTEGER, INTENT(INOUT) :: NWORK
    END SUBROUTINE DBVSIS
  END INTERFACE

  CALL DBVSIS(X, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR, EPS, BETA, BETAI, RHO, RHOI, KMAX, MAXSTP, XTAB, NTAB, SBOPT, Y0OPT,&
& Y1OPT, Y2OPT, ERRC, ERRE, D, D2, DIAGN, Y0TAB, Y1TAB, Y2TAB, WORK, NWORK)
END SUBROUTINE C_DBVSIS


SUBROUTINE C_DBVSSC(X_DIM_1, X, Y_DIM_1, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR_DIM_1, CONSTR, EPS, BETA, BETAI, RHO, RHOI, K&
&MAX, MAXSTP, ERRC, D_DIM_1, D, D2_DIM_1, D2, DIAGN_DIM_1, DIAGN, WORK_DIM_1, WORK, NWORK) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: X_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(X_DIM_1) :: X
  INTEGER, INTENT(IN) :: Y_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y_DIM_1) :: Y
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(INOUT) :: N
  INTEGER, INTENT(INOUT) :: K
  INTEGER, INTENT(INOUT) :: OPT
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D20
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D2NP
  INTEGER, INTENT(IN) :: CONSTR_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(CONSTR_DIM_1) :: CONSTR
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHO
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHOI
  INTEGER, INTENT(INOUT) :: KMAX
  INTEGER, INTENT(INOUT) :: MAXSTP
  INTEGER, INTENT(INOUT) :: ERRC
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D
  INTEGER, INTENT(IN) :: D2_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D2_DIM_1) :: D2
  INTEGER, INTENT(IN) :: DIAGN_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(DIAGN_DIM_1) :: DIAGN
  INTEGER, INTENT(IN) :: WORK_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(WORK_DIM_1) :: WORK
  INTEGER, INTENT(INOUT) :: NWORK

  INTERFACE
    SUBROUTINE DBVSSC(X, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR, EPS, BETA, BETAI, RHO, RHOI, KMAX, MAXSTP, ERRC, D, D2, DIAG&
&N, WORK, NWORK)
      !  -------------------------------------------------
      !            Lines 49-549 are comment lines.
      !            The actual code begins at line 555.
      !  -------------------------------------------------
      
      !  ABSTRACT:
      !
      !  DBVSSC is designed to compute the coefficients (first and, if
      !  appropriate, second derivatives) of a shape-preserving spline, of
      !  continuity class C(k), k=1,2 , which interpolates a set of data
      !  points and, if required, satisfies additional boundary conditions.
      !  DBVSSC furnishes the input parameters for DBVSSE, which, in turn,
      !  provides to evaluate the spline and its derivatives at a set of
      !  tabulation points.
      !
      !  The user is allowed to use the following options:
      !
      !  - to compute a spline subject to:
      !        - no constraint,
      !        - monotonicity constraints,
      !        - convexity constraints,
      !        - monotonicity and convexity constraints,
      !        - one of the above constraints in each subinterval;
      !
      !  - to impose separable or non-separable boundary conditions on the
      !    spline,
      !
      !  - to assign the first derivatives d(i), i=0,1,...,np , in input or to
      !    compute them from the constraints only or as the best approximation
      !    to a set of optimal values. Although the final sequence of
      !    derivatives does in any case satisfy the imposed restrictions on
      !    the shape, the resulting graphs may exhibit different behaviors.
      !
      !
      !  REMARK:
      !
      !  In these comments variable and array names will be denoted with
      !  capital letters, and their contents with small letters. Moreover:
      !  .IN.   means belonging to;
      !  .INT.  stands for intersection.
      !
      !
      !  The code has the following structure:
      !
      !         DBVSSC
      !              DBVC
      !                   DSTINF
      !                        DMSK1
      !                        DMSK2
      !                             DPRJ0
      !                             DPRJ1
      !                        DTDC
      !                             DMNMOD
      !                             DMDIAN
      !                   DALG3
      !                        DPRJ0
      !                        DALG1
      !                             DPRJ1
      !                        DINTRS
      !                        DTST
      !                        DFPSVF
      !                             DSL
      !                             DALG1D
      !                                  DPRJ1
      !                        DAL2
      !                             DPRJ2
      !                        DAL2DP
      !                             DMNIND
      !                             DPRJ2
      !                             DSL
      !                        DSCDRC
      !
      !
      !  CALLING SEQUENCE:
      !
      !       CALL DBVSSC (X,Y,NP,N,K,OPT,D0,DNP,D20,D2NP,CONSTR,EPS,BETA,
      !    *               BETAI,RHO,RHOI,KMAX,MAXSTP,ERRC,D,D2,DIAGN,
      !    *               WORK,NWORK)
      !
      !
      !  INPUT PARAMETERS:
      !
      !  X       : floating array, of bounds 0:NP, containing the data
      !            abscissas  x(i), i=0,1,...,np.
      !            Restriction: x(i).LT.x(i+1), i=0,1,...,np.
      !  Y       : floating array, of bounds 0:NP, containing the data
      !            ordinates  y(i), i=0,1,...,np.
      !  NP      : integer variable, defining the number of interpolation
      !            points. Restriction: np.GE.2 .
      !  N       : integer variable, containing the degree of s.
      !            Restriction: n.GE.3 .
      !  K       : integer variable, containing the class of continuity of s.
      !            Restriction:  k.EQ.1  or  k.EQ.2  and  n.GE.3*k .
      !  OPT     : integer variable, containing a control parameter. It is
      !            a three-digit decimal of the form  pqr  (that is of
      !            numerical value  p*100+q*10+r ) where:
      !            r  controls the constraints on the shape.
      !            q  controls the boundary conditions and
      !            p  controls the computation of the derivatives,
      !            More specifically:
      !            r=0 (opt=pq0) : no constraint on the shape is required;
      !            r=1 (opt=pq1) : monotonicity constraints are required;
      !            r=2 (opt=pq2) : convexity constraints are required;
      !            r=3 (opt=pq3) : monotonicity and convexity constraints are
      !                            required;
      !            r=4 (opt=pq4) : local constraints for any subinterval are
      !                            supplied by the user (see the description
      !                            of the array CONSTR);
      !            q=1 (opt=p1r) : no boundary condition is imposed;
      !            q=2 (opt=p2r) : non-separable boundary conditions are
      !                            imposed (see the description of BETA,
      !                            BETAI, RHO, RHOI);
      !            q=3 (opt=p3r) : separable boundary conditions are imposed
      !                            (see the description of D0, DNP, D20,
      !                             D2NP);
      !            p=1 (opt=1qr) : the sequence of first derivatives
      !                            d(0),....,d(np)  is computed using the
      !                            constraints only using subroutine DAL2;
      !            p=2 (opt=2qr) : the sequence is computed as the constrained
      !                            best approximation to Bessel derivatives
      !                            using subroutine DAL2DP;
      !            p=3 (opt=3qr) : the sequence is computed as the constrained
      !                            best approximation to a set of third order
      !                            accurate derivative estimates produced in
      !                            subroutine DTDC using subroutine DAL2DP
      !                            (since this estimates are inherently mono-
      !                            tonicity preserving, it is not recommended
      !                            to associate this option with the convexity
      !                            constraints only);
      !            p=4 (opt=4qr) : the sequence is computed as the constrained
      !                            best approximation to a set of values given
      !                            in input by the user using DAL2DP; note
      !                            that opt.EQ.410 will provide the classical
      !                            C(k) function interpolating the data and
      !                            the derivatives.
      !         Restriction: ( p.GE.1 .AND. p.LE.4 ) .AND.
      !                      ( q.GE.1.AND. q.LE.3 ) .AND.
      !                      ( r.GE.0 .AND. r.LE.4 ) .AND.
      !                      .NOT. ( r.EQ.0 .AND. p.EQ.1 ) .
      !  D0      : floating variable containing the left separable boundary
      !            condition for the first derivative (d(0)=d0).
      !            D0 is referenced only when  q=3 .
      !  DNP     : floating variable containing the right separable boundary
      !            condition for the first derivative (d(np)=dnp).
      !            DNP is referenced only when  q=3 .
      !  D20     : floating variable containing the left separable boundary
      !            condition for the second derivative (d2(0)=d20).
      !            D20 is referenced only when  q=3  and  k=2 .
      !  D2NP    : floating variable containing the right separable boundary
      !            condition for the second derivative (d2(np)=d2np).
      !            D2NP is referenced only when  q=3  and  k=2 .
      !  EPS     : floating variable, containing a value for computing the
      !            relative tolerance of the method. It should be set greater
      !            or equal to the machine precision. However, if eps.LE.0,
      !            DBVSSC resets it to 0.0001 which has turned out to be a
      !            good choice for graphical applications.
      !  BETA    : user supplied function, which represents non-separable
      !            boundary conditions for the first derivatives.
      !            BETA is referenced only when  q=2 .
      !  BETAI   : user supplied function, which is the inverse of BETA.
      !            BETAI is referenced only when  q=2 .
      !  RHO     : user supplied function, which represents non-separable
      !            boundary conditions for the second derivatives.
      !            RHO is referenced only when  q=2  and  k=2 .
      !  RHOI    : user supplied function, which is the inverse of RHO.
      !            RHOI is referenced only when  q=2  and  k=2 .
      !  KMAX    : integer variable, containing the number of iterations
      !            allowed for selecting the minimal set ASTAR described
      !            below. If kmax.LE.0, DBVSSC resets it to 10 .
      !            KMAX is referenced only when  q=2 .
      !  MAXSTP  : integer variable, containing the number of steps allowed
      !            to find dstar in the set of admissible values.
      !            If maxstp.LE.0, DBVSSC resets it to 10 .
      !            MAXSTP is referenced only when  q=2 .
      !
      !
      !  INPUT / OUTPUT PARAMETERS:
      !
      !  CONSTR  : integer array, of bounds  0:NP , containing, in input the
      !            desired constraints on the shape for each subinterval.
      !            constr(i)=kind , kind=0,1,2,3 , means that none, monotoni-
      !            city, convexity, monotonicity and convexity constraint is
      !            imposed on the subinterval [x(i),x(i+1)]. If constr(i) is
      !            not compatible with the data it is relaxed according to
      !            their shape (see subroutine DMSK1 for details). So, on out-
      !            put, CONSTR contains the constraints actually imposed.
      !            For example, if the data are convex and on input we have
      !            constr(i)=3 , the result in output will be  constr(i)=2.
      !            Restriction: constr(i).GE.0 .AND. constr(i).LE.3 .
      !            CONSTR is referenced only when  r=4 .
      !  D       : floating array, of bounds 0:NP, containing the first
      !            derivatives at  x(i), i=0,1,...,np . If  p=4 , d(i) is the
      !            input value to be approximated by the computed derivative,
      !            which is then stored in the same location.
      !            On output, D is computed by the routine DAL2 if  p=1  and
      !            is computed by the routine DAL2DP if  p=2  or  p=3 .
      !
      !
      !  OUTPUT PARAMETERS
      !
      !  ERRC    : integer variable, containing an error flag which displays
      !            the status of the code. The status is divided into: severe
      !            error (error on the input data, no computation has been
      !            done), error (some computation has been done and some
      !            information or suggestions are available), warning (some
      !            requirement is not fulfilled, but the spline's parameters
      !            have been computed), success.
      !            errc=0 : success, normal return of the code;
      !            errc=1 : severe error, incorrect assignment for some of
      !                     the values nwork, opt, np;
      !            errc=2 : severe error, for some i the restriction
      !                     0.LE.constr(i) .AND. constr(i).LE.3  is not
      !                     fulfilled;
      !            errc=3 : severe error, incorrect assignment for some of
      !                     the values n,k;
      !            errc=4 : severe error, the restriction x(i).LT.x(i+1) is
      !                     not fulfilled for some i;
      !            errc=5 : error, the problem does not have any solution
      !                     because the set
      !                     betai ( phi(a(0,k)) .INT. beta(a(0,k)) )
      !                     is empty for some k. In other words the boundary
      !                     conditions cannot be satisfied and the output
      !                     parameters are meaningless.
      !                     The user is suggested to increase the value of n.
      !            errc=6 : warning; for some i, the constraints on the
      !                     interval  [x(i),x(i+1)]  are too strong and they
      !                     have not been considered. There is no guarantee
      !                     that the spline is shape-preserving within all
      !                     the intervals. More accurate diagnostic details
      !                     can be found in the array DIAGN.
      !                     The user is suggested to increase the value of n.
      !            errc=7 : error, dstar such that beta(dstar).IN.phi(dstar)
      !                     has not been found. The integer parameter maxstp
      !                     should be increased.
      !                     The output parameters are meaningless.
      !            errc=8 : error, both situations described in errc=6 and
      !                     errc=7  have occurred.
      !            errc=9 : warning, one of the separable boundary conditions
      !                     d(0)=d0  and/or  d(np)=dnp  are not compatible
      !                     with the constraints in  [x(0),x(1)]  and/or
      !                     [x(np-1),x(np)]  which have consequently been
      !                     relaxed. The user is suggested to increase the
      !                     value of n. More accurate diagnostic details can
      !                     be found in the array DIAGN.
      !            errc=10: warning, both situations described for errc=6 and
      !                     errc=9 have occurred.
      !            errc=11: warning, one of the separable boundary conditions
      !                     d2(0)=d20  and/or  d2(np)=d2np  are not compatible
      !                     with the constraints in  [x(0),x(1)]  and/or
      !                     [x(np-1),x(np)] . The boundary conditions have
      !                     consequently been approximated. The user is
      !                     suggested to increase the value of n.
      !            errc=12: warning, both situations described for errc=6 and
      !                     errc=11 have occurred.
      !            errc=13: warning, both situations described for errc=9 and
      !                     errc=11 have occurred.
      !            errc=14: warning, both situations described for errc=10 and
      !                     errc=11 have occurred.
      !            errc=15: warning, the non-separable boundary conditions
      !                     d2(np)=rho(d2(0))  are not compatible with the
      !                     constraints. The boundary conditions have
      !                     consequently been approximated. The user is
      !                     suggested to increase the value of n.
      !            errc=16: warning, both situations described for errc=6 and
      !                     errc=15 have occurred.
      !            errc=17: warning, both situations described for errc=9 and
      !                     errc=15 have occurred.
      !            errc=18: warning, both situations described for errc=10 and
      !                     errc=15 have occurred.
      !  D2      : floating array of bounds 0:NP containing the second
      !            derivatives at knots. D2 is computed in subroutine DCDERC .
      !            D2 is referenced only when  k=2 .
      !  DIAGN   : integer array of bounds 0:NP-1 containing further
      !            diagnostic information:
      !            diagn(i)=0 : the constraints in the interval [x(i),x(i+1)]
      !                         have been satisfied;
      !            diagn(i)=1 : the constraints in the interval [x(i),x(i+1)]
      !                         have not been satisfied;
      !
      !
      !
      !  OTHER PARAMETERS:
      !
      !  WORK    : floating array, of bounds 1:NKORK, which is used as
      !            a work area to store intermediate results.
      !            The same array can be used to provide workspace for both
      !            the main subroutines  DBVSSC and DBVSSE .
      !  NWORK   : integer variable containing the size of the work area.
      !            Restriction: nwork .GE. comm+(part+7)*np+(n*(n+11))/2+9
      !                           that is
      !                         nwork .GE. 5+(2+7)*np+(n*(n+11))/2+9
      !
      !
      !  ------------------------------------------------
      !
      !  METHOD:
      !
      !  Let the integers n and k, such that k=1,2 ; n >= 3k , and the
      !  sequence of points  (x(i),y(i)), i=0,1,...,np , with
      !  x(0) < x(1) < ... <x(np) , be given; let us denote with  BS(n;k)
      !  the set of the splines s of degree n and continuity k whose second
      !  derivative, in the case k=2 , vanishes at the knots. We are
      !  interested in the existence and construction, if possible, of a
      !  shape-preserving interpolating spline s of BS(n;k) such that
      !
      !            s(x(i)) = y(i) , i=0,1,...,np                          (1)
      !
      !  and optionally subject to constraints on the shape in each interval
      !  [x(i),x(i+1)] .
      !
      !  In the case k=2 the zero derivatives of the spline  s.IN.BS(n;k) are
      !  then modified to assume non-zero values which are not in contrast
      !  with the shape constraints and, if possible, satisfy the boundary
      !  conditions eventually imposed by the user. For details we refer to
      !  the comments in subroutine DCSDRC.
      !
      !  Since any s.IN.BS(n;k) is determined by its values and slopes at
      !  x(i) , i=0,1,...,np , we can reformulate the problem as follows:
      !  compute the values  d(i), i=0,1,...,np , such that the spline s,
      !  satisfying (1) and
      !
      !            Ds(x(i)) := d(i) , i=0,1,...,np                        (2)
      !
      !  is shape-preserving.
      !  Setting  delta(i) := (y(i+1)-y(i))/(x(i+1)-x(i)) , we have that s is
      !  increasing (I) ( decreasing (D) ) in [x(i),x(i+1)] if and only if
      !  (d(i),d(i+1))  belongs to
      !
      !    D(i) := {{ (u,v).IN.RxR : u >= 0, v >= 0, v =< -u+ n/k delta(i) }}
      !                                                                    (3)
      !  ( D(i) := {{ (u,v).IN.RxR : u =< 0, v =< 0, v >= -u+ n/k delta(i) }} )
      !
      !  s is convex (CVX) ( concave (CNC) ) if and only if (d(i),d(i+1))
      !  belongs to
      !
      !    D(i) := {{ (u,v).IN.RxR : v >= - (k/(n-k)) u + (n/(n-k)) delta(i) ,
      !                             v =< - ((n-k)/k) u + (n/k) delta(i) }}
      !                                                                    (4)
      !  ( D(i) := {{ (u,v).IN.RxR : v =< - (k/(n-k)) u + (n/(n-k)) delta(i) ,
      !                             v >= - ((n-k)/k) u + (n/k) delta(i) }}  )
      !
      !  and that s is I (D) and CVX (CNC) if and only if (d(i),d(i+1))
      !  belongs to
      !
      !             D(i) := {{ (u,v) satisfying (3) and (4) }} .
      !
      !  So, if we choose the family of sets D(i) , i=0,1,...,np-1 , according
      !  to the shape of the data, we have to solve:
      !
      !  PROBLEM P1. Does a sequence ( d(0), d(1), ..., d(np) ) such that
      !              (d(i),d(i+1)) .IN. D(i) , i=0,1,...,np-1 , exist ?
      !
      !  PROBLEM P2. If P1 is feasible, how can a (the best) solution be
      !              computed ?
      !
      !  Let DPRJ1: RxR -> R and DPRJ2: RxR -> R be, respectively, the
      !  projection maps from uv-plane onto the u-axis and v-axis and let us
      !  denote with  B(i) := DPRJ1(D(i)) :
      !
      !      ALGORITHM A1[B0].
      !        1. Set A(0):=B(0); J:=np.
      !        2. For i=1,2,...,np
      !           2.1. Set A(i):= DPRJ2( D(i-1).INT.{{ A(i-1) x B(i) }} ) .
      !           2.2. If A(i) is empty, set J:=i and stop.
      !        3. Stop.
      !
      !  We have the following result:
      !
      !  THEOREM 1. P1 has a solution if, and only if, J=np, that is A(i) is
      !             not empty , i=0,1,...,np . If ( d(0), d(1), ...,d(np) )
      !             is a solution then  d(i).IN.A(i) , i=0,1,...,np .
      !
      !  A solution can be computed with the following algorithm:
      !
      !      ALGORITHM A2[A(np),B0].
      !        1. Choose d(np).IN.A(np).
      !        2. For i=np-1, np-2, ..., 0
      !           2.1. Choose d(i).IN.DPRJ1( D(i).INT.{{ A(i) x {{ d(i+1) }}}}).
      !        3. Stop.
      !
      !  For more theoretical details about A1 and A2 see \1\ , and for
      !  practical details see subprograms DALG1, DAL2, DAL2DP. In the latter
      !  a dynamic programming scheme is used to find the best solution in
      !  the feasible set. More specifically, it is possible to compute the
      !  values  d(i),i=0,..,np which satisfy the constraints and are as close
      !  as possible to another sequence which does not satisfy the
      !  constraints but is, in some sense, optimal.
      !
      !  From a theoretical point of view, algs A1 and A2 give a complete
      !  answer to problems P1 and P2. However, it could be pointed out that,
      !  for practical applications, we would like to have the best possible
      !  plot, whether or not P1 has solutions. Let us suppose that the
      !  problem is solvable from 0 to j and from j to np, but that alg A1
      !  applied to the whole family of sets  D(i), i=0,1,...,np-1  gives
      !  J.eq.j.ne.np ; if we reset  D(j-1) := A(j-1) x B(j) , alg A1 applied
      !  to this new family of sets will produce J=np . However, it must be
      !  recalled that, in this way, we do not consider the constraints in the
      !  interval [x(j-i),x(j)] and so there is no guarantee that the spline
      !  is shape-preserving in this interval. Whenever this fact cannot be
      !  accepted it is convenient to rerun the code with a larger value for
      !  the degree n , because the domains of constraints enlarge as n
      !  increases (see (3) and (4)).
      !
      !  It is immediate to see that separable boundary conditions of the form
      !
      !            d(0) := d0 ; d(np) := dnp
      !
      !  can be easily inserted with a reduction of the corresponding
      !  admissible sets which does not modify the above theory:
      !
      !       D(0) := D(0).INT.{{d(0)=d0}} ; D(np) := D(np).INT.{{d(np)=dnp}}
      !
      !  In the case k=2 the corresponding conditions  d2(0) = d20 ,
      !  d2(np) = d2np  are imposed only if not in contrast with the shape of
      !  the data; otherwise the admissible values for  d2(0) and d2(np)
      !  respectively closest to d20 and d2np are chosen.
      !
      !  Now, let beta be a continuous function from R to R, with continuous
      !  inverse betai, we want to solve the following non-separable boundary
      !  valued problem:
      !
      !  PROBLEM P3. Do sequences ( d(0), d(1), ..., d(np) ) , such that
      !              (d(i),d(i+1)).IN.D(i), i=0,1,...,np-1    and
      !              d(np) = beta ( d(0) ) , exist ?
      !
      !  It is obvious that a solution of this new problem, if it exists, can
      !  be found amongst the solutions of P1. Let A(0), A(1),...,A(np) be the
      !  sequence of sets given by alg A1 (we assume that A(i) is not empty,
      !  i=0,1,...,np , that is P1 is solvable or, if this is not the case,
      !  the constraints have been relaxed ), we can assume that
      !  A(np) = phi(A(0)) , where  phi: R -> R is a set valued function
      !  (see \1\ for details). It can be demonstrated that:
      !
      !  THEOREM 2. P1 is solvable if, and only if, there is  dstar.IN.A(0)
      !             such that   beta(dstar).IN.phi({{dstar}}) .
      !
      !  It should be noted that if ( d(0), d(1), ..., d(np) ) satisfies P1,
      !       d(0) .IN. betai(phi(A(0)).INT.beta(A(0))) =: gamma(A(0))
      !  and, consequently, the set of admissible values is reduced. If we
      !  repeat this procedure, we get a gradually diminishing admissible set
      !  for d(0). We define
      !     ASTAR := lim A(0,m)  where
      !     A(0,0) := A(0)   and   A(0,m) := gamma(A(0,m-1)) ;
      !  ASTAR is the minimal admissible set for dstar. We can now combine the
      !  various theorems and algorithms and give the general algorithm to
      !  solve P3:
      !
      !      ALGORITHM A3.
      !        1. Set A(0,0) := B0 ; m:=1.
      !        2. Use A1[A(0,0)] for computing phi (A(0,0)).
      !        3. Set A(0,1) := gamma(A(0,0))
      !                       = betai(phi(A(0,0)).INT.beta(A(0,0))).
      !        4. If A(0,1) is empty, stop (P1 is unsolvable).
      !        5. While ( convergence test not satisfied ) do
      !           5.1. Use A1[A(0,m)] for computing A(np,m) = phi (A(0,m)).
      !           5.2. Set A(0,m+1) := gamma(A(0,m)).
      !           5.3. Set m:=m+1.
      !        6. Set ASTAR := A(0,m).
      !        7. Use A1[{{d(0)}}] to find dstar.IN.ASTAR such that
      !           beta(dstar).IN.phi(dstar).
      !        8. Use A2[beta(dstar),dstar] for computing a sequence
      !           ( d(0), d(1), ..., d(np) )  which solves P1.
      !
      !  In the case k=2 the corresponding condition  d2(np) = beta2(d2(0))
      !  is imposed only if not in contrast with the shape of
      !  the data; otherwise the admissible values for  d2(0) and d2(np)
      !  closest to the boundary condition are chosen.
      !
      !  References
      !
      !  \1\ P.Costantini: Boundary Valued Shape-Preserving Interpolating
      !      Splines, ACM Trans. on Math. Softw., companion paper.
      !  \2\ R.Bellman, S.Dreyfus: Applied Dynamic Programming, Princeton
      !      University Press, New York, 1962.
      !  \3\ H.T.Huynh: Accurate Monotone Cubic Interpolation, SIAM J. Num.
      !      Anal., 30 (1993), 57-100.
      !
      !  The ideas involved in Algorithm A3 have been implemented in the code
      !  in a general form. Since Algorithm A3 resembles closely the abstract
      !  formulation it could, therefore, be used for several practical
      !  problems. The particular case actually treated is reflected in the
      !  contents of the information array INFO (see its description in
      !  subroutine DSTINF) which contains all the data needed for the
      !  construction of the operators DPRJ0, DPRJ1 and DPRJ2.
      !
      !  As a consequence, the user has the following options:
      !
      !  - to compute a Spline subject to:
      !        - no constraint;
      !        - monotonicity constraints,
      !        - convexity constraints,
      !        - monotonicity and convexity constraints,
      !        - one of the above constraints in each subinterval, as
      !          specified in the corresponding array CONSTR;
      !
      !  - to impose separable or non-separable boundary conditions on the
      !    spline. In the latter case, the external functions BETA, BETAI,
      !    RHO and RHOI must be supplied,
      !
      !  - to assign the first derivatives d(i), i=0,1,...,np , in input or to
      !    compute them from the only constraints or as the best approximation
      !    to a set of optimal values. Although the final sequence of
      !    derivatives does in any case satisfy the imposed restrictions on
      !    the shape, the resulting graphs may exhibit different behaviors.
      !
      !  See the description of the input parameter OPT for more details.
      
      !  ------------------------------------------------
      !            End of comments.
      !  ------------------------------------------------
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: X
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: Y
      INTEGER, INTENT(INOUT) :: NP
      INTEGER, INTENT(INOUT) :: N
      INTEGER, INTENT(INOUT) :: K
      INTEGER, INTENT(INOUT) :: OPT
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D20
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D2NP
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: CONSTR
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHO
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: RHOI
      INTEGER, INTENT(INOUT) :: KMAX
      INTEGER, INTENT(INOUT) :: MAXSTP
      INTEGER, INTENT(INOUT) :: ERRC
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D2
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: DIAGN
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:NWORK) :: WORK
      INTEGER, INTENT(INOUT) :: NWORK
    END SUBROUTINE DBVSSC
  END INTERFACE

  CALL DBVSSC(X, Y, NP, N, K, OPT, D0, DNP, D20, D2NP, CONSTR, EPS, BETA, BETAI, RHO, RHOI, KMAX, MAXSTP, ERRC, D, D2, DIAGN, WORK,&
& NWORK)
END SUBROUTINE C_DBVSSC


SUBROUTINE C_DBVSSE(X_DIM_1, X, Y_DIM_1, Y, NP, N, K, XTAB_DIM_1, XTAB, NTAB, SBOPT, Y0OPT, Y1OPT, Y2OPT, ERRC, D_DIM_1, D, D2_DIM_&
&1, D2, Y0TAB_DIM_1, Y0TAB, Y1TAB_DIM_1, Y1TAB, Y2TAB_DIM_1, Y2TAB, ERRE, WORK_DIM_1, WORK, NWORK) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: X_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(X_DIM_1) :: X
  INTEGER, INTENT(IN) :: Y_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y_DIM_1) :: Y
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(INOUT) :: N
  INTEGER, INTENT(INOUT) :: K
  INTEGER, INTENT(IN) :: XTAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(XTAB_DIM_1) :: XTAB
  INTEGER, INTENT(INOUT) :: NTAB
  INTEGER, INTENT(INOUT) :: SBOPT
  INTEGER, INTENT(INOUT) :: Y0OPT
  INTEGER, INTENT(INOUT) :: Y1OPT
  INTEGER, INTENT(INOUT) :: Y2OPT
  INTEGER, INTENT(INOUT) :: ERRC
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D
  INTEGER, INTENT(IN) :: D2_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D2_DIM_1) :: D2
  INTEGER, INTENT(IN) :: Y0TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y0TAB_DIM_1) :: Y0TAB
  INTEGER, INTENT(IN) :: Y1TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y1TAB_DIM_1) :: Y1TAB
  INTEGER, INTENT(IN) :: Y2TAB_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(Y2TAB_DIM_1) :: Y2TAB
  INTEGER, INTENT(INOUT) :: ERRE
  INTEGER, INTENT(IN) :: WORK_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(WORK_DIM_1) :: WORK
  INTEGER, INTENT(INOUT) :: NWORK

  INTERFACE
    SUBROUTINE DBVSSE(X, Y, NP, N, K, XTAB, NTAB, SBOPT, Y0OPT, Y1OPT, Y2OPT, ERRC, D, D2, Y0TAB, Y1TAB, Y2TAB, ERRE, WORK, NWORK)
      !  -------------------------------------------------
      !            Lines 621-754 are comment lines.
      !            The actual code begins at line 760.
      !  -------------------------------------------------
      
      !  ABSTRACT:
      !
      !  DBVSSE is designed to evaluate the interpolating, shape-preserving
      !  spline computed in subroutine DBVSSC.
      !
      !
      !  REMARK:
      !
      !  In these comments variable and array names will be denoted with
      !  capital letters, and with small letters their contents.
      !
      !
      !  METHOD:
      !
      !  Let a spline  s:=s(x)  of degree n and continuity k (k=1,2) ,
      !  interpolating at the knots the point (x(i),y(i)) , i=0,1,...,np ,
      !  be previously computed in subroutine DBVSSC. Then, given a set of
      !  tabulation points  xtab(i) , i=0,1,...,ntab , DBVSSE computes the
      !  values  y0tab(itab):=s(xtab(itab))  and/or
      !  y1tab(itab):=Ds(xtab(itab))  and/or  y2tab(itab):=DDs(xtab(itab)) ,
      !  using, under user selection, a sequential or binary search scheme.
      !
      !  The code has the following structure:
      !
      !         DBVSSE
      !             DBVE
      !                 DTRMB
      !                 DSQTAB
      !                     DLSPIS
      !                     DBL
      !                     DBL1
      !                     DBL2
      !                 DBNTAB
      !                     DBSEAR
      !                     DLSPIS
      !                     DBL
      !                     DBL1
      !                     DBL2
      !
      !
      !  CALLING SEQUENCE:
      !
      !        CALL DBVSSE (X,Y,NP,N,K,XTAB,NTAB,SBOPT,Y0OPT,Y1OPT,Y2OPT,
      !    *                ERRC,D,D2,Y0TAB,Y1TAB,Y2TAB,ERRE,WORK,NWORK)
      !
      !
      !  INPUT PARAMETERS:
      !
      !  X       : floating array, of bounds 0:NP, containing the data
      !            abscissas  x(i), i=0,1,...,np. Restriction:
      !            x(i).LT.x(i+1), i=0,1,...,np , checked in DBVSSC.
      !  Y       : floating array, of bounds 0:NP, containing the data
      !            ordinates  y(i), i=0,1,...,np.
      !  NP      : integer variable, defining the number of interpolation
      !            points. Restriction: np.GE.2 , checked in DBVSSC.
      !  N       : integer variable, containing the degree of s.
      !            Restriction: n.GE.3 , checked in DBVSSC
      !  K       : integer variable, containing the class of continuity of s.
      !            Restriction:  k.EQ.1  or  k.EQ.2  and  n.GE.3*k , checked
      !            in DBVSSC.
      !  XTAB    : floating array, of bounds 0:NTAB, containing the abscissas
      !            of tabulation points.
      !            Restriction: xtab(i).LE.xtab(i+1), i=0,1,...,ntab-1 .
      !  NTAB    : integer variable, defining the number of tabulation points.
      !            Restriction: ntab.GE.0 .
      !  SBOPT   : integer variable, containing a control parameter.
      !            If sbopt=1 then the sequential search is used for selecting
      !            the interval of interpolation points in which xtab(i)
      !            falls. If sbopt=2, binary search is used.
      !            Restriction: sbopt.EQ.1 .OR. sbopt.EQ.2 .
      !  Y0OPT   : integer variable, containing a control parameter.
      !            If y0opt=1, the spline is evaluated at the points
      !            xtab(i), i=0,1,...,ntab and the results are stored at the
      !            array  Y0TAB.
      !            Restriction: y0opt.EQ.0 .OR. y0opt.EQ.1 .
      !  Y1OPT   : integer variable, containing a control parameter.
      !            If y1opt=1 the first derivatives of the spline at points
      !            xtab(i) i=0,1,...,ntab , are computed and the results are
      !            stored in the array Y1TAB .
      !            Restriction: y1opt.EQ.0 .OR. y1opt.EQ.1 .
      !  Y2OPT   : integer variable, containing a control parameter.
      !            If y2opt=1 the second derivatives of the spline at points
      !            xtab(i), i=0,1,...,ntab  are computed and the results are
      !            stored in the array Y2TAB.
      !            Restriction: y2opt.EQ.0 .OR. y2opt.EQ.1 .
      !  ERRC    : integer variable, containing the status of the last
      !            execution of subroutine DBVSSC.
      !  D       : floating array, of bounds 0:NP, containing the first
      !            derivatives at the knots.
      !  D2      : floating array of bounds 0:NP containing the second
      !            derivatives at the knots.
      !
      !
      !  OUTPUT PARAMETERS:
      !
      !
      !  Y0TAB   : floating array, of bounds 0:NTAB, containing the values of
      !            the spline at the tabulation points xtab(i) ,
      !            i=0,1,...,ntab when the option  y0opt=1  is activated.
      !  Y1TAB   : floating array, of bounds 0:NTAB, containing the values of
      !            the first derivative of the spline at the tabulation points
      !            xtab(i) , i=0,1,...ntab , when the option y1opt=1 is
      !            activated.
      !  Y2TAB   : floating array, of bounds 0:NTAB, containing the values of
      !            the second derivative of the spline at the tabulation
      !            points xtab(i) , i=0,1,...,ntab , when the option y2opt=1
      !            is activated.
      !  ERRE    : integer variable, containing an error flag which displays
      !            the status of the code. DBVSSE has only two levels of error
      !            (see DBVSSC for comparison): success and severe error,
      !            which means that some incorrect assignment for input data
      !            have been set.
      !            ERRE=0:  success, normal return of the code;
      !            ERRE=1:  severe error, the value errc gives a status of
      !                     error, which means that the output of DBVSSC is
      !                     meaningless. Check the input parameters of DBVSSC.
      !            ERRE=2:  severe error, incorrect assignment for some of
      !                     the values ntab, sbopt, y0opt, y1opt, y2opt ,
      !                     nwork;
      !            ERRE=3:  severe error, the restriction xtab(i).LT.xtab(i+1)
      !                     is not fulfilled for some i when sequential search
      !                     is required;
      !
      !
      !  OTHER PARAMETERS:
      !
      !  WORK    : floating array, of bounds 1:NKORK, which is used as
      !            a work area to store intermediate results.
      !            The same array can be used to provide workspace for both
      !            the main subroutines  DBVSSC and DBVSSE .
      !  NWORK   : integer variable containing the size of the work area.
      !            Restriction: nwork .GE. comm+(part+7)*np+(n*(n+11))/2+9
      !                           that is
      !                         nwork .GE. 3+(2+7)*np+(n*(n+11))/2+9
      
      !  -------------------------------------------------
      !            End of comments.
      !  -------------------------------------------------
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: X
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: Y
      INTEGER, INTENT(INOUT) :: NP
      INTEGER, INTENT(INOUT) :: N
      INTEGER, INTENT(INOUT) :: K
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: XTAB
      INTEGER, INTENT(INOUT) :: NTAB
      INTEGER, INTENT(INOUT) :: SBOPT
      INTEGER, INTENT(INOUT) :: Y0OPT
      INTEGER, INTENT(INOUT) :: Y1OPT
      INTEGER, INTENT(INOUT) :: Y2OPT
      INTEGER, INTENT(INOUT) :: ERRC
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D2
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y0TAB
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y1TAB
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NTAB) :: Y2TAB
      INTEGER, INTENT(INOUT) :: ERRE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:NWORK) :: WORK
      INTEGER, INTENT(INOUT) :: NWORK
    END SUBROUTINE DBVSSE
  END INTERFACE

  CALL DBVSSE(X, Y, NP, N, K, XTAB, NTAB, SBOPT, Y0OPT, Y1OPT, Y2OPT, ERRC, D, D2, Y0TAB, Y1TAB, Y2TAB, ERRE, WORK, NWORK)
END SUBROUTINE C_DBVSSE


SUBROUTINE C_DALG1(A1_DIM_1, A1_DIM_2, A1, NP, INFO_DIM_1, INFO, COMM, PART, EPS, A2_DIM_1, A2_DIM_2, A2, ERRC, DIAGN_DIM_1, DIAGN)&
& BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: A1_DIM_1
  INTEGER, INTENT(IN) :: A1_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A1_DIM_1,A1_DIM_2) :: A1
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(IN) :: INFO_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(INFO_DIM_1) :: INFO
  INTEGER, INTENT(INOUT) :: COMM
  INTEGER, INTENT(INOUT) :: PART
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
  INTEGER, INTENT(IN) :: A2_DIM_1
  INTEGER, INTENT(IN) :: A2_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A2_DIM_1,A2_DIM_2) :: A2
  INTEGER, INTENT(INOUT) :: ERRC
  INTEGER, INTENT(IN) :: DIAGN_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(DIAGN_DIM_1) :: DIAGN

  INTERFACE
    SUBROUTINE DALG1(A1, NP, INFO, COMM, PART, EPS, A2, ERRC, DIAGN)
      !  DALG1 implements the algorithm A1[B(0)] described in subr. DBVSSC.
      !
      !  The input parameters NP,COMM,PART,EPS and the output parameters
      !  ERRC, DIAGN are described in DBVSSC. The input parameter INFO is
      !  described in DSTINF.
      !
      !  Items of possible interest are:
      !
      !  A1: floating array, of bounds 1:2, 0:NP, containing the sequence of
      !      the sets  B(i), i=0,1,...,np (see the comments in DBVSSC).
      !      More precisely,  B(i) = [a1(1,i),a1(2,i)] .
      !
      !  A2: floating array, of bounds 1:2, 0:NP, containing the sequence of
      !      the sets  A(i), i=0,1,...,np (see the comments in DBVSSC).
      !      More precisely, A(i) = [a2(1,i),a2(2,i)] .
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A1
      INTEGER, INTENT(INOUT) :: NP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:COMM+PART*NP+NP+1) :: INFO
      INTEGER, INTENT(INOUT) :: COMM
      INTEGER, INTENT(INOUT) :: PART
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A2
      INTEGER, INTENT(INOUT) :: ERRC
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: DIAGN
    END SUBROUTINE DALG1
  END INTERFACE

  CALL DALG1(A1, NP, INFO, COMM, PART, EPS, A2, ERRC, DIAGN)
END SUBROUTINE C_DALG1


SUBROUTINE C_DALG1D(DSTAR, A1_DIM_1, A1_DIM_2, A1, NP, INFO_DIM_1, INFO, COMM, PART, EPS, A2_DIM_1, A2_DIM_2, A2, ERRC1) BIND(C)
  IMPLICIT NONE
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DSTAR
  INTEGER, INTENT(IN) :: A1_DIM_1
  INTEGER, INTENT(IN) :: A1_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A1_DIM_1,A1_DIM_2) :: A1
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(IN) :: INFO_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(INFO_DIM_1) :: INFO
  INTEGER, INTENT(INOUT) :: COMM
  INTEGER, INTENT(INOUT) :: PART
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
  INTEGER, INTENT(IN) :: A2_DIM_1
  INTEGER, INTENT(IN) :: A2_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A2_DIM_1,A2_DIM_2) :: A2
  INTEGER, INTENT(INOUT) :: ERRC1

  INTERFACE
    SUBROUTINE DALG1D(DSTAR, A1, NP, INFO, COMM, PART, EPS, A2, ERRC1)
      !  DALG1D computes the sequence of sets A(i), i=0,1,...,np, implementing
      !  the algorithm A1[{{dstar}}], that is with A(0)={{dstar}} (see the com-
      !  ments in subroutine DBVSSC for details).
      !
      !  The input parameters NP,COMM,PART,EPS are described in DBVSSC; the
      !  input parameter INFO is described in DSTINF; the input parameters A1
      !  and A2 are described in subprogram DALG1.
      !
      !  Item of possible interest is:
      !
      !  ERRC1  : Integer parameter, containing a control variable which is
      !           then used in subr. DFPSVF
      !           errc1 = 0 - success, normal return of the subprogram;
      !           errc1 = 1 - A(i) is empty for some i.
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DSTAR
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A1
      INTEGER, INTENT(INOUT) :: NP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:COMM+PART*NP+NP+1) :: INFO
      INTEGER, INTENT(INOUT) :: COMM
      INTEGER, INTENT(INOUT) :: PART
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A2
      INTEGER, INTENT(INOUT) :: ERRC1
    END SUBROUTINE DALG1D
  END INTERFACE

  CALL DALG1D(DSTAR, A1, NP, INFO, COMM, PART, EPS, A2, ERRC1)
END SUBROUTINE C_DALG1D


SUBROUTINE C_DALG3(INFO_DIM_1, INFO, NP, COMM, PART, OPT, D0, DNP, EPS, KMAX, MAXSTP, BETA, BETAI, A1_DIM_1, A1_DIM_2, A1, A2_DIM_1&
&, A2_DIM_2, A2, D_DIM_1, D, ERRC, DIAGN_DIM_1, DIAGN) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: INFO_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(INFO_DIM_1) :: INFO
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(INOUT) :: COMM
  INTEGER, INTENT(INOUT) :: PART
  INTEGER, INTENT(INOUT) :: OPT
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
  INTEGER, INTENT(INOUT) :: KMAX
  INTEGER, INTENT(INOUT) :: MAXSTP
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
  INTEGER, INTENT(IN) :: A1_DIM_1
  INTEGER, INTENT(IN) :: A1_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A1_DIM_1,A1_DIM_2) :: A1
  INTEGER, INTENT(IN) :: A2_DIM_1
  INTEGER, INTENT(IN) :: A2_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A2_DIM_1,A2_DIM_2) :: A2
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D
  INTEGER, INTENT(INOUT) :: ERRC
  INTEGER, INTENT(IN) :: DIAGN_DIM_1
  INTEGER, INTENT(INOUT), DIMENSION(DIAGN_DIM_1) :: DIAGN

  INTERFACE
    SUBROUTINE DALG3(INFO, NP, COMM, PART, OPT, D0, DNP, EPS, KMAX, MAXSTP, BETA, BETAI, A1, A2, D, ERRC, DIAGN)
      !  DALG3 computes a sequence of slopes ( d(0), d(1), ..., d(np) ) which
      !  can be used to compute a shape-preserving interpolating spline with
      !  or without boundary conditions, as requested by the user. It is an
      !  implementation of the algorithm A3 described in subroutine DBVSSC.
      !
      !  The input parameters NP,COMM,PART,OPT,EPS,KMAX,MAXSTP,BETA,BETAI,D
      !  and the output parameter ERRC are described in subprogram DBVSSC.
      !  The input parameter INFO is described in subprogram DSTINF.
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:COMM+PART*NP+NP+1) :: INFO
      INTEGER, INTENT(INOUT) :: NP
      INTEGER, INTENT(INOUT) :: COMM
      INTEGER, INTENT(INOUT) :: PART
      INTEGER, INTENT(INOUT) :: OPT
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: D0
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: DNP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: EPS
      INTEGER, INTENT(INOUT) :: KMAX
      INTEGER, INTENT(INOUT) :: MAXSTP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETA
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT) :: BETAI
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A1
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A2
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
      INTEGER, INTENT(INOUT) :: ERRC
      INTEGER, INTENT(INOUT), DIMENSION(0:NP-1) :: DIAGN
    END SUBROUTINE DALG3
  END INTERFACE

  CALL DALG3(INFO, NP, COMM, PART, OPT, D0, DNP, EPS, KMAX, MAXSTP, BETA, BETAI, A1, A2, D, ERRC, DIAGN)
END SUBROUTINE C_DALG3


SUBROUTINE C_DAL2(A2_DIM_1, A2_DIM_2, A2, NP, INFO_DIM_1, INFO, COMM, PART, D_DIM_1, D) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: A2_DIM_1
  INTEGER, INTENT(IN) :: A2_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A2_DIM_1,A2_DIM_2) :: A2
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(IN) :: INFO_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(INFO_DIM_1) :: INFO
  INTEGER, INTENT(INOUT) :: COMM
  INTEGER, INTENT(INOUT) :: PART
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D

  INTERFACE
    SUBROUTINE DAL2(A2, NP, INFO, COMM, PART, D)
      !  DAL2 computes a sequence of slopes (d(0),d(1),...,d(np)) implementing
      !  alg. A2  described in subr. DBVSSC. Each d(i),i=0,1,...,np , is
      !  chosen as the midpoint of the interval of all feasible values .
      !
      !  The input parameters NP,COMM,PART and the output parameter D are
      !  described in DBVSSC; the input parameter INFO is described in DSTINF.
      !
      !  Item of possible interest is:
      !
      !  A2   : floating array, of bounds 1:2, 0:NP; [a2(1,i),a2(2,i)]
      !         is the feasible interval for d(i) .
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A2
      INTEGER, INTENT(INOUT) :: NP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:COMM+PART*NP+NP+1) :: INFO
      INTEGER, INTENT(INOUT) :: COMM
      INTEGER, INTENT(INOUT) :: PART
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
    END SUBROUTINE DAL2
  END INTERFACE

  CALL DAL2(A2, NP, INFO, COMM, PART, D)
END SUBROUTINE C_DAL2


SUBROUTINE C_DAL2DP(A2_DIM_1, A2_DIM_2, A2, NP, INFO_DIM_1, INFO, COMM, PART, D_DIM_1, D) BIND(C)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: A2_DIM_1
  INTEGER, INTENT(IN) :: A2_DIM_2
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(A2_DIM_1,A2_DIM_2) :: A2
  INTEGER, INTENT(INOUT) :: NP
  INTEGER, INTENT(IN) :: INFO_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(INFO_DIM_1) :: INFO
  INTEGER, INTENT(INOUT) :: COMM
  INTEGER, INTENT(INOUT) :: PART
  INTEGER, INTENT(IN) :: D_DIM_1
  REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(D_DIM_1) :: D

  INTERFACE
    SUBROUTINE DAL2DP(A2, NP, INFO, COMM, PART, D)
      !  DAL2DP links algorithm A2 and a dynamic programming scheme
      !  to select, among the set of all feasible solutions, the sequence
      !  ( d(0),d(1), ..., d(np) ) which is the best 2-norm approximation to
      !  a set of optimal values. More precisely, if (ds(0),ds(1), ...,ds(np))
      !  is the sequence of optimal values, DAL2DP use the following dynamic
      !  programming relations
      !
      !    psi(0;d(0)) := (d(0)-ds(0))**2
      !    psi(j;d(j)) := (d(j)-ds(j))**2 + min(psi(j-1;d(j-1)))
      !
      !  for describing the objective function
      !
      !      SUM  ((d(j) - ds(j)) ** 2
      !    j=0,np
      !
      !  For a complete comprehension of the algorithm see the book \2\
      !  quoted in the references of subr. DBVSSC
      !
      !  The input parameters NP,COMM,PART and the output parameter D are
      !  described in subprogram DBVSSC; the input parameter INFO is described
      !  in subprogram DSTINF and the input parameter A2 is described in DAL2.
      !  The constant NSUBD defined below is related to the discretization of
      !  the admissible domain.
      IMPLICIT NONE
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:2,0:NP) :: A2
      INTEGER, INTENT(INOUT) :: NP
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(1:COMM+PART*NP+NP+1) :: INFO
      INTEGER, INTENT(INOUT) :: COMM
      INTEGER, INTENT(INOUT) :: PART
      REAL(KIND=KIND ( 0.0D0 )), INTENT(INOUT), DIMENSION(0:NP) :: D
    END SUBROUTINE DAL2DP
  END INTERFACE

  CALL DAL2DP(A2, NP, INFO, COMM, PART, D)
END SUBROUTINE C_DAL2DP

