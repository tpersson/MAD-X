#include "madx.h"


  int code_drift = 1;
  int code_rbend = 2;
  int code_sbend = 3;
  int code_matrix = 4;
  int code_quadrupole = 5;
  int code_sextupole = 6;
  int code_octupole = 7;
  int code_multipole = 8;
  int code_solenoid = 9;
  int code_hkicker = 14;
  int code_kicker = 15;
  int code_vkicker = 16;

  int j=0;
  double eps=1e-26;
void drift(int i, int j){
	l_pz = ldrift[i] / sqrt( 1 + 2*pt[j]*bet0i + pow(pt[j],2) - pow(px[j],2) - pow(py[j],2));
	px[j] = px[j] + l_pz*px[j];
	py[j] = py[j] + l_pz*py[j];
	dt[i] = dt[i] + bet0i*(ldrift[i] - (1 + bet0*pt[i]) * l_pz);
}
void ftmultipole(int i, int j){
 
  double ttt;
  double dbr = 0;
  double dbi = 0; //Has to be fixed 

  double dipr =  normal[i][0];
  double dipi =  skew[i][0];

  int nord = maxordv[i];
  double dxt[40];
  double dyt[40];
  double dx, dy;
    if (nord == 0) {
     dxt[j] = zero;
     dyt[j] = zero;
 	}    

 	else{
 		dxt[j] = normal[i][nord]*x[j] - skew[i][nord]*y[j];
 		dyt[j] = normal[i][nord]*y[j] + skew[i][nord]*x[j];
 	}

  		for(int iord=nord; iord>1; iord--){
           dx = dxt[j]/(iord+1) + normal[i][iord];
           dy = dyt[j]/(iord+1) + skew[i][iord];
           dxt[j] = dx*x[j] - dy*y[j];
           dyt[j] = dx*y[j] + dy*x[j];
   		}
     

     ttt = sqrt( one + two*pt[j]*bet0i + pow(pt[j],2) );
     px[j] = px[j] - (dbr + dxt[j] - dipr * (ttt - one));
     py[j] = py[j] + (dbi + dyt[j] - dipi * (ttt - one));
     dt[j] = dt[j] - (dipr*x[j] - dipi*y[j]) * ((one + bet0*pt[j])/ttt) * bet0i;
}

void fasttrack(void){
	bet0  = get_value("beam","beta");
  	bet0i = one / bet0;
	int npart =32;

	x      = mymalloc("particle vector", npart   * sizeof *x);
	px     = mymalloc("particle vector", npart   * sizeof *px);
	y      = mymalloc("particle vector", npart   * sizeof *y);
	py     = mymalloc("particle vector", npart   * sizeof *py);
	dt     = mymalloc("particle vector", npart   * sizeof *dt);
	pt     = mymalloc("particle vector", npart   * sizeof *pt);

	x[0] = px[0] = y[0]=py[0]=dt[0]=pt[0]=0;
	int nnode = current_sequ->n_nodes;
	
	elarray      = mymalloc("element array", nnode   * sizeof *elarray);
	nn           = mymalloc("element array", nnode   * sizeof *nn);
	ns           = mymalloc("element array", nnode   * sizeof *ns);
	ldrift       = mymalloc("drift array", nnode   * sizeof *ldrift);
	attr         = mymalloc("particle vector", nnode   * sizeof **attr);
	normal       = mymalloc("particle vector", nnode   * sizeof **normal);
	skew         = mymalloc("particle vector", nnode   * sizeof **skew);
	maxordv      = mymalloc("particle vector", nnode   * sizeof *maxordv);
    
    //*attr = (double **)malloc(nnode * sizeof(double *));
	for(int i=0; i < nnode; i++){ //can safely allocate this because mosts are drift..
		attr[i]  = mymalloc("particle vector", en_natrib   * sizeof *attr);
		normal[i]  = mymalloc("particle vector", 10   * sizeof *normal);
		skew[i]  = mymalloc("particle vector", 10   * sizeof *skew);
	}
	
	double code; 
	int counter = 0;
	int cdrift =0;
	int cmulti =0;
	int ckicker =0;
	restart_sequ();
	while(1){
		code    = node_value("mad8_type");
		if(code == code_drift){
			elarray[counter] = code_drift;
			ldrift[counter] = node_value("drift");
			counter++;
		}
		else if(code == code_multipole){
			 int maxorder;
			 int nord = 0;
			 maxorder = 0;
			 double f_errors [40];
			 int n_ferr = node_fd_errors(f_errors);
			 get_node_vector("knl",&nn[counter],normal[counter]);
			 get_node_vector("ksl",&ns[counter],skew[counter]);
			 if(nn[counter] > ns[counter]) maxorder=nn[counter];
			 if(nn[counter] < ns[counter]) maxorder=ns[counter];

			 if(n_ferr > maxorder) maxorder = n_ferr;

			 elarray[counter] = code_multipole;
			 for (int i=1; i < maxorder; i++){
			 	normal[counter][i] = normal[counter][i] + f_errors[2*i];
			 	skew[counter][i] = skew[counter][i] + f_errors[2*i+1];
			 	if (fabs(normal[counter][i])>eps || fabs(normal[counter][i])>eps) nord=i;
			 }
			 maxordv[counter]=nord;

			//printf("ordeerrrs %d %d \n ", nn[counter], ns[counter]);
			counter++;
		}
		else if(code == code_hkicker || code == code_vkicker || code == code_kicker ){
			elarray[counter] = code_kicker;
			//printf("kicker %d \n", elarray[counter]);
			attr[counter][en_hkick] = node_value("hkick");
			attr[counter][en_vkick] = node_value("vkick");
			counter++;
		}


		if (advance_node() == 0)  break;

	}

	for(int t=0; t<10000; t ++){
		j=0;
		for(int i=0; i<counter; i++ ){

			switch(elarray[i]){
				case 1 :
					//drift(i, j);
					//cdrift++;
      			break; /* optional */
				case 8 :
					ftmultipole(i,j);
					//cmulti++;
      			break; 
				case 15 :
					px[j] = px[j]+attr[counter][en_hkick];
					py[j] = py[j]+attr[counter][en_vkick];
					//ckicker++;
      			break; /* optional */

			}
		}
	//printf("cooooounter  %d %d %d %d \n", counter, cdrift/1000000, cmulti/1000000, ckicker/1000000);
	}
}

