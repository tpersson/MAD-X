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

void fasttrack(void){
	int npart =32;
	double *x,*px,*y,*py,*ds,*dp;

	x      = mymalloc_atomic("particle vector", npart   * sizeof *x);
	px     = mymalloc_atomic("particle vector", npart   * sizeof *px);
	y      = mymalloc_atomic("particle vector", npart   * sizeof *y);
	py     = mymalloc_atomic("particle vector", npart   * sizeof *py);
	ds     = mymalloc_atomic("particle vector", npart   * sizeof *ds);
	dp     = mymalloc_atomic("particle vector", npart   * sizeof *dp);
	int nnode = current_sequ->n_nodes;
	int *elarray;
	double **attr;
	elarray      = mymalloc_atomic("element array", nnode   * sizeof *elarray);
	
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
			counter++;
		}
		else if(code == code_multipole){
			elarray[counter] = code_multipole;
			counter++;
		}
		else if(code == code_hkicker || code == code_vkicker || code == code_kicker ){
			elarray[counter] = code_kicker;
			//printf("kicker %d \n", elarray[counter]);
			counter++;
		}


		if (advance_node() == 0)  break;

	}

	for(int t=0; t<10000; t ++){
		int j=0;
		for(int i=0; i<counter; i++ ){

			switch(elarray[i]){
				case 1 :
					cdrift++;
      			break; /* optional */
				case 8 :
					cmulti++;
      			break; 
				case 15 :
					px[j] = px[j]+0.001;
					py[j] = py[j]+0.001;
					ckicker++;
      			break; /* optional */

			}
		}
	//printf("cooooounter  %d %d %d %d \n", counter, cdrift/1000000, cmulti/1000000, ckicker/1000000);
	}
	

}