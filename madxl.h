/* preparation of Touschek */
/* defined constants for word lengths etc. */
#define ALIGN_MAX 14        /* alignment error array length */
#define EFIELD_TAB 42       /* field error array length for ESAVE table */
#define FIELD_MAX 42        /* field error array length */
#define SEQ_DUMP_LEVEL 0    /* chooses amount of dumped output */
#define NAME_L 24           /* internal name length */
#define TITLE_SIZE 114      /* Size of the title for gnuplot ploting in tracking mode (ETDA 24/06/2004) */
#define PTC_NAMES_L 13      /* Number of ptc variables treated in select_ptc_normal (ETDA 10/11/2004)(FRS 06/12/2005) (FRS/VK 20/04/2006) */
#define MAX_ROWS 101        /* Initial size of ptc_normal table */
#define FNAME_L 240         /* for file names */
#define FREECODE 380226     /* check-code to avoid multiple "free" */
#ifdef _MEM_LEAKS
#define MTABLE_SIZE 1000000
int item_no=-1;
int* mtable[MTABLE_SIZE];
#endif
#define AUX_LG 10000        /* initial size for ancillary buffers */
#define INVALID 1.e20       /* used for erroneous value requests */
#define MAX_ITEM  1000      /* initial # of items in tok_list etc. */
#define MAX_D_ITEM 30000    /* initial storage size for doubles */
#define MAX_LINE 20000      /* max. input line length (has to stay fixed) */
#define MAX_LOOP 100        /* max. count for (possibly circular) calls */
#define MAX_COND 100        /* max. nesting level for "if" and "while" */
#define MAX_TYPE 11         /* for SXF output */
#define MAX_TAG 50          /* for SXF output */
#define CHAR_BUFF_SIZE 100000 /* size of dynamic char_buff members */
#define IN_BUFF_SIZE 500000 /* initial size of buffer for command groups */
#define LINE_FILL 240        /* max. line length -2 for "save" output */
#define LINE_F_MAD8 70      /* the same, for mad-8 format */
#define LINE_MAX 78         /* for SXF output */
#define MAX_RAND 1000000000 /* for random generator */
#define NR_RAND 55          /* for random generator */
#define NJ_RAND 24          /* for random generator */
#define ND_RAND 21          /* for random generator */
#define MATCH_WORK 10       /* no. of work spaces in matching */
#define USER_TABLE_LENGTH 100 /* initial length of user defined tables */
#define MAXARRAY 1000       /* max. length of apex tables in aperture module*/

/* IA */
#define E_D_MAX 500         /* max. length of extra displacement tables (per element) */
#define E_D_LIST_CHUNK 1000  /* chunk to allocate memory for extra displacement tables */


#define MADX_LONG      1
#define MADX_DOUBLE    2
#define MADX_STRING    3

#define MAX_TFS_ROW 2000  /* max. number of rows for SDDS  conversion */
#define MAX_TFS_COL 500   /* max. number of columns for SDDS conversion */

char* const functs[] = {"dummyfunction", "abs", "sqrt", "exp", "log", "log10",
                        "sin", "cos", "tan", "asin", "acos",
                        "atan", "sinh", "cosh", "tanh", "ranf",
                        "gauss", "tgauss", "table", "exist", "floor","frac",
                        ""}; /* keep "" ! */

const char op_string[] = "-+*/^";
char file_string[] = "file"; /* to avoid local in routine alias */

const int n_match = 17; /* # of match token lists in cmd_match_base */
const int s_match[] = /* position of first token of command below */
{0, 1, 4, 8, 13, 17, 22, 25, 29, 32, 36, 39, 43, 45, 48, 50, 52, 56};

