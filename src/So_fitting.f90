!The Polymorphic Tracking Code
!Copyright (C) Etienne Forest and CERN

module S_fitting
  USE MAD_LIKE
  IMPLICIT NONE
  public
  PRIVATE FIND_ORBIT_LAYOUT, FIND_ORBIT_LAYOUT_noda
  logical(lp), PRIVATE :: VERBOSE = .false.
  integer :: max_fit_iter=20, ierror_fit=0, max_fiND_iter=40
  real(dp) :: fuzzy_split=one
  real(dp) :: max_ds=zero
  integer :: resplit_cutting = 0    ! 0 just magnets , 1 magnets as before / drifts separately
  ! 2  space charge algorithm
  logical(lp) :: radiation_bend_split=my_false

  INTERFACE FIND_ORBIT
     ! LINKED
     ! no use of TPSA
     MODULE PROCEDURE FIND_ORBIT_LAYOUT_noda
  END INTERFACE


contains
  SUBROUTINE lattice_GET_CHROM(R,my_state,CHROM)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    REAL(DP) CHROM(:)
    TYPE(internal_state) state
    real(dp) closed(6)
    type(DAMAP) ID
    TYPE(NORMALFORM) NORM
    TYPE(REAL_8) Y(6)

    STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)

    closed=zero
    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED
    CALL INIT(STATE,2,0,BERZ)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,STATE)
    NORM=Y
    CHROM(1)=norm%DHDJ%V(1).SUB.'00001'
    CHROM(2)=norm%DHDJ%V(2).SUB.'00001'
    WRITE(6,*) "Fractional Tunes = ",norm%tune(1:2)
    WRITE(6,*) "CHROMATICITIES = ",CHROM
    CALL kill(NORM)
    CALL kill(Y)
    call kill(id)
    if(.not.check_stable) then
     CALL RESET_APERTURE_FLAG
     write(6,*) " Flags were reset in lattice_GET_CHROM"
    endif

  end SUBROUTINE lattice_GET_CHROM


  SUBROUTINE lattice_GET_tune(R,my_state,mf)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    TYPE(internal_state) state
    integer mf
    real(dp) closed(6)
    type(DAMAP) ID
    TYPE(NORMALFORM) NORM
    TYPE(REAL_8) Y(6)
    
    

    STATE=my_state
  
    closed=zero
    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit "
    WRITE(6,'(6(1x,g21.14))') CLOSED
    CALL INIT(STATE,1,0,BERZ)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,STATE)
    NORM=Y
    closed=y
    WRITE(6,'(6(1x,g21.14),a24)') CLOSED," <-- should be identical"
    if(mf==6) then
     WRITE(6,'(a19,3(1x,g21.14))') "Fractional Tunes = ",norm%tune(1:3)
     if(norm%tune(3)/=zero.and.c_%ndpt==0) &
     WRITE(6,'(a20,(1x,g21.14))') "Synchrotron period = ",1.d0/abs(norm%tune(3))
     else
     if(norm%tune(3)/=zero.and.c_%ndpt==0) then
       WRITE(mf,'(4(1x,g21.14))') xsm0%ac%t/clight/unit_time,norm%tune(1:3)
     else
       WRITE(mf,'(3(1x,g21.14))') xsm0%ac%t/clight/unit_time,norm%tune(1:2)
     endif
    endif
    CALL kill(NORM)
    CALL kill(Y)
    call kill(id)
    if(.not.check_stable) then
     CALL RESET_APERTURE_FLAG
     write(6,*) " Flags were reset lattice_GET_tune"
    endif
    
  end SUBROUTINE lattice_GET_tune



  SUBROUTINE compute_A_4d(r,my_state,filename,pos,del,no,MY_A)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    integer pos,no,imod,ic,I
    TYPE(internal_state) state
    real(dp) closed(6),del
    type(DAMAP) ID
    TYPE(REAL_8) Y(6)
    CHARACTER(*) FILENAME
    TYPE(FIBRE), POINTER :: P
    TYPE(DAMAP) MY_A
    TYPE(NORMALFORM) NORM


    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    closed=zero
    closed(5)=del
    CALL FIND_ORBIT(R,CLOSED,pos,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED

    CALL INIT(STATE,no,0,BERZ)

    CALL ALLOC(Y); CALL ALLOC(MY_A); CALL ALLOC(NORM)
    call alloc(id)
    imod=r%n/10
    id=1
    Y=CLOSED+id
    ic=0
    p=>r%start
    do i=1,r%n

       CALL TRACK(R,Y,i,i+1,STATE)
       if(mod(i,imod)==0) then
          ic=ic+1
          write(6,*) ic*10," % done "
       endif
       p=>p%next
    enddo
    id=y

    call kanalnummer(ic)
    open(unit=ic,file=FILENAME)


    call print(ID,IC)
    NORM=ID
    MY_A=NORM%A_T
    WRITE(6,*) " TUNES ",NORM%TUNE(1:2)
    call print(MY_A,IC)
    CLOSE(IC)


    CALL kill(Y)
    call kill(id)
    call kill(NORM)
    if(.not.check_stable) then
     CALL RESET_APERTURE_FLAG
     write(6,*) " Flags were reset in compute_A_4d"
    endif

  end SUBROUTINE compute_A_4d



  SUBROUTINE compute_map_general(r,my_state,filename,pos,del,no)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    TYPE(internal_state) state
    integer pos,no,is,mf
    real(dp) closed(6),del
    type(DAMAP) ID
    TYPE(REAL_8) Y(6)
    CHARACTER(*) FILENAME
    type(normalform) norm
    type(taylor) betax,betax2
    integer, allocatable :: expo1(:),expo2(:)
    integer, allocatable :: expo3(:),expo4(:)

    call kanalnummer(mf)
    open(unit=mf,file=filename)

    state=my_state   !+nocavity0

    if(state%nocavity) then
       allocate(expo1(4),expo2(4))
       allocate(expo3(4),expo4(4))
    else
       allocate(expo1(6),expo2(6))
       allocate(expo3(6),expo4(6))
    endif

    expo1=zero;expo2=zero;
    expo3=zero;expo4=zero;

    closed=zero
    closed(5)=del
    CALL FIND_ORBIT(R,CLOSED,pos,my_state,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED

    call init(state,no,c_%np_pol,berz)
    call alloc(id); call alloc(norm);call alloc(y);call alloc(betax,betax2);

    id=1; y=closed+id;
    is=track_flag(r,y,pos,+state)

    if(is/=0) then
       write(6,*) "HELP"
       stop
    endif
    id=y

    call print(id,mf)
    close(mf)
    call kill(id); call kill(norm);call kill(y);call kill(betax,betax2);
    deallocate(expo1,expo2)
    deallocate(expo3,expo4)

  END SUBROUTINE compute_map_general


  SUBROUTINE compute_map_4d(r,my_state,filename,pos,del,no)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    integer pos,no,imod,ic,I
    TYPE(internal_state) state
    real(dp) closed(6),del
    type(DAMAP) ID
    TYPE(REAL_8) Y(6)
    CHARACTER(*) FILENAME
    TYPE(FIBRE), POINTER :: P



    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    closed=zero
    closed(5)=del
    CALL FIND_ORBIT(R,CLOSED,pos,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED

    CALL INIT(STATE,no,0,BERZ)

    CALL ALLOC(Y)
    call alloc(id)
    imod=r%n/10
    id=1
    Y=CLOSED+id
    ic=0
    p=>r%start
    do i=1,r%n

       CALL TRACK(R,Y,i,i+1,STATE)
       if(mod(i,imod)==0) then
          ic=ic+1
          write(6,*) ic*10," % done "
       endif
       p=>p%next
    enddo
    id=y

    call kanalnummer(ic)
    open(unit=ic,file=FILENAME)


    call print(ID,IC)

    CLOSE(IC)


    CALL kill(Y)
    call kill(id)

  end SUBROUTINE compute_map_4d

  SUBROUTINE FILL_BETA(r,my_state,pos,BETA,IB,DBETA,tune,tune2,a,ai,mat,clos)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    REAL(DP), pointer :: BETA(:,:,:)
    REAL(DP)DBETA,tune(:),tune2(:)
    type(fibre),pointer :: p
    integer i,IB,pos,mf
    TYPE(internal_state) state
    real(dp) closed(6)
    type(DAMAP) ID
    TYPE(NORMALFORM) NORM
    TYPE(REAL_8) Y(6)
    real(dp) dbetamax,db1,db2
    real(dp),optional :: a(6,6),ai(6,6),mat(6,6),clos(6)

    if(.not.associated(beta))   ALLOCATE(BETA(2,2,R%N))


    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    if(present(clos)) then
       closed=clos
    else
       closed=zero
    endif
    if(pos/=0) then
       CALL FIND_ORBIT(R,CLOSED,pos,STATE,c_1d_5)
       write(6,*) "closed orbit "
       write(6,*) CLOSED
    else
       write(6,*) " Using a map "
    endif
    DBETA=ZERO
    dbetamax=zero
    CALL INIT(STATE,1,0,BERZ)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    call alloc(id)
    if(pos/=0) then

       id=1
       Y=CLOSED+id

       CALL TRACK(R,Y,1,STATE)
       write(6,*) " stability ", c_%check_stable
       id=y
    else
       call kanalnummer(mf)
       open(unit=mf,file='map.dat')
       call read(id,mf)
       close(mf)
    endif
    NORM=id
    if(present(a)) then
       a=zero
       ai=zero
       a=norm%a_t
       ai=norm%a_t**(-1)
       id=y
       mat=id
       if(pos==0)  Write(6,*) " Tunes ",norm%tune(1:2)
    endif
    if(pos/=0) then
       if(ib==1) then
          tune(1:2)=norm%tune(1:2)
       endif
       tune2(1:2)=norm%tune(1:2)
       Write(6,*) " Tunes ", norm%tune(1:2)

       y=closed+norm%a_t
       p=>r%start
       do i=pos,pos+r%n-1

          CALL TRACK(R,Y,i,i+1,STATE)
          beta(IB,1,i-pos+1)=(y(1).sub.'1')**2   + (y(1).sub.'01')**2
          beta(iB,2,i-pos+1)=(y(3).sub.'001')**2 + (y(3).sub.'0001')**2

          IF(IB==2) THEN
             db1=ABS(beta(2,1,i-pos+1)-beta(1,1,i-pos+1))/beta(1,1,i-pos+1)
             db2=ABS(beta(2,2,i-pos+1)-beta(1,2,i-pos+1))/beta(1,2,i-pos+1)
             DBETA=(db1+db2)/TWO+dbeta
             if( db1>dbetamax) dbetamax=db1
             if( db2>dbetamax) dbetamax=db2
          ENDIF
          p=>p%next
       enddo
       DBETA=DBETA/R%N

       IF(IB==2) WRITE(6,*) "<DBETA/BETA> = ",DBETA
       IF(IB==2) WRITE(6,*) "MAXIMUM OF DBETA/BETA = ",dbetamax
    endif
    CALL kill(NORM)
    CALL kill(Y)
    call kill(id)
    if(present(clos)) clos=closed

  end SUBROUTINE FILL_BETA

  SUBROUTINE comp_longitudinal_accel(r,my_state,no,h,filename)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state) state
    real(dp) closed(6),l1,l2,p0c
    type(DAMAP) ID
    TYPE(NORMALFORM) NORM
    TYPE(REAL_8) Y(6)
    integer no,mf,i,h
    CHARACTER(*) FILENAME
    integer, allocatable :: j(:)
    TYPE(internal_state), intent(in):: my_state
    TYPE(fibre), pointer :: p
    logical first
    type(work) w
    p=> r%start

    l1=0.d0
    l2=0.d0
    first=.true.
    w=p
    p0c=w%p0c

    call kanalnummer(mf,filename)

    write(6,*)h,w%mass,w%p0c,w%beta0
    write(mf,*) h
    write(mf,*) w%mass,w%p0c,w%beta0

    do i=1,r%n
       if(p%mag%kind/=kind4) then
          if(first) then
             l1=l1+p%mag%p%ld
          else
             l2=l2+p%mag%p%ld
          endif
       else
          if(.not.first) stop 111
          l1=l1+p%mag%p%ld/2
          l2=p%mag%p%ld/2
          first=.false.
       endif
       p=>p%next
    enddo
    write(6,*) l1,l2
    write(mf,*) l1,l2


    STATE=my_state+nocavity0

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)

    CALL INIT(STATE,no,0)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,STATE)
    NORM=Y

    allocate(j(c_%nv))
    j=0
    do i=1,no
       j(5)=i
       write(6,*) norm%dhdj%v(3).sub.j
       write(mf,*) norm%dhdj%v(3).sub.j
    enddo

    deallocate(j)

    CALL kill(NORM)
    CALL kill(Y)
    call kill(id)
    close(mf)

  end SUBROUTINE comp_longitudinal_accel


  SUBROUTINE comp_linear2(r,my_state,a,ai,mat,closed)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: my_state
    TYPE(internal_state) state
    real(dp) closed(6),a(6,6),ai(6,6),mat(6,6)
    type(DAMAP) ID
    TYPE(NORMALFORM) NORM
    TYPE(REAL_8) Y(6)


    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)

    CALL INIT(STATE,1,0,BERZ)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,STATE)
    NORM=Y

    Write(6,*) " Tunes ",norm%tune(1:2)
    A=ZERO
    AI=ZERO
    MAT=ZERO
    a=norm%a_t
    AI=norm%a_t**(-1)
    id=y
    mat=id
    CALL kill(NORM)
    CALL kill(Y)
    call kill(id)

  end SUBROUTINE comp_linear2


  subroutine lattice_fit_TUNE_gmap_auto(R,my_state,EPSF,TARG,name)
    IMPLICIT NONE
    TYPE(layout), target,intent(inout):: R
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE, MF
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer :: neq=2, no=2,nt,j,it,NP
    type(damap) id
    type(gmap) g
    TYPE(TAYLOR)t
    character(nlp) name(2)
    real(dp) epsf,epsr,epsnow,gam(2)
    type(fibre), pointer:: p
    logical dname(2)
    TYPE(POL_BLOCK) poly(2)
    call context(name(1))
    call context(name(2))
    poly(1)=0
    poly(2)=0
    poly(1)%ibn(2)=1
    poly(2)%ibn(2)=2
    !    EPSF=.0001
    SET_TPSAFIT=.FALSE.
    dname=.false.
    p=>r%start
    do i=1,r%n
       if(index (p%mag%name,name(1)(1:len_trim(name(1))) )   /=0) then
          call  EL_POL_force(p,poly(1))
          dname(1)=.true.
       elseif(index(p%mag%name,name(2)(1:len_trim(name(2))))/=0) then
          call  EL_POL_force(p,poly(2))
          dname(2)=.true.
       endif

       p=>p%next
    enddo

    if(.not.(dname(1).and.dname(2))) then
       CALL ELP_TO_EL(R)
       write(6,*) " lattice_fit_TUNE_gmap_auto ---> FAILED"
       return
    endif


    epsr=abs(epsf)

    np=2

    allocate(eq(neq))

    nt=neq+np
    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    CALL INIT(STATE,no,NP)


    !   DO I=1,NPOLY
    !      R=POLY(i)
    !   ENDDO


    CLOSED(:)=zero
    it=0
