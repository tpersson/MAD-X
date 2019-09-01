enum attrib_enum{en_hkick, en_vkick, en_natrib};

double l_pz, bet0, bet0i;

int *elarray, *ns, *nn, *maxordv;
double *ldrift;
double *x;
double *px;
double *y;
double *py;
double *pt;
double *dt;
double **attr;
double **normal;
double **skew;


void fasttrack(void);
void drift(int i, int j);
void ftmultipole(int i, int j);