const int t_match[] = /* order in which the commands are matched */
{0, 1, 16, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
const char* cmd_match_base[] =
{ /*  0 */ "@cmd",
  /*  1 */ "@name", ":", "@cmd",
  /*  2 */ "int", "const", "@name", "=",
  /*  3 */ "int", "const", "@name", ":", "=",
  /*  4 */ "real", "const", "@name", "=",
  /*  5 */ "real", "const", "@name", ":", "=",
  /*  6 */ "int", "@name", "=",
  /*  7 */ "int", "@name", ":", "=",
  /*  8 */ "real", "@name", "=",
  /*  9 */ "real", "@name", ":", "=",
  /* 10 */ "const", "@name", "=",
  /* 11 */ "const", "@name", ":", "=",
  /* 12 */ "@name", "=",
  /* 13 */ "@name", ":", "=",
  /* 14 */ "@name", ":",
  /* 15 */ "@name", "@name",
  /* 16 */ "shared", "@name", ":", "@cmd"};

/* aperture types and # of parameters, needed for twiss table */

char* aperture_types[] =
{
  "circle", "ellipse", "rectangle", "lhcscreen",
  "marguerite", "rectellipse", "racetrack",
  " "  /* blank terminates */
};

/*added 4, 3 and "racetrack" here, IW */

int aperture_npar[] =
{
  1, 2, 2, 3,
  2, 4, 3
};

/* table descriptors: type 1 = int, type 2 = double, type 3 = string;
   internally, however, int are stored as double */

int ap_table_types[] =
{
  3, 2, 2, 2, 3,
  2, 2, 2, 2,
  2, 2, 2,
  2, 2, 2, 2, 2, 2, 2,
  2, 2, 2
};

char* ap_table_cols[] =
{
  "name", "n1", "n1x_m", "n1y_m", "apertype",
  "aper_1", "aper_2", "aper_3", "aper_4",
  "rtol", "xtol", "ytol",
  "s", "betx", "bety", "dx", "dy", "x", "y",
  "on_ap", "on_elem", "spec",
  " "  /* blank terminates */
};

int survey_table_types[] =
{
  3, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  1, 1, 2
};

char* survey_table_cols[] =
{
  "name", "s", "l", "angle", "x",
  "y", "z", "theta", "phi", "psi", "globaltilt",
  "slot_id", "assembly_id", "mech_sep",
  " "  /* blank terminates */
};


int efield_table_types[] =
{
  3, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2
};

char* efield_table_cols[] =
{
  "name",
  "k0l", "k0sl", "k1l", "k1sl",
  "k2l", "k2sl", "k3l", "k3sl", "k4l",
  "k4sl", "k5l", "k5sl", "k6l", "k6sl",
  "k7l", "k7sl", "k8l", "k8sl", "k9l",
  "k9sl", "k10l", "k10sl", "k11l", "k11sl",
  "k12l", "k12sl", "k13l", "k13sl", "k14l",
  "k14sl", "k15l", "k15sl", "k16l", "k16sl",
  "k17l", "k17sl", "k18l", "k18sl", "k19l",
  "k19sl", "k20l", "k20sl",
  "dx", "dy", "ds", "dphi", "dtheta",
  "dpsi", "mrex", "mrey", "mredx", "mredy",
  "arex", "arey", "mscalx", "mscaly",
  " "  /* blank terminates */
};


char* sxf_table_names[] =
{
  "l","angle", "k0","k0s","k1","k1s",
  "e1","e2","k2","k2s","h1",
  "h2","hgap","fint","k3","k3s",
  "lrad","knl","ksl","ks","volt",
  "lag","harmon","betrf","pg",
  "shunt","tfill","eloss","ex","ey",
  "hkick","vkick","xsize","ysize","sigx",
  "sigy","xma","yma","charge",
  " " /* blank terminates */
};

int twiss_opt_end = 33; /* last column filled by twiss module */
int twiss_fill_end = 72; /* last standard column filled
                            by complete_twiss_table */
/* warning: modify routine complete_twiss_table in case of changes */
int twiss_table_types[] =
{
  3, 3, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2,
  1, 1, 2, 2, 3,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  /* delta_p dependency terms */
  2,2,2, /* beta11p, beta12p, beta13p */
  2,2,2, /* beta21p, beta22p, beta23p  */
  2,2,2, /* beta31p, beta32p, beta33p  */
  2,2,2, /* alfa11p, alfa12p, alfa13p */
  2,2,2, /* alfa21p, alfa22p, alfa23p */
  2,2,2, /* alfa31p, alfa32p, alfa33p */
  2,2,2, /* gama11p, gama12p, gama13p */
  2,2,2, /* gama21p, gama22p, gama23p */
  2,2,2, /* gama31p, gama32p, gama33p */
  /* end of delta_p dependency terms */
  2, 2, 2,
  2, 2, 2,
  2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2
};

char* twiss_table_cols[] =
{
  "name", "keyword", "s", "betx", "alfx",
  "mux", "bety", "alfy", "muy", "x",
  "px", "y", "py", "t", "pt",
  "dx", "dpx", "dy", "dpy", "wx",
  "phix", "dmux", "wy", "phiy", "dmuy",
  "ddx", "ddpx", "ddy", "ddpy", "r11",
  "r12", "r21", "r22", "energy", "l",
  "angle", "k0l", "k0sl", "k1l", "k1sl",
  "k2l", "k2sl", "k3l", "k3sl", "k4l",
  "k4sl", "k5l", "k5sl", "k6l", "k6sl",
  "k7l", "k7sl", "k8l", "k8sl", "k9l",
  "k9sl", "k10l", "k10sl", "ks", "hkick",
  "vkick", "tilt", "e1", "e2", "h1",
  "h2", "hgap", "fint", "fintx",
  "slot_id","assembly_id","mech_sep","lrad","parent",
  "re11", "re12", "re13", "re14", "re15", "re16",
  "re21", "re22", "re23", "re24", "re25", "re26",
  "re31", "re32", "re33", "re34", "re35", "re36",
  "re41", "re42", "re43", "re44", "re45", "re46",
  "re51", "re52", "re53", "re54", "re55", "re56",
  "re61", "re62", "re63", "re64", "re65", "re66",
  "kmax", "kmin", "calib", "polarity", "alfa",
  "beta11", "beta12", "beta13",
  "beta21", "beta22", "beta23",
  "beta31", "beta32", "beta33",
  "alfa11", "alfa12", "alfa13",
  "alfa21", "alfa22", "alfa23",
  "alfa31", "alfa32", "alfa33",
  "gama11", "gama12", "gama13",
  "gama21", "gama22", "gama23",
  "gama31", "gama32", "gama33",
  /* delta_p dependency: derivatives of the above Twiss parameters */
  "beta11p","beta12p","beta13p",
  "beta21p","beta22p","beta23p",
  "beta31p","beta32p","beta33p",
  "alfa11p", "alfa12p","alfa13p",
  "alfa21p", "alfa22p","alfa23p",
  "alfa31p", "alfa32p","alfa33p",
  "gama11p", "gama12p","alfa33p",
  "gama21p", "gama22p","gama23p",
  "gama31p", "gama32p","gama33p",
  /* end of delta_p dependency */
  "mu1", "mu2", "mu3",
  "disp1", "disp2", "disp3",
  "disp4", "disp5", "disp6",
  "eign11", "eign12", "eign13", "eign14", "eign15", "eign16",
  "eign21", "eign22", "eign23", "eign24", "eign25", "eign26",
  "eign31", "eign32", "eign33", "eign34", "eign35", "eign36",
  "eign41", "eign42", "eign43", "eign44", "eign45", "eign46",
  "eign51", "eign52", "eign53", "eign54", "eign55", "eign56",
  "eign61", "eign62", "eign63", "eign64", "eign65", "eign66",
  "n1",
  " "  /* blank terminates */
};

int twiss_sector_table_types[] = {
  3, 2,
  2, 2, 2, 2, 2, 2,
  /* 36 elements for the R-matrix */
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  /* 216 elements for the T-matrix */
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2
};

char* twiss_sector_table_cols[] = {
  "name", "pos",
  "k1", "k2", "k3", "k4", "k5", "k6",
  "r1", "r2", "r3", "r4", "r5", "r6", 
  "r7", "r8", "r9", "r10", "r11", "r12", 
  "r13", "r14", "r15", "r16", "r17", "r18", 
  "r19", "r20", "r21", "r22", "r23", "r24",
  "r25", "r26", "r27", "r28", "r29", "r30", 
  "r31", "r32", "r33", "r34", "r35", "r36",
  "t1", "t2", "t3", "t4", "t5", "t6", 
  "t7", "t8", "t9", "t10", "t11", "t12", 
  "t13", "t14", "t15", "t16", "t17", "t18", 
  "t19", "t20", "t21", "t22", "t23", "t24", 
  "t25", "t26", "t27", "t28", "t29", "t30", 
  "t31", "t32", "t33", "t34", "t35", "t36", 
  "t37", "t38", "t39", "t40", "t41", "t42", 
  "t43", "t44", "t45", "t46", "t47", "t48", 
  "t49", "t50", "t51", "t52", "t53", "t54", 
  "t55", "t56", "t57", "t58", "t59", "t60", 
  "t61", "t62", "t63", "t64", "t65", "t66", 
  "t67", "t68", "t69", "t70", "t71", "t72", 
  "t73", "t74", "t75", "t76", "t77", "t78", 
  "t79", "t80", "t81", "t82", "t83", "t84", 
  "t85", "t86", "t87", "t88", "t89", "t90", 
  "t91", "t92", "t93", "t94", "t95", "t96", 
  "t97", "t98", "t99", "t100", "t101", "t102", 
  "t103", "t104", "t105", "t106", "t107", "t108", 
  "t109", "t110", "t111", "t112", "t113", "t114", 
  "t115", "t116", "t117", "t118", "t119", "t120", 
  "t121", "t122", "t123", "t124", "t125", "t126", 
  "t127", "t128", "t129", "t130", "t131", "t132", 
  "t133", "t134", "t135", "t136", "t137", "t138", 
  "t139", "t140", "t141", "t142", "t143", "t144", 
  "t145", "t146", "t147", "t148", "t149", "t150", 
  "t151", "t152", "t153", "t154", "t155", "t156", 
  "t157", "t158", "t159", "t160", "t161", "t162", 
  "t163", "t164", "t165", "t166", "t167", "t168", 
  "t169", "t170", "t171", "t172", "t173", "t174", 
  "t175", "t176", "t177", "t178", "t179", "t180", 
  "t181", "t182", "t183", "t184", "t185", "t186", 
  "t187", "t188", "t189", "t190", "t191", "t192", 
  "t193", "t194", "t195", "t196", "t197", "t198", 
  "t199", "t200", "t201", "t202", "t203", "t204", 
  "t205", "t206", "t207", "t208", "t209", "t210", 
  "t211", "t212", "t213", "t214", "t215", "t216",  
  " " /* blank terminates */
};


int ptc_twiss_summary_table_types[] =
  {
    2, 2, 2, 2, 
    2, 2, 2, 2,
    2, 2, 2, 2,
    2,
    2,2,2,
    2,2,2
  };
char* ptc_twiss_summary_table_cols[] = {
  "length", "alpha_c", "eta_c", "gamma_tr", 
  "q1", "q2", "dq1", "dq2",
  "beta_x_min","beta_x_max","beta_y_min","beta_y_max",
  "deltap",
  "orbit_x","orbit_px","orbit_y",
  "orbit_py","orbit_pt","orbit_-cT",
  " " /* blank terminates */
};

int ibs_table_types[] =
{
  3, 2, 2, 2, 2, 2
};

char* ibs_table_cols[] =
{
  "name", "s", "dels", "tli", "txi", "tyi",
  " "  /* blank terminates */
};

int map_tab_types[]=
{
  2,1,1,1,1,1,1,1,1,1
};

char* map_tab_cols[]=
{
  "coef","n_vector","nv","order","nx","nxp","ny","nyp","ndeltap","nt",
  " "  /* blank terminates */
};

int normal_res_types[] =
{
  3, 1, 1, 1, 1, 2
};

char* normal_res_cols[] =
{
  "name", "order1", "order2", "order3", "order4", "value",
  " "  /* blank terminates */
};

int sodd_detune_5_types[] =
{
  1, 1, 2, 1, 1
};

char* sodd_detune_5_cols[] =
{
  "multipoleorder", "plane", "detuning", "h_inv_order", "v_inv_order",
  " "  /* blank terminates */
};

int sodd_distort1_8_types[] =
{
  2, 2, 2, 2, 2, 2, 2, 2
};

char* sodd_distort1_8_cols[] =
{
  "multipoleorder", "cosine", "sine", "amplitude", "j", "k", "l", "m",
  " "  /* blank terminates */
};

int sodd_distort1_11_types[] =
{
  1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1
};

char* sodd_distort1_11_cols[] =
{
  "multipoleorder", "location", "resonance", "position[m]", "cosine", "sine", "amplitude", "j", "k", "l", "m",
  " "  /* blank terminates */
};

int sodd_distort2_9_types[] =
{
  1, 1, 2, 2, 2, 1, 1, 1, 1
};

char* sodd_distort2_9_cols[] =
{
  "multipoleorder1", "multipoleorder2", "cosine", "sine", "amplitude", "j", "k", "l", "m",
  " "  /* blank terminates */
};

int touschek_table_types[] =
{
  3, 2, 2, 2, 2
};

char* touschek_table_cols[] =
{
  "name", "s", "tli", "tliw", "tlitot",
  " "  /* blank terminates */
};

int mon_table_types[] =
{
  3, 2, 2, 2, 2
};

char* mon_table_cols[] =
{
  "name", "x.old", "y.old", "x", "y",
  " "  /* blank terminates */
};

int corr_table_types[] =
{
  3, 2, 2, 2, 2
};

char* corr_table_cols[] =
{
  "name", "px.old", "py.old", "px.correction", "py.correction",
  " "  /* blank terminates */
};

int orbit_table_types[] =
{
  3, 2, 2, 1,
};

char* orbit_table_cols[] =
{
  "name", "x", "y", "status",
  " "  /* blank terminates */
};

int special_comm_cnt[] =
{
  3, 5, 7, 6, 5, 4,
  0
};

char* special_comm_desc[] = /* ">?" = skip from start including char. at ? */
{
  "if(", "else{", "elseif(", "while(", ">:macro", ">:line",
  " "  /* blank terminates , line must remain last */
};

int summ_table_types[] =
{
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2, 2,
  2, 2, 2, 2,
};

char* summ_table_cols[] =
{
  "length", "orbit5", "alfa", "gammatr", "q1",
  "dq1", "betxmax", "dxmax", "dxrms", "xcomax",
  "xcorms", "q2", "dq2", "betymax", "dymax",
  "dyrms", "ycomax", "ycorms", "deltap",
  "synch_1","synch_2","synch_3","synch_4","synch_5",
  " "  /* blank terminates */
};

int trackone_table_types[] =
{
  1, 1, 2, 2, 2, 2, 2, 2, 2, 2
};

char* trackone_table_cols[] =
{
  "number", "turn", "x", "px", "y", "py", "t", "pt", "s", "e",
  " "  /* blank terminates */
};

int track_table_types[] =
{
  1, 1, 2, 2, 2, 2, 2, 2, 2, 2
};

char* track_table_cols[] =
{
  "number", "turn", "x", "px", "y", "py", "t", "pt", "s", "e",
  " "  /* blank terminates */
};

int tracksumm_table_types[] =
{
  1, 1, 2, 2, 2, 2, 2, 2, 2, 2
};

char* tracksumm_table_cols[] =
{
  "number", "turn", "x", "px", "y", "py", "t", "pt", "s", "e",
  " "  /* blank terminates */
};


int ptcnodetrack_table_types[] =
{  1,        3,      1,         1,           1,      2,       2,   2,   2,    2,   2,    2,   2,    2 };

char* ptcnodetrack_table_cols[] =
{"number", "name", "elnumber","trnumber" , "turn","s_slice", "s", "x", "px", "y", "py", "t", "pt", "s",
 " "  /* blank terminates */
};


int trackloss_table_types[] =
{
  1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3
};

char* trackloss_table_cols[] =
{
  "number", "turn", "x", "px", "y", "py", "t", "pt", "s", "e", "element",
  " "  /* blank terminates */
};

int dynap_table_types[] =
{
  2,2,2,2,2,
  2,2,2,2,2,
  2,2,2,2,2
};

char* dynap_table_cols[] =
{
  "dynapfrac", "dktrturns", "xend", "pxend", "yend",
  "pyend", "tend", "wxmin", "wxmax", "wymin", "wymax",
  "wxymin", "wxymax", "smear", "yapunov",
  " "  /* blank terminates */
};

int dynaptune_table_types[] =
{
  2,2,2,2,2
};

char* dynaptune_table_cols[] =
{
  "x", "y", "tunx", "tuny", "dtune",
  " "  /* blank terminates */
};

/* Definition of "select_ptc_normal" parameters for "ptc_normal" FS/VK 20.04.2006*/
char names[PTC_NAMES_L][5]=
{
  "dx","dpx","dy","dpy","q1","q2","dq1","dq2","anhx","anhy","haml","gnfu","eign"
};