100 continue
    it=it+1

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED


    CALL INIT(STATE,no,NP)
    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(EQ)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,+STATE)
    write(6,*) "c_%no,c_%nv,c_%nd,c_%nd2"
    write(6,*) c_%no,c_%nv,c_%nd,c_%nd2
    write(6,*) "c_%ndpt,c_%npara,c_%npara,c_%np_pol"
    write(6,*)  c_%ndpt,c_%npara,c_%npara,c_%np_pol
    NORM=Y
    gam(1)=(norm%a_t%v(2).sub.'1')**2+(norm%a_t%v(2).sub.'01')**2
    gam(2)=(norm%a_t%v(4).sub.'001')**2+(norm%a_t%v(4).sub.'0001')**2
    write(6,*) "  Gamma= ",GAM
    !      CALL KANALNUMMER(MF)
    OPEN(UNIT=1111,FILE='GAMMA.TXT')
    WRITE(1111,*) "  Gamma= ",GAM

    write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2)

    eq(1)=       ((NORM%dhdj%v(1)).par.'0000')-targ(1)
    eq(2)=       ((NORM%dhdj%v(2)).par.'0000')-targ(2)
    epsnow=abs(eq(1))+abs(eq(2))
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile

    do i=1,neq
       eq(i)=eq(i)<=c_%npara
    enddo
    do i=1,neq
       call daprint(eq(i),scratchfile)
    enddo
    close(SCRATCHFILE)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(id)
    CALL KILL(EQ)



    CALL INIT(1,nt)
    call alloc(g,nt)
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile
    do i=np+1,nt
       call read(g%v(i),scratchfile)
    enddo
    close(SCRATCHFILE)

    call alloc(t)
    do i=1,np
       g%v(i)=one.mono.i
       do j=np+1,nt
          t=g%v(j).d.i
          g%v(i)=g%v(i)+(one.mono.j)*t
       enddo
    enddo
    CALL KILL(t)

    g=g.oo.(-1)
    tpsafit=zero
    tpsafit(1:nt)=g

    SET_TPSAFIT=.true.

    p=>r%start
    do i=1,r%n
       if(index (p%mag%name,name(1)(1:len_trim(name(1))) )   /=0) then
          call  EL_POL_force(p,poly(1))
       elseif(index(p%mag%name,name(2)(1:len_trim(name(2))))/=0) then
          call  EL_POL_force(p,poly(2))
       endif

       p=>p%next
    enddo

    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(eq)

  end subroutine lattice_fit_TUNE_gmap_auto

  subroutine lattice_fit_TUNE_gmap(R,my_state,EPSF,POLY,NPOLY,TARG,NP)
    IMPLICIT NONE
    TYPE(layout), target,intent(inout):: R
    TYPE(POL_BLOCK), intent(inout),dimension(:)::POLY
    INTEGER, intent(in):: NPOLY,NP
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE, MF
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer :: neq=2, no=2,nt,j,it
    type(damap) id
    type(gmap) g
    TYPE(TAYLOR)t
    real(dp) epsf,epsr,epsnow,gam(2)
    !    EPSF=.0001
    epsr=abs(epsf)

    allocate(eq(neq))

    nt=neq+np
    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)

    CALL INIT(STATE,no,NP,BERZ)

    SET_TPSAFIT=.FALSE.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    CLOSED(:)=zero
    it=0
100 continue
    it=it+1

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED


    CALL INIT(STATE,no,NP,BERZ)
    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(EQ)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,+STATE)
    write(6,*) "c_%no,c_%nv,c_%nd,c_%nd2"
    write(6,*) c_%no,c_%nv,c_%nd,c_%nd2
    write(6,*) "c_%ndpt,c_%npara,c_%npara,c_%np_pol"
    write(6,*)  c_%ndpt,c_%npara,c_%npara,c_%np_pol
    NORM=Y
    gam(1)=(norm%a_t%v(2).sub.'1')**2+(norm%a_t%v(2).sub.'01')**2
    gam(2)=(norm%a_t%v(4).sub.'001')**2+(norm%a_t%v(4).sub.'0001')**2
    write(6,*) "  Gamma= ",GAM
    !      CALL KANALNUMMER(MF)
    OPEN(UNIT=1111,FILE='GAMMA.TXT')
    WRITE(1111,*) "  Gamma= ",GAM

    write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2)

    eq(1)=       ((NORM%dhdj%v(1)).par.'0000')-targ(1)
    eq(2)=       ((NORM%dhdj%v(2)).par.'0000')-targ(2)
    epsnow=abs(eq(1))+abs(eq(2))
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile

    do i=1,neq
       eq(i)=eq(i)<=c_%npara
    enddo
    do i=1,neq
       call daprint(eq(i),scratchfile)
    enddo
    close(SCRATCHFILE)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(id)
    CALL KILL(EQ)



    CALL INIT(1,nt)
    call alloc(g,nt)
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile
    do i=np+1,nt
       call read(g%v(i),scratchfile)
    enddo
    close(SCRATCHFILE)

    call alloc(t)
    do i=1,np
       g%v(i)=one.mono.i
       do j=np+1,nt
          t=g%v(j).d.i
          g%v(i)=g%v(i)+(one.mono.j)*t
       enddo
    enddo
    CALL KILL(t)

    g=g.oo.(-1)
    tpsafit=zero
    tpsafit(1:nt)=g

    SET_TPSAFIT=.true.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(eq)

  end subroutine lattice_fit_TUNE_gmap

  subroutine lattice_fit_CHROM_gmap(R,my_state,EPSF,POLY,NPOLY,TARG,NP)
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    TYPE(POL_BLOCK), intent(inout),dimension(:)::POLY
    INTEGER, intent(in):: NPOLY,NP
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer :: neq=2, no=3,nt,j,it
    type(damap) id
    type(gmap) g
    TYPE(TAYLOR)t
    real(dp) epsf,epsr,epsnow,CHROM(2)
    !    EPSF=.0001
    epsr=abs(epsf)

    allocate(eq(neq))

    nt=neq+np
    STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)

    CALL INIT(STATE,no,NP,BERZ)

    SET_TPSAFIT=.FALSE.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    CLOSED(:)=zero
    it=0
100 continue
    it=it+1

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit ", CHECK_STABLE
    write(6,*) CLOSED


    CALL INIT(STATE,no,NP,BERZ)
    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(EQ)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,+STATE)
    NORM=Y
    write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2), CHECK_STABLE
    CHROM(1)=(NORM%dhdj%v(1)).SUB.'00001'
    CHROM(2)=(NORM%dhdj%v(2)).SUB.'00001'
    write(6,*) " CHROM ",CHROM

    eq(1)=       ((NORM%dhdj%v(1)).par.'00001')-targ(1)
    eq(2)=       ((NORM%dhdj%v(2)).par.'00001')-targ(2)
    epsnow=abs(eq(1))+abs(eq(2))
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile

    do i=1,neq
       eq(i)=eq(i)<=c_%npara
    enddo
    do i=1,neq
       call daprint(eq(i),scratchfile)
    enddo
    close(SCRATCHFILE)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(id)
    CALL KILL(EQ)



    CALL INIT(1,nt)
    call alloc(g,nt)
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile
    do i=np+1,nt
       call read(g%v(i),scratchfile)
    enddo
    close(SCRATCHFILE)

    call alloc(t)
    do i=1,np
       g%v(i)=one.mono.i
       do j=np+1,nt
          t=g%v(j).d.i
          g%v(i)=g%v(i)+(one.mono.j)*t
       enddo
    enddo
    CALL KILL(t)

    g=g.oo.(-1)
    tpsafit=zero
    tpsafit(1:nt)=g

    SET_TPSAFIT=.true.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(eq)

  end subroutine lattice_fit_CHROM_gmap

  subroutine lattice_fit_CHROM_gmap2(R,my_state,EPSF,POLY,NPOLY,TARG,np,n_extra,mf)
    IMPLICIT NONE
    integer ipause, mypause
    TYPE(layout),target, intent(inout):: R
    TYPE(POL_BLOCK), intent(inout),dimension(:)::POLY
    INTEGER, intent(in):: NPOLY,np
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6),co
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer ::  neq,no=3,nt,j,it,n_extra,mf
    type(damap) id
    type(vecresonance) vr
    type(pbresonance) fr
    type(gmap) g
    TYPE(TAYLOR)t
    real(dp) epsf,epsr,epsnow,CHROM(2)
    integer, allocatable:: res(:,:),jt(:),je(:)
    real(dp), allocatable :: mat(:,:),v0(:)
    integer kb,kbmax,kpos,npi,ier


    neq=2
    allocate(res(n_extra,4))
    allocate(jt(5))
    res=0
    do i=1,n_extra
       read(mf,*) res(i,:)
    enddo
    !    EPSF=.0001
    epsr=abs(epsf)
    neq=neq+2*n_extra

    allocate(eq(neq))

    nt=neq+np
    allocate(mat(nt,nt),v0(nt))

    kbmax=0

    DO I=1,NPOLY
       if(POLY(i)%nb>kbmax)  kbmax= POLY(i)%nb
    ENDDO
    SET_TPSAFIT=.FALSE.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO


    it=0
100 continue
    it=it+1
    mat=zero
    v0=zero
    do i=1,np
       mat(i,i)=one
    enddo

    do kb=1,kbmax
       STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)

       DO I=1,NPOLY
          if(POLY(i)%nb==kb) then
             npi=POLY(i)%np
             kpos=POLY(i)%g-1
             exit
          endif
       ENDDO

       write(6,*) " np in batch ",kb," = ",npi
       !         pause 1

       CLOSED(:)=zero

       CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
       write(6,*) "closed orbit ", CHECK_STABLE
       write(6,*) CLOSED


       CALL INIT(STATE,no,NPi,BERZ)
       nb_=kb
       CALL ALLOC(NORM)
       CALL ALLOC(Y)
       CALL ALLOC(EQ)
       call alloc(id)
       call alloc(vr)
       call alloc(fr)

       id=1
       Y=CLOSED+id

       CALL TRACK(R,Y,1,+STATE)
       NORM=Y
       vr=norm%a%nonlinear
       fr=norm%a%pb
       !    call print(vr%cos%v(2),6)
       !    call print(vr%sin%v(2),6)
       !    pause 1
       ! call print(fr%cos,6)
       ! call print(fr%sin,6)
       ! pause 2


       write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2), CHECK_STABLE
       CHROM(1)=(NORM%dhdj%v(1)).SUB.'00001'
       CHROM(2)=(NORM%dhdj%v(2)).SUB.'00001'
       write(6,*) " CHROM ",CHROM

       eq(1)=       ((NORM%dhdj%v(1)).par.'00001')-targ(1)
       eq(2)=       ((NORM%dhdj%v(2)).par.'00001')-targ(2)
       do i=1,n_extra
          jt=0
          jt(1:4)=res(i,:)
          jt(1)=jt(1)-1
          eq(2+2*i-1)=       ((vr%cos%v(2)).par.jt)
          eq(2+2*i)=       ((vr%sin%v(2)).par.jt)
       enddo

       epsnow=zero
       do i=1,neq
          epsnow=abs(eq(i))+epsnow
          if(kb==1) then
             co=eq(i)
             if(i<=2) then
                co=co+targ(i)
             endif
             write(6,*) i,co
          endif
       enddo
       write(6,*) "epsnow ", epsnow
       ipause=mypause(123)
       call kanalnummer(SCRATCHFILE)
       OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
       rewind scratchfile
       allocate(je(c_%nv))
       !    write(6,*) nt,neq,np,kpos,npi
       je=0
       do i=1,neq
          eq(i)=eq(i)<=c_%npara
          v0(i+np)=-(eq(i).sub.'0')
          do j=1,npi
             je(j)=1
             co=eq(i).sub.je
             mat(np+i,j+kpos)=co
             mat(j+kpos,np+i)=co
             je(j)=0
          enddo
       enddo
       deallocate(je)
       do i=1,neq
          call daprint(eq(i),scratchfile)
       enddo
       close(SCRATCHFILE)
       CALL KILL(NORM)
       CALL KILL(Y)
       CALL KILL(id)
       CALL KILL(vr)
       CALL KILL(fr)
       CALL KILL(EQ)
       !    pause 888
    enddo ! kbmax
    write(6,*) "Iteration # ",it

    !    pause 2000
    !    do i=1,nt
    !    do j=1,nt
    !    if(mat(i,j)/=zero) write(6,*) i,j,mat(i,j)
    !    enddo
    !    enddo
    call  matinv(mat,mat,nt,nt,ier)
    if(ier/=0 ) then
       write(6,*) ier
       write(6,*) " inversion error "

       stop
    endif
    !    pause 2001

    v0=matmul(mat,v0)
    tpsafit=zero
    tpsafit(1:nt)=v0

    SET_TPSAFIT=.true.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(mat)
    deallocate(eq)
    deallocate(res)
    deallocate(jt)

  end subroutine lattice_fit_CHROM_gmap2

  subroutine lattice_fit_CHROM_gmap1(R,my_state,EPSF,POLY,NPOLY,TARG,NP,n_extra,mf)
    IMPLICIT NONE
    integer ipause, mypause
    TYPE(layout),target, intent(inout):: R
    TYPE(POL_BLOCK), intent(inout),dimension(:)::POLY
    INTEGER, intent(in):: NPOLY,NP
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer :: neq=2, no=3,nt,j,it,n_extra,mf
    type(damap) id
    type(vecresonance) vr
    type(pbresonance) fr
    type(gmap) g
    TYPE(TAYLOR)t
    real(dp) epsf,epsr,epsnow,CHROM(2)
    integer, allocatable:: res(:,:),jt(:)

    neq=2

    allocate(res(n_extra,4))
    allocate(jt(5))
    res=0
    do i=1,n_extra
       read(mf,*) res(i,:)
    enddo
    !    EPSF=.0001
    epsr=abs(epsf)
    neq=neq+2*n_extra
    allocate(eq(neq))

    nt=neq+np
    STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)

    !    CALL INIT(STATE,no,NP,BERZ)

    !    SET_TPSAFIT=.FALSE.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    CLOSED(:)=zero
    it=0
100 continue
    it=it+1

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit ", CHECK_STABLE
    write(6,*) CLOSED


    CALL INIT(STATE,no,NP,BERZ)
    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(EQ)
    call alloc(id)
    call alloc(vr)
    call alloc(fr)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,+STATE)
    NORM=Y
    vr=norm%a%nonlinear
    fr=norm%a%pb
    !    call print(vr%cos%v(2),6)
    !    call print(vr%sin%v(2),6)
    !    pause 1
    call print(fr%cos,6)
    call print(fr%sin,6)
    ipause=mypause(2)


    write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2), CHECK_STABLE
    CHROM(1)=(NORM%dhdj%v(1)).SUB.'00001'
    CHROM(2)=(NORM%dhdj%v(2)).SUB.'00001'
    write(6,*) " CHROM ",CHROM

    eq(1)=       ((NORM%dhdj%v(1)).par.'00001')-targ(1)
    eq(2)=       ((NORM%dhdj%v(2)).par.'00001')-targ(2)
    do i=1,n_extra
       jt=0
       jt(1:4)=res(i,:)
       jt(1)=jt(1)-1
       eq(2+2*i-1)=       ((vr%cos%v(2)).par.jt)
       eq(2+2*i)=       ((vr%sin%v(2)).par.jt)
    enddo

    epsnow=zero
    do i=1,neq
       epsnow=abs(eq(i))+epsnow
    enddo
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile

    do i=1,neq
       eq(i)=eq(i)<=c_%npara
    enddo
    do i=1,neq
       call daprint(eq(i),scratchfile)
    enddo
    close(SCRATCHFILE)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(id)
    CALL KILL(vr)
    CALL KILL(fr)
    CALL KILL(EQ)



    CALL INIT(1,nt)
    call alloc(g,nt)
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile
    do i=np+1,nt
       call read(g%v(i),scratchfile)
    enddo
    close(SCRATCHFILE)

    call alloc(t)
    do i=1,np
       g%v(i)=one.mono.i
       do j=np+1,nt
          t=g%v(j).d.i
          g%v(i)=g%v(i)+(one.mono.j)*t
       enddo
    enddo
    CALL KILL(t)

    g=g.oo.(-1)
    tpsafit(1:nt)=g

    SET_TPSAFIT=.true.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    ipause=mypause(777)
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(eq)
    deallocate(res)
    deallocate(jt)

  end subroutine lattice_fit_CHROM_gmap1

  subroutine lattice_fit_tune_CHROM_gmap(R,my_state,EPSF,POLY,NPOLY,TARG,NP)
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    TYPE(POL_BLOCK), intent(inout),dimension(:)::POLY
    INTEGER, intent(in):: NPOLY,NP
    real(dp) , intent(IN),dimension(:)::TARG
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    INTEGER I,SCRATCHFILE, MF
    TYPE(TAYLOR), allocatable:: EQ(:)
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    integer :: neq=4, no=3,nt,j,it
    type(damap) id
    type(gmap) g
    TYPE(TAYLOR)t
    real(dp) epsf,epsr,epsnow,tune(2),CHROM(2),gam(2)
    !    EPSF=.0001
    epsr=abs(epsf)

    allocate(eq(neq))

    nt=neq+np
    STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)

    CALL INIT(STATE,no,NP,BERZ)

    SET_TPSAFIT=.FALSE.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    CLOSED(:)=zero
    it=0
100 continue
    it=it+1

    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit ", CHECK_STABLE
    write(6,*) CLOSED


    CALL INIT(STATE,no,NP,BERZ)
    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(EQ)
    call alloc(id)

    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,+STATE)
    NORM=Y
    gam(1)=(norm%a_t%v(2).sub.'1')**2+(norm%a_t%v(2).sub.'01')**2
    gam(2)=(norm%a_t%v(4).sub.'001')**2+(norm%a_t%v(4).sub.'0001')**2
    write(6,*) "  Gamma= ",GAM
    !      CALL KANALNUMMER(MF)
    OPEN(UNIT=1111,FILE='GAMMA.TXT')
    WRITE(1111,*) "  Gamma= ",GAM

    write(6,*) " tunes ",NORM%TUNE(1), NORM%TUNE(2), CHECK_STABLE
    tune(1)=(NORM%dhdj%v(1)).SUB.'0000'
    tune(2)=(NORM%dhdj%v(2)).SUB.'0000'
    CHROM(1)=(NORM%dhdj%v(1)).SUB.'00001'
    CHROM(2)=(NORM%dhdj%v(2)).SUB.'00001'
    write(6,*) " CHROM ",CHROM

    eq(1)=       ((NORM%dhdj%v(1)).par.'00000')-targ(1)
    eq(2)=       ((NORM%dhdj%v(2)).par.'00000')-targ(2)
    eq(3)=       ((NORM%dhdj%v(1)).par.'00001')-targ(3)
    eq(4)=       ((NORM%dhdj%v(2)).par.'00001')-targ(4)
    epsnow=abs(eq(1))+abs(eq(2))+abs(eq(3))+abs(eq(4))
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile

    do i=1,neq
       eq(i)=eq(i)<=c_%npara
    enddo
    do i=1,neq
       call daprint(eq(i),scratchfile)
    enddo
    close(SCRATCHFILE)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(id)
    CALL KILL(EQ)



    CALL INIT(1,nt)
    call alloc(g,nt)
    call kanalnummer(SCRATCHFILE)
    OPEN(UNIT=SCRATCHFILE,FILE='EQUATION.TXT')
    rewind scratchfile
    do i=np+1,nt
       call read(g%v(i),scratchfile)
    enddo
    close(SCRATCHFILE)

    call alloc(t)
    do i=1,np
       g%v(i)=one.mono.i
       do j=np+1,nt
          t=g%v(j).d.i
          g%v(i)=g%v(i)+(one.mono.j)*t
       enddo
    enddo
    CALL KILL(t)

    g=g.oo.(-1)
    tpsafit(1:nt)=g

    SET_TPSAFIT=.true.

    DO I=1,NPOLY
       R=POLY(i)
    ENDDO
    SET_TPSAFIT=.false.

    CALL ELP_TO_EL(R)

    !    write(6,*) " more "
    !    read(5,*) more
    if(it>=max_fit_iter) goto 101
    if(epsnow<=epsr) goto 102
    GOTO 100

101 continue
    write(6,*) " warning did not converge "

102 continue
    CALL KILL_PARA(R)
    deallocate(eq)

  end subroutine lattice_fit_tune_CHROM_gmap


  subroutine lattice_PRINT_RES_FROM_A(R,my_state,NO,EMIT0,MRES,FILENAME)
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    real(dp) CLOSED(6)
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    TYPE(REAL_8) Y(6)
    TYPE(NORMALFORM) NORM
    type(damap) id
    TYPE(PBresonance)Hr
    CHARACTER(*) FILENAME
    REAL(DP) PREC,EMIT0(2),STR
    INTEGER NO,MF,MRES(4)

    PREC=c_1d_10

    STATE=((((my_state+nocavity0)-delta0)+only_4d0)-RADIATION0)



    CALL FIND_ORBIT(R,CLOSED,1,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED


    CALL INIT(STATE,no,0,BERZ)

    CALL ALLOC(NORM)
    CALL ALLOC(Y)
    CALL ALLOC(hr)
    call alloc(id)    ! LOOK AT PAGE 143 OF THE BOOK
    id=1
    Y=CLOSED+id

    CALL TRACK(R,Y,1,STATE)


    NORM=Y


    hr=NORM%a%pb

    CALL KANALNUMMER(MF)

    OPEN(UNIT=MF,FILE=FILENAME)

    CALL PRINT(HR%COS,6,PREC)
    CALL PRINT(HR%SIN,6,PREC)
    STR=(HR%COS%H.SUB.MRES)**2+(HR%SIN%H.SUB.MRES)**2; STR=SQRT(STR)
    WRITE(6,*) "RESONANCE = ",MRES,STR
    WRITE(MF,*) "RESONANCE = ",MRES,STR
    CALL PRINT(HR%COS,MF,PREC)
    CALL PRINT(HR%SIN,MF,PREC)
    WRITE(MF,*) " SCALE AT EMIT = ",EMIT0
    ID=1
    ID%V(1)=ID%V(1)*SQRT(EMIT0(1))
    ID%V(2)=ID%V(2)*SQRT(EMIT0(1))
    ID%V(3)=ID%V(3)*SQRT(EMIT0(2))
    ID%V(4)=ID%V(4)*SQRT(EMIT0(2))
    HR%COS%H=HR%COS%H*ID
    HR%SIN%H=HR%SIN%H*ID
    CALL PRINT(HR%COS,MF,PREC)
    CALL PRINT(HR%SIN,MF,PREC)


    CLOSE(MF)
    CALL KILL(NORM)
    CALL KILL(Y)
    CALL KILL(hr)

  end subroutine lattice_PRINT_RES_FROM_A

  !          call lattice_random_error(my_ring,name,i1,i2,cut,n,addi,integrated,cn,cns,sc)

  subroutine lattice_random_error(R,nom,i1,i2,cut,n,addi,integrated,cn,cns,per)
    use gauss_dis
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    integer n,addi,ic,i,i1,i2,j
    character(nlp) nom
    type(fibre), pointer :: p
    logical(lp) integrated,f1,f2
    real(dp) x,bn,cn,cns,cut,per

    if(i1>i2) then
       Write(6,*) " error i1 > i2 ",i1,i2
       return
    elseif(i2>nlp)then
       Write(6,*) " error i2 > nlp ",i2,nlp
       return
    endif

    call context(nom)

    ic=0
    p=>r%start
    do i=1,r%n
       f1=.false.
       f2=.false.
       if(i1>=0) then
          f1=(p%mag%name(i1:i2)==nom(i1:i2))
       else
          f1=(p%mag%name ==nom )
       endif


       if(f1) then
          call GRNF(X,cut)
          bn=cns+cn*x
          if(integrated.and.p%mag%p%ld/=zero) then
             bn=bn/p%mag%l
          endif
          if(bn/=zero) call add(p,n,addi,bn)
          f2=.true.
       endif

       if(f1.and.per/=zero ) then
          call GRNF(X,cut)
          do j=p%mag%p%nmul,1,-1
             !        if(n>0) then
             bn=p%mag%bn(j)
             bn=bn*(one+x*per)
             call add(p,j,0,bn)
             !        else
             bn=p%mag%an(j)
             bn=bn*(one+x*per)
             !        endif
             call add(p,-j,0,bn)

          enddo
          f2=.true.
       endif
       if(f2) ic=ic+1
       p=>P%next
    enddo

    write(6,*) ic," Magnets modified "

  end  subroutine lattice_random_error

  subroutine toggle_verbose
    implicit none
    verbose=.not.verbose
  end   subroutine toggle_verbose





  ! linked

  SUBROUTINE FIND_ORBIT_LAYOUT(RING,FIX,LOC,STATE,TURNS)  ! Finds orbit with TPSA in State or compatible state
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: RING
    INTEGER, OPTIONAL:: TURNS
    real(dp)  FIX(6),DIX(6),xdix,xdix0,tiny,freq
    TYPE(REAL_8) X(6)
    TYPE(DAMAP) MX,SX,SXI,IS
    integer NO1,ND2,I,IU,LOC,ITE,npara
    TYPE(INTERNAL_STATE),optional, intent(in) :: STATE
    TYPE(INTERNAL_STATE) stat
    TYPE (fibre), POINTER :: C
    logical(lp)  c_da,s_da
    INTEGER TURNS0
    s_da=c_%stable_da
    c_da=c_%check_da
    !   APERTURE=c_%APERTURE_FLAG

    !  c_%APERTURE_FLAG=.false.
    c_%stable_da=.true.
    c_%check_da=.true.
    TURNS0=1
    freq=zero
    IF(PRESENT(TURNS)) TURNS0=TURNS
    Nullify(C);
    if(.not.ring%closed) then
       w_p=0
       w_p%nc=1
       w_p%fc='((1X,a72))'
       w_p%c(1)= " This line is not ring : FIND_ORBIT_LAYOUT "
       ! call !write_e(100)
    endif
    dix(:)=zero
    tiny=c_1d_40
    xdix0=c_1d4*DEPS_tracking
    NO1=1

    if(.not.present(STATE)) then
       IF(default%NOCAVITY) THEN
          !    ND1=2
          stat=default+only_4d-spin0
       ELSE
          !   ND1=3
          STAT=default-spin0
          C=>RING%START
          do i=1,RING%n
             if(C%magp%kind==kind4.OR.C%magp%kind==kind21) goto 101
             C=>C%NEXT
          enddo
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72,/),(1X,a72))'
          w_p%c(1)=  " No Cavity in the Line "
          w_p%c(2)=  " FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(111)
       ENDIF
    else
       IF(STATE%NOCAVITY) THEN
          !    ND1=2
          STAT=STATE+only_4d0-spin0
       ELSE
          !   ND1=3
          STAT=STATE-spin0
          C=>RING%START
          do i=1,RING%n
             if(C%magp%kind==kind4.OR.C%magp%kind==kind21) goto 101
             C=>C%NEXT
          enddo
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72,/),(1X,a72))'
          w_p%c(1)=  " No Cavity in the Line "
          w_p%c(2)=  " FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(112)
       ENDIF
    endif
101 continue
    !    ND2=2*ND1
    if(stat%totalpath==1.and.(.not.stat%nocavity)) then
       C=>RING%START
       freq=zero
       i=1
       xdix=zero
       do while(i<=RING%n)
          if(associated(c%magp%freq)) then
             IF(FREQ==ZERO) THEN
                freq=c%magp%freq
             ELSEIF(c%magp%freq/=ZERO.AND.c%magp%freq<FREQ) THEN
                freq=c%magp%freq
             ENDIF
          endif
          IF(stat%TIME) THEN
             XDIX=XDIX+c%mag%P%LD/c%BETA0
          ELSE
             XDIX=XDIX+c%mag%P%LD
          ENDIF
          c=>c%next
          i=i+1
       enddo
       if(freq==zero) then
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72,/),(1X,a72))'
          w_p%c(1)=  " No Cavity in the Line or Frequency = 0 "
          w_p%c(2)=  " FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(113)
       endif
       IF(RING%HARMONIC_NUMBER>0) THEN
          FREQ=RING%HARMONIC_NUMBER*CLIGHT/FREQ
          stop 475
       ELSE
          XDIX=XDIX*FREQ/CLIGHT
          FREQ=NINT(XDIX)*CLIGHT/FREQ
       ENDIF
    endif
    CALL INIT(STAT,NO1,0,BERZ,ND2,NPARA)

    !  call init(NO1,ND1,0,0,.TRUE.)


    CALL ALLOC(X,6)
    CALL ALLOC(MX)
    CALL ALLOC(SX)
    CALL ALLOC(SXI)
    CALL ALLOC(IS)


3   continue
    X=NPARA
    DO I=1,6
       X(I)=FIX(I)
    ENDDO

    DO I=1,TURNS0
       CALL TRACK(RING,X,LOC,STAT)
       if(.not.check_stable.or.(.not.c_%stable_da)) then
          CALL KILL(X,6)
          CALL KILL(MX)
          CALL KILL(SX)
          CALL KILL(SXI)
          CALL KILL(IS)
          w_p=0
          w_p%nc=1
          w_p%fc='((1X,a72))'
          write(w_p%c(1),'(a30,i4)') " Lost in Fixed Point Searcher ",1
          messagelost(len_trim(messagelost)+1:255)=" -> Lost in Fixed Point Searcher "
          ! call ! WRITE_I

          return
       endif
    ENDDO
    x(6)=x(6)-TURNS0*freq

    IS=1
    MX=X
    SX=MX-IS
    DIX=SX
    DO I=1,ND2
       DIX(I)=FIX(I)-DIX(I)
    enddo
    IS=0
    IS=DIX

    SXI=SX**(-1)
    SX=SXI.o.IS
    DIX=SX
    DO  I=1,ND2
       FIX(I)=FIX(I)+DIX(I)
    ENDDO

    xdix=zero
    do iu=1,ND2
       xdix=abs(dix(iu))+xdix
    enddo
    w_p=0
    w_p%nc=1
    w_p%fc='((1X,a72))'
    if(verbose) write(w_p%c(1),'(a22,g21.14)') " Convergence Factor = ",xdix
    !    if(verbose) ! call ! WRITE_I
    if(xdix.gt.deps_tracking) then
       ite=1
    else
       if(xdix.ge.xdix0.or.xdix<=tiny) then
          ite=0
       else
          ite=1
          xdix0=xdix
       endif
    endif
    if(ite.eq.1)  then
       GOTO 3

    endif
    CALL KILL(X,6)
    CALL KILL(MX)
    CALL KILL(SX)
    CALL KILL(SXI)
    CALL KILL(IS)
    c_%check_da=c_da
    !  c_%APERTURE_FLAG=APERTURE
    c_%stable_da=s_da

    !  write(6,*) " 2 ",APERTURE,APERTURE_FLAG

  END SUBROUTINE FIND_ORBIT_LAYOUT


  SUBROUTINE FIND_ORBIT_LAYOUT_noda(RING,FIX,LOC,STATE,eps,TURNS) ! Finds orbit without TPSA in State or compatible state
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: RING
    real(dp) , intent(inOUT) :: FIX(6)
    INTEGER , intent(in) :: LOC
    INTEGER, OPTIONAL::TURNS
    real(dp) , optional,intent(in) :: eps
    TYPE(INTERNAL_STATE),optional, intent(in) :: STATE
    TYPE(INTERNAL_STATE) stat

    real(dp)  DIX(6),xdix,xdix0,tiny,freq
    real(dp) X(6),Y(6),MX(6,6),sxi(6,6),SX(6,6)
    integer NO1,ND2,I,IU,ITE,ier,j,ITEM
    TYPE (fibre), POINTER :: C
    logical(lp) APERTURE
    INTEGER TURNS0,trackflag
    TURNS0=1
    trackflag=0
    IF(PRESENT(TURNS)) TURNS0=TURNS
    freq=zero
    APERTURE=c_%APERTURE_FLAG
    c_%APERTURE_FLAG=.false.

    if(.not.present(eps)) then
       if(.not.present(STATE)) then
          call FIND_ORBIT_LAYOUT(RING,FIX,LOC,TURNS=TURNS0)
       else
          call FIND_ORBIT_LAYOUT(RING,FIX,LOC,STATE,TURNS=TURNS0)
       endif
       c_%APERTURE_FLAG=APERTURE
       return
    endif


    Nullify(C);

    if(.not.ring%closed) then
       w_p=0
       w_p%nc=1
       w_p%fc='((1X,a72))'
       w_p%c(1)=" This line is not ring : FIND_ORBIT_LAYOUT_noda "
       ! call !write_e(100)
    endif
    dix(:)=zero
    tiny=c_1d_40
    xdix0=c_1d4*DEPS_tracking
    NO1=1
    if(.not.present(STATE)) then
       IF(default%NOCAVITY) THEN
          !    ND1=2
          stat=default+    only_4d-spin0
       ELSE
          !   ND1=3
          STAT=default-spin0
          C=>RING%START
          do i=1,RING%n
             if(C%magp%kind==kind4.OR.C%magp%kind==kind21) goto 101
             C=>C%NEXT
          enddo
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72))'
          w_p%c(1)=" No Cavity in the Line "
          w_p%c(2)=" FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(101)
       ENDIF
    else
       IF(STATE%NOCAVITY) THEN
          ND2=4
          STAT=STATE+only_4d0-spin0
       ELSE
          ND2=6
          STAT=STATE-spin0
          C=>RING%START
          do i=1,RING%n
             if(C%magp%kind==kind4.OR.C%magp%kind==kind21) goto 101
             C=>C%NEXT
          enddo
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72))'
          w_p%c(1)=" No Cavity in the Line "
          w_p%c(2)=" FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(112)
       ENDIF
    endif
101 continue


    if(stat%totalpath==1.and.(.not.stat%nocavity)) then
       C=>RING%START
       freq=zero
       i=1
       xdix=zero
       do while(i<=RING%n)
          if(associated(c%magp%freq)) then
             IF(FREQ==ZERO) THEN
                freq=c%magp%freq
             ELSEIF(c%magp%freq/=ZERO.AND.c%magp%freq<FREQ) THEN
                freq=c%magp%freq
             ENDIF
          endif
          XDIX=XDIX+c%mag%P%LD/c%BETA0
          c=>c%next
          i=i+1
       enddo
       if(freq==zero) then
          w_p=0
          w_p%nc=2
          w_p%fc='((1X,a72,/),(1X,a72))'
          w_p%c(1)=  " No Cavity in the Line or Frequency = 0 "
          w_p%c(2)=  " FIND_ORBIT_LAYOUT will crash "
          ! call !write_e(113)
       endif
       IF(RING%HARMONIC_NUMBER>0) THEN
          FREQ=RING%HARMONIC_NUMBER*CLIGHT/FREQ
       ELSE
          XDIX=XDIX*FREQ/CLIGHT
          FREQ=NINT(XDIX)*CLIGHT/FREQ
       ENDIF
    endif



    ITEM=0
3   continue
    ITEM=ITEM+1
    X=FIX

    DO I=1,TURNS0
       !       CALL TRACK(RING,X,LOC,STAT)
       call TRACK(RING,X,LOC,STAT)
       if(.not.check_stable) then
          messagelost(len_trim(messagelost)+1:255)=" -> Unstable tracking guessed orbit "
          c_%APERTURE_FLAG=APERTURE
          return
       endif
       !       if(.not.check_stable) then
       !          w_p=0
       !          w_p%nc=1
       !          w_p%fc='((1X,a72))'
       !          write(w_p%c(1),'(a30,i4)') " Lost in Fixed Point Searcher ",2
       !          ! call ! WRITE_I

       !          return
       !       endif

    ENDDO
    !    write(6,*) x
    x(6)=x(6)-freq*turns0

    mx=zero
    DO J=1,ND2

       Y=FIX
       Y(J)=FIX(J)+EPS
       DO I=1,TURNS0
          CALL TRACK(RING,Y,LOC,STAT)
          if(.not.check_stable) then
             messagelost(len_trim(messagelost)+1:255)=" -> Unstable tracking small rays around the guessed orbit "
             !   fixed_found=my_false
             c_%APERTURE_FLAG=APERTURE
             return
          endif
       ENDDO
       y(6)=y(6)-freq*turns0

       do i=1,ND2
          MX(I,J)=(Y(i)-X(i))/eps
       enddo

    ENDDO


    SX=MX;
    DO I=1,nd2   !  6 before
       SX(I,I)=MX(I,I)-one
    ENDDO

    DO I=1,ND2
       DIX(I)=FIX(I)-X(I)
    enddo

    CALL matinv(SX,SXI,ND2,6,ier)
    IF(IER==132)  then
       w_p=0
       w_p%nc=1
       w_p%fc='((1X,a72))'
       w_p%c(1)=" Inversion failed in FIND_ORBIT_LAYOUT_noda"
       ! call !write_e(333)
       return
    endif

    x=zero
    do i=1,nd2
       do j=1,nd2
          x(i)=sxi(i,j)*dix(j)+x(i)
       enddo
    enddo
    dix=x
    DO  I=1,ND2
       FIX(I)=FIX(I)+DIX(I)
    ENDDO

    xdix=zero
    do iu=1,ND2
       xdix=abs(dix(iu))+xdix
    enddo
    !    write(6,*) " Convergence Factor = ",nd2,xdix,deps_tracking
    !    pause 123321
    w_p=0
    w_p%nc=1
    w_p%fc='((1X,a72))'
    if(verbose)write(w_p%c(1),'(a22,g21.14)') " Convergence Factor = ",xdix
    !  if(verbose) ! call ! WRITE_I
    if(xdix.gt.deps_tracking) then
       ite=1
    else
       if(xdix.ge.xdix0.or.xdix<=tiny) then
          ite=0
       else
          ite=1
          xdix0=xdix
       endif
    endif

    if(iteM>=MAX_FIND_ITER)  then
       !   C_%stable_da=.FALSE.
       !      IF(iteM==MAX_FIND_ITER+100) THEN
       !        write(6,*) " Unstable in find_orbit without TPSA"
       messagelost= "Maximum number of iterations in find_orbit without TPSA"
       xlost=fix
       check_stable=my_false
       !     ENDIF
       ITE=0
    endif

    if(ite.eq.1)  then
       GOTO 3

    endif
    c_%APERTURE_FLAG=APERTURE

  END SUBROUTINE FIND_ORBIT_LAYOUT_noda


  SUBROUTINE fit_all_bends(r,state)
    IMPLICIT NONE
    TYPE(layout),target,INTENT(INOUT):: r
    TYPE(internal_state), intent(in):: state
    type(fibre),pointer :: p
    integer i

    p=>r%start

    do i=1,r%n
       if(p%mag%p%b0/=zero) call fit_bare_bend(p,state)
       p=>p%next
    enddo

  end SUBROUTINE fit_all_bends

  SUBROUTINE fit_bare_bend(f,state,next)
    IMPLICIT NONE
    TYPE(fibre),INTENT(INOUT):: f
    TYPE(real_8) y(6)
    TYPE(internal_state), intent(in):: state
    !    integer,optional,target :: charge
    real(dp) kf,x(6),xdix,xdix0,tiny
    integer ite
    logical(lp), optional :: next
    logical(lp) nex
    nex=my_false
    if(present(next)) nex=next
    tiny=c_1d_40
    xdix0=c_1d4*DEPS_tracking

    KF=ZERO   ;
    F%MAGP%BN(1)%KIND=3
    F%MAGP%BN(1)%I=1
    if(nex) then
       F%next%MAGP%BN(1)%KIND=3
       F%next%MAGP%BN(1)%I=1
    endif

    CALL INIT(1,1)

    CALL ALLOC(Y)

3   continue
    X=ZERO
    Y=X
    CALL TRACK(f,Y,+state)  !,CHARGE)
    if(nex) CALL TRACK(f%next,Y,+state)  !,CHARGE)
    x=y
    !    write(6,'(A10,6(1X,G14.7))') " ORBIT IS ",x
    kf=-(y(2).sub.'0')/(y(2).sub.'1')
    xdix=abs(y(2).sub.'0')
    f%MAGP%BN(1) = f%MAGP%BN(1)+KF
    f%MAG%BN(1) = f%MAG%BN(1)+KF
    if(nex) then
       f%next%MAGP%BN(1) = f%next%MAGP%BN(1)+KF
       f%next%MAG%BN(1) = f%next%MAG%BN(1)+KF
    endif

    CALL ADD(f,1,1,zero)     !etienne
    if(nex) CALL ADD(f%next,1,1,zero)     !etienne

    if(xdix.gt.deps_tracking) then
       ite=1
    else
       if(xdix.ge.xdix0.or.xdix<=tiny) then
          ite=0
       else
          ite=1
          xdix0=xdix
       endif
    endif
    if(ite.eq.1) GOTO 3

    F%MAGP%BN(1)%KIND=1
    F%MAGP%BN(1)%I=0
    if(nex) then
       F%next%MAGP%BN(1)%KIND=1
       F%next%MAGP%BN(1)%I=0
    endif
    !    write(6,'(A10,1(1X,g14.7))') " BN(1) IS ",    f%MAG%BN(1)


    CALL KILL(Y)


  end SUBROUTINE fit_bare_bend

  SUBROUTINE  track_aperture(r,my_state,beta,dbeta,tuneold,ib,ITMAX,emit0,aper,pos,nturn,FILENAME,FILEtune,FILESMEAR,resmax)
    IMPLICIT NONE
    TYPE(INTERNAL_STATE), intent(IN):: my_STATE
    TYPE(INTERNAL_STATE) STATE
    TYPE(layout),target, intent(inout) :: R
    REAL(DP), pointer :: BETA(:,:,:)
    integer pos,nturn,i,flag,ib,MF,mft,j,resmax,it,I1,no
    real(dp) closed(6),MAT(6,6),AI(6,6),A(6,6),emit(2),emit0(6),aper(2),x(6),xn(6),dbeta,tuneold(:)
    real(dp) ra(2),tunenew(2),xda(lnv)
    CHARACTER(*) FILENAME,FILEtune,FILESMEAR
    real(dp), allocatable :: dat(:,:),dats(:,:),SMEAR(:,:)
    REAL(DP) JMin(2),JMAX(2), tune1(2),tune2(2),tot_tune(2),epsi,scas(2),scau,scat(2)
    integer itmax
    type(damap) id
    type(tree) monkey



    epsi=one/nturn
    STATE=((((my_state+nocavity0)+delta0)+only_4d0)-RADIATION0)
    allocate(dat(0:nturn,6),dats(0:nturn,6))
    allocate(SMEAR(ITMAX,8))
    CLOSED=ZERO

    call FILL_BETA(r,my_state,pos,BETA,IB,DBETA,tuneold,tunenew,a,ai,mat,closed)
    write(6,*) " *****************************************************************"
    write(6,*) "        Tracking with Normalized Aperture "
    write(6,*) "        Tunes = ",tunenew(1:2)
    if(pos==0) then
       write(6,*) " give no "
       read(5,*) no
       call init(no,2,0,0)
       call alloc(id); call alloc(monkey)
       call kanalnummer(mf)
       open(unit=mf,file='map.dat')
       call read(id,mf)
       id=closed
       monkey=id
       call kill(id)
       close(mf)
       xda=zero
    endif
    scau=one
    scas=zero
    dats=zero
    SMEAR=ZERO
    it=0
    CALL KANALNUMMER(MFt)
    OPEN(UNIT=MFt,FILE=FILEtune)
1001 continue
    it=it+1
    write(6,*) " iteration ",it
    IF(IT==ITMAX+1) GOTO 1002

    scat(1)=(emit0(1)+ it*emit0(3))/aper(1)
    scat(2)=(emit0(2)+ it*emit0(6))/aper(2)
    !    scat=(scau+scas)/two    ! etienne
    dat=zero

    xn=zero
    JMAX=ZERO
    JMIN=mybig
    emit=scat*aper
    write(6,*) " %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    write(6,*) " Initial emit = ", emit(1:2)," scale = ",scat
    write(6,*) " %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    xn(2)=sqrt(emit(1))
    xn(4)=sqrt(emit(2))
    X=zero

    x=matmul(a,xn)+closed

    WRITE(6,*) " INITIAL X"
    WRITE(6,200) X
    !    x=zero
    !    x(1)=xn(2)/sqrt(a(2,1)**2+a(2,2)**2)
    !    x(3)=xn(4)/sqrt(a(4,3)**2+a(4,4)**2)
    ! Etienne

    dat(0,1:4)=xn(1:4)
    ra(1)=xn(1)**2+xn(2)**2
    ra(2)=xn(3)**2+xn(4)**2
    dat(0,5:6)=ra(1:2)

    flag=0
    do i=1,nturn

       if(pos/=0) then
          flag=track_flag(r,x,pos,state)
       else
          flag=0
          xda(1:4)=x(1:4)
          xda=monkey*xda
          x(1:4)=xda(1:4)
       endif
       write(80,*) x(1:4)
       if(flag/=0) exit
       xn=matmul(ai,(x-closed))
       ra(1)=xn(1)**2+xn(2)**2
       ra(2)=xn(3)**2+xn(4)**2
       IF(RA(1)>JMAX(1)) JMAX(1)=RA(1)
       IF(RA(2)>JMAX(2)) JMAX(2)=RA(2)
       IF(RA(1)<JMIN(1)) JMIN(1)=RA(1)
       IF(RA(2)<JMIN(2)) JMIN(2)=RA(2)
       if(ra(1)>aper(1)) then
          flag=101
          exit
       endif
       if(ra(2)>aper(2)) then
          flag=102
          exit
       endif
       dat(i,1:4)=xn(1:4)
       dat(i,5:6)=ra(1:2)
    enddo
    WRITE(6,*) "     MAXIMUM RADIUS SQUARE = ",JMAX
    WRITE(6,*) "      MAXIMUM/INITIAL = ",JMAX(1:2)/emit(1:2)
    WRITE(6,*) "     MINIMUM RADIUS SQUARE = ",JMIN
    WRITE(6,*) "      MINIMUM/INITIAL = ",JMIN(1:2)/emit(1:2)
    WRITE(6,*) "     SMEAR = ",TWO*(JMAX-JMIN)/(JMAX+JMIN)
    SMEAR(IT,1:2)=EMIT(1:2)
    SMEAR(IT,3:4)=JMIN(1:2)
    SMEAR(IT,5:6)=JMAX(1:2)
    SMEAR(IT,7:8)=TWO*(JMAX-JMIN)/(JMAX+JMIN)
    if(flag/=0)then
       ! scau=scat
       IF(fLAG==101) THEN
          write(6,*)  "          UNSTABLE AT X-NORMALIZED APERTURE "
          !   write(mf,*) "UNSTABLE AT X-NORMALIZED APERTURE "
       ELSEIF(FLAG==102) THEN
          !   write(mf,*) "UNSTABLE AT Y-NORMALIZED APERTURE "
          write(6,*) "          UNSTABLE AT Y-NORMALIZED APERTURE "
       ELSE
          !   write(mf,*) "UNSTABLE: DYNAMIC APERTURE "
          write(6,*) "          UNSTABLE: DYNAMIC APERTURE "
       ENDIF
       goto 1002  ! etienne
       if(abs(scau-scas(1))<=emit0(3)) then
          goto 1002
       else
          goto 1001
       endif
    ELSE
       write(6,*) "          STABLE "

       !       write(6,*) "tunes of the ray " ,tot_tune(1:2)
       WRITE(6,201) EMIT,APER, TUNEnew(1:2),DBETA

       scas=scat
       dats=dat

       !  RESONANCE
       tot_tune=zero
       xn(1:4)=dats(0,1:4)
       tune1(1)=atan2(-xn(2),xn(1))/twopi
       tune1(2)=atan2(-xn(4),xn(3))/twopi
       if(tune1(1)<zero)  tune1(1)=tune1(1)+one
       if(tune1(2)<zero)  tune1(2)=tune1(2)+one
       DO I1=0,NTURN
          xn(1:4)=dats(i1,1:4)
          tune2(1)=atan2(-xn(2),xn(1))/twopi
          tune2(2)=atan2(-xn(4),xn(3))/twopi
          if(tune2(1)<zero)  tune2(1)=tune2(1)+one
          if(tune2(2)<zero)  tune2(2)=tune2(2)+one
          tune1=tune2-tune1
          if(tune1(1)<zero)  tune1(1)=tune1(1)+one
          if(tune1(2)<zero)  tune1(2)=tune1(2)+one
          tot_tune =tot_tune+tune1
          tune1=tune2
       ENDDO
       tot_tune=tot_tune/nturn
       do i1=0,resmax
          do j=-resmax,resmax
             dbeta=i1*tot_tune(1)+j*tot_tune(2)
             if(abs(dbeta-nint(dbeta))<epsi ) then
                if(i1+j/=0) write(6,*) i1,j,dbeta," <--- here "
             else
                if(i1+j/=0) write(6,*)i1,j,dbeta
             endif
          enddo
       enddo
       write(mft,*) " emit = ",emit(1:2)
       write(mft,*) " tunes = ",tot_tune(1:2)
       do i=0,resmax
          do j=-resmax,resmax
             dbeta=i*tot_tune(1)+j*tot_tune(2)
             if(abs(dbeta-nint(dbeta))<epsi ) then
                if(i+j/=0) write(mft,*) i,j,dbeta," <--- here "
             else
                if(i+j/=0) write(mft,*)i,j,dbeta
             endif
          enddo
       enddo
       !     PAUSE 100
       ! END  RESONANCE



       if(abs(scau-scas(1))<=emit0(3)) then
          goto 1002
       else
          goto 1001
       endif

    ENDIF


1002 continue
    CALL KANALNUMMER(MF)

    OPEN(UNIT=MF,FILE=FILENAME)

    WRITE(MF,201) EMIT,APER, TUNEnew(1:2),DBETA
    tot_tune=zero
    xn(1:4)=dats(0,1:4)
    tune1(1)=atan2(-xn(2),xn(1))/twopi
    tune1(2)=atan2(-xn(4),xn(3))/twopi
    if(tune1(1)<zero)  tune1(1)=tune1(1)+one
    if(tune1(2)<zero)  tune1(2)=tune1(2)+one

    DO I=0,NTURN
       WRITE(MF,200)DATs(I,1:6)
       xn(1:4)=dats(i,1:4)
       tune2(1)=atan2(-xn(2),xn(1))/twopi
       tune2(2)=atan2(-xn(4),xn(3))/twopi
       if(tune2(1)<zero)  tune2(1)=tune2(1)+one
       if(tune2(2)<zero)  tune2(2)=tune2(2)+one
       tune1=tune2-tune1
       if(tune1(1)<zero)  tune1(1)=tune1(1)+one
       if(tune1(2)<zero)  tune1(2)=tune1(2)+one
       tot_tune =tot_tune+tune1
       tune1=tune2
    ENDDO
    tot_tune=tot_tune/nturn
    CLOSE(MF)

    CLOSE(mft)

    CALL KANALNUMMER(MF)
    OPEN(UNIT=MF,FILE=FILESMEAR)
    WRITE(MF,*) " ITERATION   EMIT0(1:2)  JMIN(1:2) JMAX(1:2) TWO*(JMAX-JMIN)/(JMAX+JMIN)"
    DO I=1,ITMAX
       WRITE(MF,202)I, SMEAR(I,1:8)
    ENDDO

    CLOSE(mf)

    emit0(1:2) =scas*aper
    emit0(4:5)=tunenew(1:2)

202 FORMAT(1X,I4,8(1X,D18.11))
201 FORMAT(9(1X,D18.11))
200 FORMAT(6(1X,D18.11))
    deallocate(dat,dats,SMEAR)
    WRITE(6,*) "     MAXIMUM RADIUS SQUARE = ",JMAX
    WRITE(6,*) "      MAXIMUM/INITIAL = ",JMAX(1:2)/emit(1:2)
    WRITE(6,*) "     MINIMUM RADIUS SQUARE = ",JMIN
    WRITE(6,*) "      MINIMUM/INITIAL = ",JMIN(1:2)/emit(1:2)
    WRITE(6,*) "     SMEAR = ",TWO*(JMAX-JMIN)/(JMAX+JMIN)
    write(6,*) " *****************************************************************"
    if(pos==0) call kill(monkey)
  end SUBROUTINE  track_aperture


  SUBROUTINE  THIN_LENS_resplit(R,THIN,even,lim,lmax0,xbend,sexr,fib,useknob) ! A re-splitting routine
    IMPLICIT NONE
    INTEGER NTE
    TYPE(layout),target, intent(inout) :: R
    real(dp), OPTIONAL, intent(inout) :: THIN
    real(dp), OPTIONAL, intent(in) :: lmax0
    real(dp), OPTIONAL, intent(in) ::xbend
    real(dp), OPTIONAL, intent(in) ::sexr
    type(fibre), OPTIONAL, target :: fib
    logical(lp), OPTIONAL :: useknob
    real(dp) gg,RHOI,XL,QUAD,THI,lm,dl,ggbt,xbend1,gf(7),sexr0,quad0
    INTEGER M1,M2,M3, MK1,MK2,MK3,limit(2),parity,inc,nst_tot,ntec,ii,metb,sexk
    integer incold ,parityold
    integer, optional :: lim(2)
    logical(lp) MANUAL,eject,doit,DOBEND
    TYPE (fibre), POINTER :: C
    logical(lp),optional :: even
    type(layout), pointer :: L
    logical f1,f2

    sexr0=zero


    if(present(sexr)) sexr0=sexr

    f1=.false.
    f2=.false.

    if(associated(r%parent_universe)) then
       f1=.true.
       l=>r%parent_universe%start
       do ii=1,r%parent_universe%n
          call kill(l%t)
          l=>l%next
       enddo
    elseif(associated(r%t)) then
       call kill(r%t)
       f2=.true.
    endif
    !    logical(lp) doneit
    nullify(C)
    parity=0
    inc=0
    lm=1.0e38_dp
    ntec=0
    max_ds=zero
    xbend1=-one

    if(present(xbend)) xbend1=xbend
    if(present(lmax0)) lm=abs(lmax0)
    if(present(even)) then
       inc=1
       if(even) then
          parity=0
       else
          parity=1
       endIf
    endif
    parityold=parity
    incold=inc
    !   CALL LINE_L(R,doneit)

    MANUAL=.FALSE.
    eject=.FALSE.

    THI=R%THIN
    IF(PRESENT(THIN)) THI=THIN

    IF(THI<=0) MANUAL=.TRUE.


    IF(MANUAL) THEN
       write(6,*) "thi: thin lens factor (THI<0 TO STOP), sextupole factor and Bend factor "
       read(5,*) thi,sexr0,xbend1
       IF(THI<0) eject=.true.
    ENDIF

1001 CONTINUE

    limit(1)=4
    limit(2)=18
    if(present(lim)) limit=lim
    if(sixtrack_compatible) then
       limit(1)=1000000
       limit(2)=1000001
    endif
    !    limit0(1)=limit(1)
    !    limit0(2)=limit(2)

    M1=0
    M2=0
    M3=0
    MK1=0
    MK2=0
    MK3=0
    r%NTHIN=0
    nst_tot=0
    sexk=0
    C=>R%START
    do  ii=1,r%n    ! WHILE(ASSOCIATED(C))
       doit=(C%MAG%KIND==kind1.or.C%MAG%KIND==kind2.or.C%MAG%KIND==kind4.or.C%MAG%KIND==kind5)
       doit=DOIT.OR.(C%MAG%KIND==kind6.or.C%MAG%KIND==kind7)
       DOIT=DOIT.OR.(C%MAG%KIND==kind10.or.C%MAG%KIND==kind16)
       DOIT=DOIT.OR.(C%MAG%KIND==kind17)
       doit=doit.and.C%MAG%recut

       if(doit) then
          select case(C%MAG%P%METHOD)
          CASE(2)
             M1=M1+1
             MK1=MK1+C%MAG%P%NST
          CASE(4)
             M2=M2+1
             MK2=MK2+3*C%MAG%P%NST
          CASE(6)
             M3=M3+1
             MK3=MK3+7*C%MAG%P%NST
          END SELECT
          r%NTHIN=r%NTHIN+1   !C%MAG%NST
       endif
       NST_tot=NST_tot+C%MAG%P%nst

       C=>C%NEXT

    enddo
    write(6,*) "Previous of cutable Elements ",r%NTHIN
    write(6,*) "METHOD 2 ",M1,MK1
    write(6,*) "METHOD 4 ",M2,MK2
    write(6,*) "METHOD 6 ",M3,MK3
    write(6,*)   "number of Slices ", MK1+MK2+MK3
    write(6,*)   "Total NST ", NST_tot

    if(eject) then
       !      limit(1)=limit0(1)
       !      limit(2)=limit0(2)
       return
    endif
    M1=0
    M2=0
    M3=0
    MK1=0
    MK2=0
    MK3=0
    ! CAVITY FOCUSING
    ! TEAPOT SPLITTING....
    ggbt=zero
    r%NTHIN=0
    r%THIN=THI

    nst_tot=0
    C=>R%START
    do  ii=1,r%n    ! WHILE(ASSOCIATED(C))
       doit=.true.
       if(present(useknob)) then
          if(useknob) then
             doit=c%magp%knob
          else
             doit=.not.c%magp%knob
          endif
       endif
       if(present(fib)) then
          doit=associated(c,fib)
       endif
       if(.not.doit) then
          NST_tot=NST_tot+C%MAG%P%nst
          if(c%mag%even) then
             parity=parityold
             inc=incold
          endif
          C=>C%NEXT
          cycle
       endif

       if(c%mag%even) then
          parity=0
          inc=1
       endif


       !       if(doit)  then

       select case(resplit_cutting)

       case(0)

          doit=(C%MAG%KIND==kind1.or.C%MAG%KIND==kind2.or.C%MAG%KIND==kind4.or.C%MAG%KIND==kind5)
          doit=DOIT.OR.(C%MAG%KIND==kind6.or.C%MAG%KIND==kind7)
          DOIT=DOIT.OR.(C%MAG%KIND==kind10.or.C%MAG%KIND==kind16)
          DOIT=DOIT.OR.(C%MAG%KIND==kind17)
          doit=doit.and.C%MAG%recut
          if(doit) then
             xl=C%MAG%L
             RHOI=zero
             QUAD=zero
             QUAD0=zero
             IF(C%MAG%P%NMUL>=1) THEN
                !               RHOI=C%MAG%P%B0
                RHOI=abs(C%MAG%bn(1))+abs(C%MAG%an(1))
             endif
             IF(C%MAG%P%NMUL>=2) THEN
                QUAD=SQRT(C%MAG%BN(2)**2+C%MAG%AN(2)**2)
                IF(C%MAG%P%NMUL>=3) THEN
                 quad0=SQRT(C%MAG%BN(3)**2+C%MAG%AN(3)**2)*sexr0
                 QUAD=QUAD+quad0
                endif
             ELSE
                QUAD=zero
             ENDIF
             if(C%MAG%KIND==kind5.or.C%MAG%KIND==kind17) then
                quad=quad+(C%MAG%b_sol)**2/four+abs(C%MAG%b_sol/two)
             endif

             DOBEND=MY_FALSE
             IF(xbend1>ZERO) THEN
                IF(C%MAG%KIND==kind10) THEN
                   IF(C%MAG%TP10%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                IF(C%MAG%KIND==kind16.OR.C%MAG%KIND==kind20) THEN
                   IF(C%MAG%K16%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                if(rhoi/=zero.and.radiation_bend_split)DOBEND=MY_TRUE
             ENDIF
             !  ETIENNE
             GG=XL*(RHOI**2+ABS(QUAD))
             GG=GG/THI
             NTE=INT(GG)
             sexk=sexk+xl*ABS(QUAD0)/thi
             metb=0
             if(dobend) then
                call check_bend(xl,gg,rhoi,xbend1,gf,metb)
                if(gf(metb)>gg) then
                   gg=gf(metb)
                   NTE=INT(GG)
                   ggbt=ggbt+NTE
                else
                   metb=0
                endif
             endif


             IF(NTE.LT.limit(1).or.metb==2) THEN
                M1=M1+1
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=2
                MK1=MK1+NTE
             ELSEIF((NTE.GE.limit(1).AND.NTE.LT.limit(2)).or.metb==4) THEN
                M2=M2+1
                NTE=NTE/3
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=4
                MK2=MK2+NTE*3
             ELSEIF(NTE.GE.limit(2).or.metb==6) THEN
                M3=M3+1
                NTE=NTE/7
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=6
                MK3=MK3+NTE*7
             ENDIF

             r%NTHIN=r%NTHIN+1  !C%MAG%NST
             !         write(6,*)"nte>ntec", nte,ntec
             call add(C%MAG,C%MAG%P%nmul,1,zero)
             call COPY(C%MAG,C%MAGP)
             if(gg>zero) then
                if(c%mag%l/c%mag%p%nst>max_ds) max_ds=c%mag%l/c%mag%p%nst
             endif

          endif  ! doit

       case(1)

          doit=(C%MAG%KIND==kind1.or.C%MAG%KIND==kind2.or.C%MAG%KIND==kind4.or.C%MAG%KIND==kind5)
          doit=DOIT.OR.(C%MAG%KIND==kind6.or.C%MAG%KIND==kind7)
          DOIT=DOIT.OR.(C%MAG%KIND==kind10.or.C%MAG%KIND==kind16)
          DOIT=DOIT.OR.(C%MAG%KIND==kind17)
          doit=doit.and.C%MAG%recut

          if(doit) then
             xl=C%MAG%L
             RHOI=zero
             QUAD=zero
             QUAD0=zero
             IF(C%MAG%P%NMUL>=1) THEN
                !               RHOI=C%MAG%P%B0
                RHOI=abs(C%MAG%bn(1))+abs(C%MAG%an(1))
             endif
             IF(C%MAG%P%NMUL>=2) THEN
                QUAD=SQRT(C%MAG%BN(2)**2+C%MAG%AN(2)**2)
                IF(C%MAG%P%NMUL>=3) THEN
                 quad0=SQRT(C%MAG%BN(3)**2+C%MAG%AN(3)**2)*sexr0
                 QUAD=QUAD+quad0
                endif
             ELSE
                QUAD=zero
             ENDIF
             if(C%MAG%KIND==kind5.or.C%MAG%KIND==kind17) then
                quad=quad+(C%MAG%b_sol)**2/four+abs(C%MAG%b_sol/two)
             endif

             DOBEND=MY_FALSE
             IF(xbend1>ZERO) THEN
                IF(C%MAG%KIND==kind10) THEN
                   IF(C%MAG%TP10%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                IF(C%MAG%KIND==kind16.OR.C%MAG%KIND==kind20) THEN
                   IF(C%MAG%K16%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                if(rhoi/=zero.and.radiation_bend_split)DOBEND=MY_TRUE
             ENDIF
             !  ETIENNE
             GG=XL*(RHOI**2+ABS(QUAD))
             GG=GG/THI
             sexk=sexk+xl*ABS(QUAD0)/thi
             NTE=INT(GG)
             metb=0
             if(dobend) then
                call check_bend(xl,gg,rhoi,xbend1,gf,metb)
                if(gf(metb)>gg) then
                   gg=gf(metb)
                   NTE=INT(GG)
                   ggbt=ggbt+NTE
                else
                   metb=0
                endif
             endif


             IF(NTE.LT.limit(1).or.metb==2) THEN
                M1=M1+1
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=2
                MK1=MK1+NTE
             ELSEIF((NTE.GE.limit(1).AND.NTE.LT.limit(2)).or.metb==4) THEN
                M2=M2+1
                NTE=NTE/3
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=4
                MK2=MK2+NTE*3
             ELSEIF(NTE.GE.limit(2).or.metb==6) THEN
                M3=M3+1
                NTE=NTE/7
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=6
                MK3=MK3+NTE*7
             ENDIF


             r%NTHIN=r%NTHIN+1  !C%MAG%NST

             if(present(lmax0).and.c%mag%kind==kind1) then
                dl=(C%MAG%P%ld/C%MAG%P%nst)
                if(dl>lm*fuzzy_split) then
                   ntec=int(C%MAG%P%ld/lm)+1
                   if(mod(ntec,2)/=parity) ntec=ntec+inc
                   C%MAG%P%NST=ntec
                endif
             endif

             call add(C%MAG,C%MAG%P%nmul,1,zero)
             call COPY(C%MAG,C%MAGP)
             !             if(gg>zero) then
             if(c%mag%l/c%mag%p%nst>max_ds) max_ds=c%mag%l/c%mag%p%nst
             !             endif
          endif

       case(2)


          doit=(C%MAG%KIND==kind1.or.C%MAG%KIND==kind2.or.C%MAG%KIND==kind4.or.C%MAG%KIND==kind5)
          doit=DOIT.OR.(C%MAG%KIND==kind6.or.C%MAG%KIND==kind7)
          DOIT=DOIT.OR.(C%MAG%KIND==kind10.or.C%MAG%KIND==kind16)
          DOIT=DOIT.OR.(C%MAG%KIND==kind17)
          doit=doit.and.C%MAG%recut

          if(doit) then
             xl=C%MAG%L
             RHOI=zero
             QUAD=zero
             QUAD0=zero
             IF(C%MAG%P%NMUL>=1) THEN
                !               RHOI=C%MAG%P%B0
                RHOI=abs(C%MAG%bn(1))+abs(C%MAG%an(1))
             endif
             IF(C%MAG%P%NMUL>=2) THEN
                QUAD=SQRT(C%MAG%BN(2)**2+C%MAG%AN(2)**2)
                IF(C%MAG%P%NMUL>=3) THEN
                 quad0=SQRT(C%MAG%BN(3)**2+C%MAG%AN(3)**2)*sexr0
                 QUAD=QUAD+quad0
                endif
             ELSE
                QUAD=zero
             ENDIF
             if(C%MAG%KIND==kind5.or.C%MAG%KIND==kind17) then
                quad=quad+(C%MAG%b_sol)**2/four+abs(C%MAG%b_sol/two)
             endif

             DOBEND=MY_FALSE
             IF(xbend1>ZERO) THEN
                IF(C%MAG%KIND==kind10) THEN
                   IF(C%MAG%TP10%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                IF(C%MAG%KIND==kind16.OR.C%MAG%KIND==kind20) THEN
                   IF(C%MAG%K16%DRIFTKICK) THEN
                      DOBEND=MY_TRUE
                   ENDIF
                ENDIF
                if(rhoi/=zero.and.radiation_bend_split)DOBEND=MY_TRUE
             ENDIF
             !  ETIENNE
             GG=XL*(RHOI**2+ABS(QUAD))
             GG=GG/THI
             NTE=INT(GG)
             sexk=sexk+xl*ABS(QUAD0)/thi
             metb=0
             if(dobend) then
                call check_bend(xl,gg,rhoi,xbend1,gf,metb)
                if(gf(metb)>gg) then
                   gg=gf(metb)
                   NTE=INT(GG)
                   ggbt=ggbt+NTE
                else
                   metb=0
                endif
             endif


             IF(NTE.LT.limit(1).or.metb==2) THEN
                M1=M1+1
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=2
                MK1=MK1+NTE
             ELSEIF((NTE.GE.limit(1).AND.NTE.LT.limit(2)).or.metb==4) THEN
                M2=M2+1
                NTE=NTE/3
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=4
                MK2=MK2+NTE*3
             ELSEIF(NTE.GE.limit(2).or.metb==6) THEN
                M3=M3+1
                NTE=NTE/7
                IF(NTE.EQ.0) NTE=1
                if(mod(nte,2)/=parity) nte=nte+inc
                C%MAG%P%NST=NTE
                C%MAG%P%METHOD=6
                MK3=MK3+NTE*7
             ENDIF


             r%NTHIN=r%NTHIN+1  !C%MAG%NST
             !         write(6,*)"nte>ntec", nte,ntec
             if(nte>ntec.or.(.not.present(lmax0)) ) then
                call add(C%MAG,C%MAG%P%nmul,1,zero)
                call COPY(C%MAG,C%MAGP)
             endif
             !            if(gg>zero) then
             !               if(c%mag%l/c%mag%p%nst>max_ds) max_ds=c%mag%l/c%mag%p%nst
             !            endif

             if(present(lmax0)) then
                dl=(C%MAG%P%ld/C%MAG%P%nst)
                if(dl>lm*fuzzy_split.and.C%MAG%KIND/=kindpa) then
                   nte=int(C%MAG%P%ld/lm)+1
                   if(mod(nte,2)/=parity) nte=nte+inc
                   if(nte > C%MAG%P%NST ) then
                      C%MAG%P%NST=nte
                      call add(C%MAG,C%MAG%P%nmul,1,zero)
                      call COPY(C%MAG,C%MAGP)
                   endif

                elseif(dl>lm.and.C%MAG%KIND==kindpa) then
                   write(6,*) " Pancake cannot be recut "
                endif
             endif
             if(c%mag%l/c%mag%p%nst>max_ds) max_ds=c%mag%l/c%mag%p%nst


          endif

       case default
          stop 988
       end select


       !      endif
       NST_tot=NST_tot+C%MAG%P%nst
       if(c%mag%even) then
          parity=parityold
          inc=incold
       endif
       C=>C%NEXT

    enddo   !   end of do   WHILE


    write(6,*) "Present of cutable Elements ",r%NTHIN
    write(6,*) "METHOD 2 ",M1,MK1
    write(6,*) "METHOD 4 ",M2,MK2
    write(6,*) "METHOD 6 ",M3,MK3
    write(6,*)   "number of Slices ", MK1+MK2+MK3
    write(6,*)   "Total NST ", NST_tot
    if(radiation_bend_split) then
       write(6,*)   "Total NST due to Bend Closed Orbit ", int(ggbt)
       write(6,*)   "Restricted to method=2 for radiation or spin "
    else
       write(6,*)   "Total NST due to Bend Closed Orbit ", int(ggbt)
    endif
    write(6,*)   "Total NST due to Sextupoles ", sexk
    write(6,*)   "Biggest ds ", max_ds



    IF(MANUAL) THEN
       write(6,*) "thi: thin lens factor (THI<0 TO STOP), sextupole factor and Bend factor "
       read(5,*) thi,sexr0, xbend1
       IF(THI<0) THEN
          THI=R%THIN
          !          limit(1)=limit0(1)
          !          limit(2)=limit0(2)
          if(f1) then
             l=>r%parent_universe%start
             do ii=1,r%parent_universe%n
                call make_node_layout(l)
                l=>l%next
             enddo
          elseif(f2) then
             call make_node_layout(r)  !!! bug (l) was wrong
          endif
          RETURN
       ELSE
          GOTO 1001
       ENDIF
    ENDIF


    !    limit(1)=limit0(1)
    !    limit(2)=limit0(2)

    !    CALL RING_L(R,doneit)

  END SUBROUTINE  THIN_LENS_resplit



  SUBROUTINE  RECUT_KIND7_one(C,lmax0,drift,ido,idc) ! A re-splitting routine
    IMPLICIT NONE
    TYPE(layout),POINTER :: L
    real(dp) lmax0
    TYPE(FIBRE),target :: C
    INTEGER I,f0,ido,idc
    logical(lp) drift,doit
   
    if(associated(c%parent_layout)) then
       if(associated(c%parent_layout%parent_universe)) then
          l=>c%parent_layout%parent_universe%start
          do i=1,c%parent_layout%parent_universe%n
             call kill(l%t)
             l=>l%next
          enddo
       else
          call kill(c%parent_layout%t)
       endif
    endif
    if(drift.and.C%MAG%KIND==KIND1) then
       f0=nint(C%MAG%l/lmax0)
       if(f0==0) f0=1
       C%MAG%p%nst=f0
       C%MAGp%p%nst=C%MAG%p%nst
       call COPY(C%MAG,C%MAGP)
    endif
    if(mod(C%MAG%p%method,2)==0) then  !!!
       doit=C%MAG%KIND==KIND7.or.(C%MAG%KIND==KIND2.and.C%MAG%p%method==2)
       if(associated(C%MAG%K16)) then
          doit=(C%MAG%K16%DRIFTKICK.and.C%MAG%p%method==2)
       endif
       if(associated(C%MAG%TP10)) then
          doit=(C%MAG%TP10%DRIFTKICK.and.C%MAG%p%method==2)
       endif
       IF(doit) then
          ido=ido+1
          !         f0=nint(C%MAG%l/lmax0)
          f0=nint(C%MAG%l/lmax0/C%MAG%p%nst/2)
          if(C%MAG%p%method==6) f0=nint(C%MAG%l/lmax0/C%MAG%p%nst/4)
          if(f0==0) f0=1
          if(C%MAG%p%method==2) then
             C%MAG%p%nst=C%MAG%p%nst*f0*2
             C%MAGp%p%nst=C%MAG%p%nst
             C%MAG%p%method=1
             C%MAGp%p%method=1
          elseif(C%MAG%p%method==4) then
             C%MAG%p%nst=C%MAG%p%nst*f0*2
             C%MAGp%p%nst=C%MAG%p%nst
             C%MAG%p%method=3
             C%MAGp%p%method=3
          elseif(C%MAG%p%method==6) then
             C%MAG%p%nst=C%MAG%p%nst*f0*4
             C%MAGp%p%nst=C%MAG%p%nst
             C%MAG%p%method=5
             C%MAGp%p%method=5
          endif
          call add(C%MAG,C%MAG%P%nmul,1,zero)
          call COPY(C%MAG,C%MAGP)
          if(C%MAG%KIND==KIND7) then
             C%MAG%t7%f=f0
             C%MAGp%t7%f=f0
          elseif(associated(C%MAG%K16)) then
             C%MAG%K16%f=f0
             C%MAGp%K16%f=f0
          elseif(associated(C%MAG%TP10)) then
             C%MAG%TP10%f=f0
             C%MAGp%TP10%f=f0
          else
             C%MAG%k2%f=f0
             C%MAGp%k2%f=f0
          endif
       ENDIF
    else !!!
       idc=idc+1
       f0=nint(C%MAG%l/lmax0/C%MAG%p%nst)
       if(f0>=1) then
          C%MAG%p%nst=C%MAG%p%nst*f0
          C%MAGp%p%nst=C%MAG%p%nst
          call add(C%MAG,C%MAG%P%nmul,1,zero)
          call COPY(C%MAG,C%MAGP)
          if(C%MAG%KIND==KIND7) then
             C%MAG%t7%f=f0*C%MAG%t7%f
             C%MAGp%t7%f=C%MAG%t7%f
          elseif(associated(C%MAG%K16)) then
             C%MAG%K16%f=f0*C%MAG%K16%f
             C%MAGp%K16%f=C%MAG%K16%f
          elseif(associated(C%MAG%TP10)) then
             C%MAG%TP10%f=f0*C%MAG%TP10%f
             C%MAGp%TP10%f=C%MAG%TP10%f
          else
             C%MAG%k2%f=f0*C%MAG%k2%f
             C%MAGp%k2%f=C%MAG%k2%f
          endif
       endif
    endif !!!
  END SUBROUTINE  RECUT_KIND7_one


  SUBROUTINE  RECUT_KIND7(R,lmax0,drift) ! A re-splitting routine
    IMPLICIT NONE
    TYPE(layout),target, intent(inout) :: R
    real(dp) lmax0
    TYPE(FIBRE),POINTER :: C
    INTEGER I,ido,idc
    logical(lp) drift

    ido=0
    idc=0


    C=>R%START
    DO I=1,R%N
       call RECUT_KIND7_one(c,lmax0,drift,ido,idc)
       C=>C%NEXT
    ENDDO
    write(6,*) ido," elements changed to odd methods " 
    write(6,*) idc," elements only " 
  END SUBROUTINE  RECUT_KIND7

  SUBROUTINE  ADD_SURVEY_INFO(R) ! A re-splitting routine
    IMPLICIT NONE
    TYPE(layout),target, intent(inout) :: R
    TYPE(FIBRE),POINTER :: C
    INTEGER I
    real(dp) b1



    C=>R%START
    DO I=1,R%N
       if(C%mag%kind==kind3) then
          b1=C%mag%k3%thin_h_angle
          if(b1/=zero) then
             b1=b1/two
             C%mag%k3%patch=my_true
             C%magp%k3%patch=my_true
             c%patch%patch=3
             c%patch%A_d=0.d0
             c%patch%B_d=0.d0
             c%patch%A_ANG=0.d0
             c%patch%B_ANG=0.d0
             c%patch%A_ANG(2)=b1
             c%patch%B_ANG(2)=b1
          endif
       endif
       C=>C%NEXT
    ENDDO

  END SUBROUTINE  ADD_SURVEY_INFO



  SUBROUTINE  check_bend(xl,ggi,rhoi,xbend1,gf,met) ! A re-splitting routine
    IMPLICIT NONE
    real(dp) xl,gg,ggi,rhoi,ar,ggb,co(7),xbend1,gf(7)
    integer i,met

    gg=int(ggi)
    if(gg==0.d0) gg=1.d0
    co(3)=1.d0/6.0_dp
    co(5)=  0.2992989446749238e0_dp
    co(7)=0.2585213173527224e-1_dp
    ar=abs(rhoi)
    gf=zero
    !     do i=3,7,2
    !              ggb=((XL/gg) * ar)**(i)*(XL/gg)*co(i)  ! approximate residual orbit
    !              if(xbend1<ggb) then
    !                gf(i)=(ar**(i)*co(i)/xbend1)**(one/(i+one))*xl
    !              write(6,*) i,gf(i)
    !              pause
    !              endif
    !     enddo

    do i=3,7,2
       ggb=((XL/gg) * ar)**(i-1)*(XL/gg)*co(i)*twopi  ! approximate residual orbit
       !              if(xbend1<ggb) then
       gf(i)=(ar**(i-1)*co(i)/xbend1/twopi)**(one/(i+zero))*xl
       !              endif
    enddo
    gf(2)=gf(3)
    gf(4)=gf(5)*3
    gf(6)=gf(7)*7

    met=2

    if(gf(4)<gf(2)) met=4
    if(gf(6)<gf(4).and.gf(6)<gf(2)) met=6
    if(radiation_bend_split) met=2
    if(sixtrack_compatible) met=2

  end SUBROUTINE  check_bend

  SUBROUTINE  THIN_LENS_restart(R,fib,useknob) ! A re-splitting routine
    IMPLICIT NONE
    INTEGER NTE
    TYPE(layout),target, intent(inout) :: R
    INTEGER M1,M2,M3, MK1,MK2,MK3,nst_tot,ii  !,limit0(2)
    type(fibre), OPTIONAL, target :: fib
    logical(lp), OPTIONAL :: useknob
    logical(lp) doit
    TYPE (fibre), POINTER :: C
    TYPE (layout), POINTER :: l
    !    logical(lp) doneit
    nullify(C)

    !    CALL LINE_L(R,doneit)

    if(associated(r%parent_universe)) then
       l=>r%parent_universe%start
       do ii=1,r%parent_universe%n
          call kill(l%t)
          l=>l%next
       enddo
    else
       call kill(r%t)
    endif





    M1=0
    M2=0
    M3=0
    MK1=0
    MK2=0
    MK3=0


    r%NTHIN=0

    nst_tot=0
    C=>R%START
    do  ii=1,r%n    ! WHILE(ASSOCIATED(C))
       doit=.true.
       if(present(useknob)) then
          if(useknob) then
             doit=c%magp%knob
          else
             doit=.not.c%magp%knob
          endif
       endif
       if(present(fib)) then
          doit=associated(c,fib)
       endif
       if(.not.doit) then
          NST_tot=NST_tot+C%MAG%P%nst
          C=>C%NEXT
          cycle
       endif


       doit=(C%MAG%KIND==kind1.and.C%MAG%KIND==kind2.or.C%MAG%KIND==kind5.or.C%MAG%KIND==kind4)
       doit=DOIT.OR.(C%MAG%KIND==kind6.or.C%MAG%KIND==kind7)
       DOIT=DOIT.OR.(C%MAG%KIND==kind10.or.C%MAG%KIND==kind16)
       DOIT=DOIT.OR.(C%MAG%KIND==kind17)


       if(doit)  then

          M1=M1+1
          NTE=1
          C%MAG%P%NST=NTE
          MK1=MK1+NTE
          C%MAG%P%METHOD=2

          r%NTHIN=r%NTHIN+1  !C%MAG%NST

          call add(C%MAG,C%MAG%P%nmul,1,zero)
          call COPY(C%MAG,C%MAGP)
       else
          if(C%MAG%KIND/=kindpa) then
             C%MAG%P%NST=1
             if(associated(C%MAG%bn))call add(C%MAG,C%MAG%P%nmul,1,zero)
             call COPY(C%MAG,C%MAGP)
          endif
       endif

       NST_tot=NST_tot+C%MAG%P%nst
       C=>C%NEXT
    enddo


    write(6,*) "Present of cutable Elements ",r%NTHIN
    write(6,*) "METHOD 2 ",M1,MK1
    write(6,*) "METHOD 4 ",M2,MK2
    write(6,*) "METHOD 6 ",M3,MK3
    write(6,*)   "number of Slices ", MK1+MK2+MK3
    write(6,*)   "Total NST ", NST_tot



    !    CALL RING_L(R,doneit)

  END SUBROUTINE  THIN_LENS_restart


  SUBROUTINE  print_bn_an(r,n,title,filename)
    implicit none
    type(layout),target,intent(inout) ::r
    character(*) filename
    type(fibre),pointer ::p
    integer n,i,mf,j,ntot
    character(*) title

    ntot=0
    call kanalnummer(mf)
    open(unit=mf,file=filename)
    p=>r%start
    write(mf,'(a120)') title
    write(mf,*) n
    do i=1,r%n

       if(associated(p%mag%an)) then
          ntot=ntot+1
          write(mf,*) min(n,p%mag%p%nmul),p%mag%name
          do j=1,min(n,p%mag%p%nmul)
             write(mf,*)j,p%mag%bn(j),p%mag%an(j)
          enddo
       endif
       p=>p%next
    enddo


    close(mf)

    write(6,*) ntot," magnets settings saved to maximum order ",n

  end   SUBROUTINE  print_bn_an

  SUBROUTINE  read_bn_an(r,filename)
    implicit none
    type(layout),target,intent(inout) ::r
    character(*) filename
    type(fibre),pointer ::p
    integer n,i,mf,j,nt,jt,ntot
    character(nlp) nom
    character*120 title
    real(dp), allocatable :: an(:),bn(:)

    ntot=0
    call kanalnummer(mf)
    open(unit=mf,file=filename)

    p=>r%start
    read(mf,'(a120)') title
    write(6,'(a120)') title
    read(mf,*) n
    allocate(an(n),bn(n))
    an=zero;bn=zero;

    do i=1,r%n

       if(associated(p%mag%an)) then
          read(mf,*) nt,nom
          call context(nom)

          do j=1,nt
             read(mf,*)jt,bn(j),an(j)
          enddo

          ntot=ntot+1
          do j=nt,1,-1
             call ADD(p,j,0,bn(j))
             call ADD(p,-j,0,an(j))
          enddo
       endif  ! associated
       p=>p%next
    enddo

    write(6,*) ntot," magnets settings read"

    close(mf)
    deallocate(an,bn)

  end   SUBROUTINE  read_bn_an

  ! THIN LENS EXAMPLE

  SUBROUTINE assign_one_aperture(L,pos,kindaper,R,X,Y,dx,dy)
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: L
    integer pos,kindaper
    REAL(DP) R(:),X,Y,dx,dy
    type(fibre), pointer :: P

    call move_to(L,p,pos)

    if(.NOT.ASSOCIATED(P%MAG%p%aperture)) THEN
       call alloc(P%MAG%p%aperture)
       call alloc(P%MAGP%p%aperture)
    ENDIF
    if(kindaper/=0) then
       P%MAG%p%aperture%kind = kindaper
       P%MAGP%p%aperture%kind = kindaper
       P%MAG%p%aperture%r    = R
       P%MAG%p%aperture%x    = X
       P%MAG%p%aperture%y    = y
       P%MAG%p%aperture%dx    = dX
       P%MAG%p%aperture%dy    = dy
       P%MAGP%p%aperture%r    = R
       P%MAGP%p%aperture%x    = X
       P%MAGP%p%aperture%y    = y
       P%MAGP%p%aperture%dx    = dX
       P%MAGP%p%aperture%dy    = dy
    endif

  end SUBROUTINE assign_one_aperture

  SUBROUTINE TURN_OFF_ONE_aperture(R,pos)
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: R
    integer pos
    type(fibre), pointer :: P

    call move_to(r,p,pos)

    if(ASSOCIATED(P%MAG%p%aperture)) THEN
       P%MAG%p%aperture%kind = -P%MAG%p%aperture%kind
       P%MAGP%p%aperture%kind = P%MAG%p%aperture%kind
    ENDIF

  end SUBROUTINE TURN_OFF_ONE_aperture

  SUBROUTINE REVERSE_BEAM_LINE(R, changeanbn )
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: R
    integer J,I
    type(fibre), pointer :: P
    logical(lp), optional:: changeanbn
    logical(lp) changeanbn0

    changeanbn0=my_true
    if(present(changeanbn)) changeanbn0=changeanbn

    p=>r%start
    do i=1,r%n
       p%dir=-1
       if(changeanbn0) then
          if(associated(p%mag%an)) then
             do j=1,p%mag%p%nmul
                p%mag%bn(j)=-p%magp%bn(j)
                p%mag%an(j)=-p%magp%an(j)
                p%magp%bn(j)=-p%magp%bn(j)
                p%magp%an(j)=-p%magp%an(j)
             enddo
             if(abs(abs(p%mag%bn(1))-abs(p%mag%p%b0)).gt.c_1d_11.or. &
                  abs(p%mag%p%b0).lt.c_1d_11) then
                p%mag%bn(1)=-p%magp%bn(1)
                p%mag%an(1)=-p%magp%an(1)
                p%magp%bn(1)=-p%magp%bn(1)
                p%magp%an(1)=-p%magp%an(1)
             endif
             if(p%mag%p%nmul>0) call add(p,1,1,zero)
          endif
          if(associated(p%mag%volt)) p%mag%volt=-p%mag%volt
          if(associated(p%magp%volt)) p%magp%volt=-p%magp%volt
       endif
       P=>P%next
    ENDDO
  end SUBROUTINE REVERSE_BEAM_LINE

  SUBROUTINE PUTFRINGE(R, changeanbn )
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: R
    integer I
    type(fibre), pointer :: P
    logical(lp) changeanbn

    p=>r%start
    do i=1,r%n
       p%mag%PERMFRINGE =changeanbn
       p%magP%PERMFRINGE=changeanbn
       P=>P%next
    ENDDO
  end SUBROUTINE PUTFRINGE

  SUBROUTINE PUTbend_fringe(R, changeanbn )
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: R
    integer I
    type(fibre), pointer :: P
    logical(lp) changeanbn

    p=>r%start
    do i=1,r%n
    if(p%mag%p%b0/=zero) then
       p%mag%p%bend_fringe =changeanbn
       p%magp%p%bend_fringe =changeanbn
       write(6,*) P%mag%name, " changed to ",changeanbn
    endif
       P=>P%next
    ENDDO
  end SUBROUTINE PUTbend_fringe


  SUBROUTINE MESS_UP_ALIGNMENT(R,SIG,cut)
    use gauss_dis
    IMPLICIT NONE
    TYPE(LAYOUT),TARGET :: R
    integer J,I
    type(fibre), pointer :: P
    REAL(DP) SIG(:),X,MIS(6),cut


    p=>r%start
    do i=1,r%n

       IF(P%MAG%KIND/=KIND0.AND.P%MAG%KIND/=KIND1) THEN
          DO J=1,6
             call GRNF(X,cut)
             MIS(J)=X*SIG(J)
          ENDDO
          call MISALIGN_FIBRE(p,mis)
       ENDIF
       P=>P%NEXT
    ENDDO
  end SUBROUTINE MESS_UP_ALIGNMENT


  !          CALL MESS_UP_ALIGNMENT_name(my_ring,name,i1,i2,SIG,cut)

  subroutine MESS_UP_ALIGNMENT_name(R,nom,i1,i2,sig,cut)
    use gauss_dis
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    integer i1,i2,j,ic,i
    character(nlp) nom
    type(fibre), pointer :: p
    logical(lp) f1
    real(dp) cut,sig(6),mis(6),x,taxi(6)

    if(i1>i2) then
       Write(6,*) " error i1 > i2 ",i1,i2
       return
    elseif(i2>nlp) then
       Write(6,*) " error i2 > nlp ",i2,nlp
       return
    endif
    taxi=0.d0
    call context(nom)

    ic=0


    p=>r%start
    do i=1,r%n

       IF(P%MAG%KIND/=KIND0.AND.P%MAG%KIND/=KIND1) THEN
          f1=.false.
          if(i1>=0) then
             f1=(p%mag%name(i1:i2)==nom(i1:i2))
          else
             f1=(p%mag%name ==nom )
          endif
          if(f1) then
             ic=ic+1
             DO J=1,6
                call GRNF(X,cut)
                MIS(J)=X*SIG(J)
                taxi(j)=taxi(j)+abs(MIS(J))
             ENDDO
             call MISALIGN_FIBRE(p,mis)
          endif
       ENDIF
       P=>P%NEXT
    ENDDO

    write(6,*) ic," Magnets misaligned "
    taxi=taxi/ic

    write(6,'(a16,3(1x,E15.8))') "displacements = ",taxi(1:3)
    write(6,'(a16,3(1x,E15.8))') "rotations     = ",taxi(4:6)

  end  subroutine MESS_UP_ALIGNMENT_name

  subroutine Sigma_of_alignment(r,sig,ave)
    IMPLICIT NONE
    TYPE(layout),target, intent(inout):: R
    integer i,j,is(6)
    type(fibre), pointer :: p
    real(dp) sig(6),ave(6)
    character*23 lab(6)
    lab(1)=" Dx Average and Sigma  "
    lab(2)=" Dy Average and Sigma  "
    lab(3)=" Dz Average and Sigma  "
    lab(4)=" Dax Average and Sigma "
    lab(5)=" Day Average and Sigma "
    lab(6)=" Daz Average and Sigma "

    AVE=ZERO
    SIG=ZERO
    p=>r%start
    is=0
    do i=1,r%n
       do j=1,3
          if(p%chart%D_IN(j)/=zero) then
             is(j)=is(j)+1
             ave(j)=p%chart%D_IN(j)+ave(j)
             sig(j)=p%chart%D_IN(j)**2+sig(j)
          endif
       enddo
       do j=4,6
          if(p%chart%ANG_IN(j)/=zero) then
             is(j)=is(j)+1
             ave(j)=p%chart%ANG_IN(j)+ave(j)
             sig(j)=p%chart%ANG_IN(j)**2+sig(j)
          endif
       enddo
       p=>p%next
    enddo

    do i=1,6
       if(is(i)/=0) then
          ave(i)=ave(i)/is(i)
          sig(i)=sig(i)/is(i)
          sig(i)=sqrt(sig(i)-ave(i)**2)
          write(6,*) is(i), " Magnets misaligned "
          write(6,"(1x,a23,2(1x,E15.8))") lab(i),ave(i),sig(i)
       endif
    enddo

  end subroutine Sigma_of_alignment




  SUBROUTINE dyn_aper(L,x_in,n_in,ang_in,ang_out,del_in,dlam,pos,nturn,ite,state,mf)
    IMPLICIT NONE
    type(layout),target, intent(inout) :: L
    real(dp) x(6)
    REAL(DP) x_in,del_in,closed(6),r(6),rt(6)
    REAL(DP) lamT,lams,lamu,dlam,DLAMT,DX,ang,ang_in,ang_out
    integer pos,nturn,i,st,ite,ic,mf,n_in,j_in
    TYPE(INTERNAL_STATE) STATE
    !
    !    TYPE(REAL_8) Y(6)
    !    TYPE(DAMAP) ID
    !    TYPE(NORMALFORM) NORM

    closed=zero
    !    STATE=STATE+NOCAVITY0
    if(state%nocavity) closed(5)=del_in

    CALL FIND_ORBIT(L,CLOSED,pos,STATE,c_1d_5)
    write(6,*) "closed orbit "
    write(6,*) CLOSED
    write(mf,201) closed
    ang= (ang_out-ang_in)/n_in
    lamt=one
    do j_in=0,n_in

       x=zero
       x(1)=x_in*cos(j_in*ang+ang_in)
       x(3)=x_in*sin(j_in*ang+ang_in)
       x(5)=del_in


       dx=0.3_dp

       r=zero;rt=zero;
       lams=zero
       lamu=ZERO

       DLAMT=DX

       !    lamt=ONE
       ic=0
       do while(DLAMT>dlam.and.ic<ite)

          ic=ic+1
          R=ZERO;
          r(1:4)=lamt*x(1:4)
          if(state%nocavity) then
             rt=r+closed
          else
             rt=r+closed
             rt(5)=rt(5)+x(5)
          endif


          do i=1,nturn
             st=track_flag(L,rt,pos,state)
             if(st/=0) exit
          enddo

          if(st/=0) then
             lamu=lamt
             lamt=(lams+lamt)/two
          else
             lams=lamt
             IF(LAMU<DX) THEN
                lamt=DX+lamt
             ELSE
                lamt=(lamu+lamt)/two
             ENDIF
          endif
          DLAMT=sqrt(x(1)**2+x(3)**2)*ABS(LAMU-LAMS)
       enddo
       write(6,*) ic,(j_in*ang+ang_in)/twopi,lamS*x(1),lamS*x(3)

       write(mf,202) lamS*x(1),lamS*x(3),lamS*x(1)+closed(1),lamS*x(3)+closed(3),DLAMT
       lamt=lamt*0.8_dp
    enddo
201 FORMAT(6(1X,D18.11))
202 FORMAT(5(1X,D18.11))

  end SUBROUTINE dyn_aper



  SUBROUTINE dyn_aperalex(L,x_in,del_in,dx,dlam,pos,nturn,ite,state,mf,targ_tune,fixp)
    IMPLICIT NONE
    type(layout),target, intent(inout) :: L
    real(dp) x(6)
    REAL(DP) x_in,del_in,closed(6),r(6),rt(6),targ_tune(2)
    REAL(DP) lamT,lams,lamu,dlam,DLAMT,DX,ang,ang_in,ang_out
    integer pos,nturn,i,st,ite,ic,mf,n_in,j_in
    TYPE(INTERNAL_STATE) STATE
    logical(lp) fixp
    !
    !    TYPE(REAL_8) Y(6)
    !    TYPE(DAMAP) ID
    !    TYPE(NORMALFORM) NORM

    closed=zero
    !    STATE=STATE+NOCAVITY0

    !    if(state%nocavity)
    closed(5)=del_in
    if(fixp) then
       CALL FIND_ORBIT(L,CLOSED,pos,STATE,c_1d_5)
       write(6,*) "closed orbit "
       write(6,*) CLOSED
    else
       closed(1:4)=zero
       closed(6)=zero
    endif
    !    write(mf,201) closed
    n_in=1
    ang_in=pi/four
    ang_out=pi/four
    ang= (ang_out-ang_in)/n_in
    lamt=one
    j_in=0
    !  do j_in=0,n_in

    x=zero
    x(1)=x_in*cos(j_in*ang+ang_in)
    x(3)=x_in*sin(j_in*ang+ang_in)
    !       x(5)=del_in



    r=zero;rt=zero;
    lams=zero
    lamu=ZERO

    DLAMT=DX

    !    lamt=ONE
    ic=0
    do while(DLAMT>dlam.and.ic<ite)

       ic=ic+1
       R=ZERO;
       r(1:4)=lamt*x(1:4)
       if(state%nocavity) then
          if(fixp) then
             rt=r+closed
          else
             rt(1:4)=r(1:4)
             rt(6)=zero
             rt(5)=del_in
          endif
       else
          if(fixp) then
             rt=r+closed
             rt(5)=rt(5)+del_in
          else
             rt=r
             rt(5)=rt(5)+del_in
          endif
       endif

       !   write(6,*) rt
       do i=1,nturn
          st=track_flag(L,rt,pos,state)
          if(st/=0) exit
       enddo
       !   write(6,*) i,check_stable
       !   write(6,*) rt
       !   pause
       if(st/=0) then
          lamu=lamt
          lamt=(lams+lamt)/two
          !  write(mf,*) "unstable ",lamt

       else
          lams=lamt
          IF(LAMU<DX) THEN
             lamt=DX+lamt
          ELSE
             lamt=(lamu+lamt)/two
          ENDIF
          !  write(mf,*) "stable ",lamt

       endif
       DLAMT=sqrt(x(1)**2+x(3)**2)*ABS(LAMU-LAMS)
       !              write(mf,*) "dlamt ",dlamt,sqrt(x(1)**2+x(3)**2)

    enddo
    write(6,*) ic,lamS*x(1)   !,lamS*x(3),(j_in*ang+ang_in)/twopi

    write(mf,202) targ_tune,lamS*x(1)      !,lamS*x(3),lamS*x(1)+closed(1),lamS*x(3)+closed(3),DLAMT
    lamt=lamt*0.8_dp
    !    enddo
201 FORMAT(6(1X,D18.11))
202 FORMAT(3(1X,D18.11))

  end SUBROUTINE dyn_aperalex




end module S_fitting
