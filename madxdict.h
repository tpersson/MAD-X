/* constants (pre-defined variables) */
char predef_constants[] =
"const pi = 4 * atan(1.); "
"const twopi = 2 * pi; "
"const degrad = 180 / pi; "
"const raddeg = pi / 180; "
"const e = exp(1.); "
"const amu0 = 4.e-7 * pi; "
"const emass = 0.510998902e-3; "
"const mumass = 0.1056583568; "
"const pmass = 0.938271998; "
"const clight = 299792458.; "
"const qelect = 1.602176462e-19; "
"const hbar = 6.58211889e-25; ";


/* command definitions, sorted by module resp. type */

/* The special commands  
   "if(", "else{", "elseif(", "while(", ">:macro", ">:line"
   are not included here, but can be found in fulll.h 
   under special_comm_desc */
/* IMPORTANT:
   beta0 and twiss MUST have identical portions 
   up to "energy" included */

/* format as follows: <...> optional, missing defaults become 0
                      "none" stands for empty string
   name : module group type mad_8
          module = the module this command belongs to
          group  = the command group this command belongs to
          type   = 0: default
                   1: start of group
                   2: end of group
          mad_8  = mad-8 element code
   remark: sequence ... endsequence is NOT a group
   
   parameter 1 = (type <,default<, call default>>),
   parameter 2 = (type <,default<, call default>>),
   etc.
   some commands contain only data (module "data") for easy access.
   examples: 
   l = (r) means: default l = 0, l in command without value -> 0
   energy = (r, 1) means: default energy is 1, in command without value -> 0
   file = (s, none, twiss) means: default no file, 
                                  file in command without value -> twiss

   types: l=logical, i=int, r=real, s=string
   integer and real arrays of arbitrary length can be defined via {...};
   arrays must be defined with maximum length.
   */
char command_def[] =
"antiproton: data none 0 0 "  /* comment allowed outside quotes */
"mass     = [r, pmass], "
"charge   = [r, -1]; "
" "
"electron: data none 0 0 "
"mass     = [r, emass], "
"charge   = [r, -1]; "
" "
"negmuon: data none 0 0 "
"mass     = [r, mumass], "
"charge   = [r, -1]; "
" "
"positron: data none 0 0 "
"mass     = [r, emass], "
"charge   = [r, 1]; "
" "
"posmuon: data none 0 0 "
"mass     = [r, mumass], "
"charge   = [r, 1]; "
" "
"proton: data none 0 0 "
"mass     = [r, pmass], "
"charge   = [r, 1]; "
" "
"assign: control none 0 0 "
"echo     = [s, terminal, none]; "
" "
"beam: control none 0 0 "
"particle = [s, positron, positron], "
"sequence = [s, none, none], "
"bunched  = [l, true, true], "
"radiate  = [l, false, true], "
"mass     = [r, emass], "
"charge   = [r, 1], "
"energy   = [r, 1], "
"pc       = [r, 0], "
"gamma    = [r, 0], "
"ex       = [r, 1], "
"exn      = [r, 0], "
"ey       = [r, 1], "
"eyn      = [r, 0], "
"et       = [r, 1], "
"sigt     = [r, 0], "
"sige     = [r, 0], "
"kbunch   = [r, 1], "
"npart    = [r, 1], "
"bcurrent = [r, 0], "
"freq0    = [r, 0], "
"circ     = [r, 0], "
"dtbyds   = [r, 0], "
"deltap   = [r, 0], "
"beta     = [r, 0], "
"alfa     = [r, 0], "
"u0       = [r, 0], "
"qs       = [r, 0], "
"arad     = [r, 0], "
"bv       = [r, 1], "
"pdamp    = [r, {1,1,2}, {0,0,0}]; "
" "
"beta0: control none 0 0 "
"betx     = [r, 0], alfx     = [r, 0], mux      = [r, 0], "
"bety     = [r, 0], alfy     = [r, 0], muy      = [r, 0], "
"x        = [r, 0], px       = [r, 0],		       "
"y        = [r, 0], py       = [r, 0],		       "
"t        = [r, 0], pt       = [r, 0],		       "
"dx       = [r, 0], dpx      = [r, 0],		       "
"dy       = [r, 0], dpy      = [r, 0],		       "
"wx       = [r, 0], phix     = [r, 0], dmux     = [r, 0], "
"wy       = [r, 0], phiy     = [r, 0], dmuy     = [r, 0], "
"ddx      = [r, 0], ddpx     = [r, 0], "
"ddy      = [r, 0], ddpy     = [r, 0], "
"r11      = [r, 0], r12      = [r, 0], "
"r21      = [r, 0], r22      = [r, 0], "
"energy   = [r, 0]; "
" "
"call: control none 0 0 "
"file = [s, none]; "
" "
"dumpsequ: control none 0 0 "
"sequence = [s, none], "
"level    = [i, 0], "
"file = [s, 0]; "
" "
"exec: control none 0 0; "
" "
"exit: control none 0 0; "
" "
"help: control none 0 0 "
"dummy    = [s, 0]; "
" "
"option: control none 0 0 "
"bborbit  = [l, false, true], "
"echo     = [l, true, true], "
"info     = [l, true, true], "
"reset    = [l, false, true], "
"debug    = [l, false, true], "
"rbarc    = [l, true, true], "
"sympl    = [l, true, true], "
"tell     = [l, false, true], "
"trace    = [l, false, true], "
"verify   = [l, false, true], "
"warn     = [l, true, true]; "
" "
"plot: control none 0 0 "
"vaxis    = [s, {none}], "
"vaxis1   = [s, {none}], "
"vaxis2   = [s, {none}], "
"vaxis3   = [s, {none}], "
"vaxis4   = [s, {none}], "
"haxis    = [s, none], "
"hmin     = [r, 0, 0], "
"hmax     = [r, 0, 0], "
"vmin     = [r, {0}], "
"vmax     = [r, {0}], "
"bars     = [i, 0, 1], "
"style    = [i, 1, 1], "
"colour   = [i, 0, 100], "
"symbol   = [i, 0, 1], "
"spline   = [l, false, true], "
"noline   = [l, false, true], "
"notitle  = [l, false, true], "
"table    = [s, twiss], "
"title    = [s, none], "
"param    = [s, none], "
"range    = [s, #s/#e, none], "
"file     = [s, none]; "
" "
"print: control none 0 0 "
"text     = [s, none]; "
" "
"quit: control none 0 0; "
" "
"readtable: control none 0 0 "
"file = [s, none]; "
" "
"resbeam: control none 0 0, "
"sequence = [s, none, none]; "
" "
"resplot: control none 0 0; "
" "
"return: control none 0 0; "
" "
"save: control none 0 0 "
"sequence = [s, {none}], "
"mad8     = [l, false, true], "
"file     = [s, none]; "
" "
"savebeta: control none 0 0 "
"label    = [s, none], "
"place    = [s, none], "
"sequence = [s, none]; "
" "
"select: control none 0 0 "
"flag     = [s, none, none], "
"range    = [s, #s/#e, none], "
"class    = [s, none, none], "
"pattern  = [s, any, none], "
"slice    = [i, 1, 1], "
"column   = [s,{none}], "
"sequence = [s, none], "
"full     = [l, false, true], "
"clear    = [l, false, true]; "
" "
"setplot: control none 0 0 "
"font     = [i, 1], "
"lwidth   = [r, 5], "
"xsize    = [r, 0], "
"ysize    = [r, 0], "
"ascale   = [r, 1.5], "
"lscale   = [r, 2], "
"sscale   = [r, 2], "
"rscale   = [r, 1.8], "
"post     = [i, 1]; "
" "
"show: control none 0 0; "
" "
"stop: control none 0 0; "
" "
"system: control none 0 0 "
"dummy    = [s, 0]; "
" "
"title: control none 0 0 "
"dummy    = [s, 0]; "
" "
"use: control none 0 0 "
"period   = [s, none, none], "
"sequence = [s, none, none], "
"range    = [s, #s/#e, none]; "
" "
"value: control none 0 0 "
"dummy    = [s, 0]; "
" "
"write: control none 0 0 "
"table = [s, none], "
"file = [s, none]; "
" "
"sixtrack: c6t none 0 0 "
"cavall   = [l, false, true], "
"aperture = [l, false, true], "
"split    = [l, false, true], "
"radius   = [r, 1]; "
" "
"correct: correct correct 0 0 "
"error    = [r, 1.e-5], "
"ncorr    = [i, 0], "
"monerror = [i, 0], "
"monscale = [i, 0], "
"monon    = [r, 1], "
"moncut   = [r, 0], "
"corrlim  = [r, 1], "
"resout   = [i, 0], "
"sequence = [s, {none}], "
"clist    = [s, none], "
"mlist    = [s, none], "
"plane    = [s, x], "
"flag     = [s, ring], "
"mode     = [s, micado], "
"cond     = [i, 0], "
"twissum  = [i, 0]; "
" "
"getorbit: correct correct 0 0 "
"file = [s, orbit, orbit]; "
" "
"putorbit: correct correct 0 0 "
"file = [s, orbit, orbit]; "
" "
"getkick: correct correct 0 0 "
"file = [s, setting, setting], "
"plane    = [s, none, none], "
"add      = [l, false], "
"direct   = [l, false]; "
" "
"putkick: correct correct 0 0 "
"file = [s, setting, setting], "
"plane    = [s, none, none], "
"direct   = [l, false]; "
" "
"getdisp: correct correct 0 0 "
"file = [s, dispersion, dispersion]; "
" "
"putdisp: correct correct 0 0 "
"file = [s, dispersion, dispersion]; "
" "
"usekick: correct correct 0 0 "
"sequence = [s, none, none], "
"status   = [s, on], "
"range    = [s,  #s/#e], "
"class    = [s, none], "
"pattern  = [s, any, none]; "
" "
"usemonitor: correct correct 0 0 "
"sequence = [s, none, none], "
"status   = [s, on], "
"range    = [s,  #s/#e], "
"class    = [s, none], "
"pattern  = [s, any, none]; "
" "
"coguess: correct correct 0 0 "
"x        = [r, 0], "
"px       = [r, 0], "
"y        = [r, 0], "
"py       = [r, 0], "
"t        = [r, 0], "
"pt       = [r, 0], "
"tolerance= [r, 1.0e-6], "
"automatic= [l, false]; "
" "
"coption: correct none 0 0 "
"seed     = [i, 123456789], "
"print    = [i, 1],  "
"debug    = [i, 0];  "
" "
"seqedit: edit edit 1 0 "
"sequence = [s, none, none]; "
" "
"flatten: edit edit 0 0; "
" "
"install: edit edit 0 0  "
"element  = [s, none, none], "
"class    = [s, none, none], "
"at       = [r, 0, 0], "
"from     = [s, none, none]; "
" "
"move: edit edit 0 0 "
"element  = [s, none, none], "
"by       = [r, 0, 0], "
"to       = [r, 0, 0], "
"from     = [s, none, none]; "
" "
"remove: edit edit 0 0 "
"element  = [s, none, none]; "
" "
"cycle: edit edit 0 0 "
"start    = [s, none, none]; "
" "
"reflect: edit edit 0 0; "
" "
"replace: edit edit 0 0 "
"element  = [s, none, none], "
"by       = [s, none, none]; "
" "
"endedit: edit edit 2 0; "
" "
"drift: element none 0 1 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0], "
"slice    = [i, 1],  "
"magnet   = [i, 0];"
" "
"rbend: element none 0 2 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"magnet   = [i, 1],  "
"angle    = [r, 0],  "
"k0       = [r, 0],  "
"k0s      = [r, 0],  "
"k1       = [r, 0],  "
"k1s      = [r, 0],  "
"e1       = [r, 0],  "
"e2       = [r, 0],  "
"k2       = [r, 0],  "
"k2s      = [r, 0],  "
"h1       = [r, 0],  "
"h2       = [r, 0],  "
"hgap     = [r, 0],  "
"fint     = [r, 0, 0.5],  "
"fintx    = [r, -1.0], "
"k3       = [r, 0],  "
"k3s      = [r, 0],  "
"fcsr     = [r, 0],  "
"bv       = [l, false, true], "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"sbend: element none 0 3 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"magnet   = [i, 1],  "
"angle    = [r, 0],  "
"k0       = [r, 0],  "
"k0s      = [r, 0],  "
"k1       = [r, 0],  "
"k1s      = [r, 0],  "
"e1       = [r, 0],  "
"e2       = [r, 0],  "
"k2       = [r, 0],  "
"k2s      = [r, 0],  "
"h1       = [r, 0],  "
"h2       = [r, 0],  "
"hgap     = [r, 0],  "
"fint     = [r, 0, 0.5],  "
"fintx    = [r, -1.0], "
"k3       = [r, 0],  "
"k3s      = [r, 0],  "
"fcsr     = [r, 0],  "
"bv       = [l, false, true], "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"quadrupole: element none 0 5 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"k1       = [r, 0],  "
"k1s      = [r, 0],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"sextupole: element none 0 6 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"k2       = [r, 0],  "
"k2s      = [r, 0],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"octupole: element none 0 7 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"k3       = [r, 0],  "
"k3s      = [r, 0],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"multipole: element none 0 8 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0], "
"lrad     = [r, 0], "
"knl      = [r, {0}], "
"ksl      = [r, {0}], "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"slice    = [i, 1],  "
"bv       = [l, false, true]; "
" "
"solenoid: element none 0 9 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"ks       = [r, 0],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"rfcavity: element none 0 10 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"volt     = [r, 0],  "
"lag      = [r, 0],  "
"freq     = [r, 0],  "
"harmon   = [i, 0],  "
"betrf    = [r, 0],  "
"pg       = [r, 0],  "
"shunt    = [r, 0],  "
"tfill    = [r, 0],  "
"eloss    = [r, 0],  "
"volterr  = [r, 0],  "
"lagerr   = [r, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"nbin     = [i, 0],  "
"binmax   = [r, 0],  "
"magnet   = [i, 0],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"lfile    = [s, none, lfile],  "
"tfile    = [s, none, tfile]; "
" "
"elseparator: element none 0 11 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"ex       = [r, 0],  "
"ey       = [r, 0],  "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"slice    = [i, 1];  "
" "
"srotation: element none 0 12 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"angle    = [r, 0]; "
" "
"yrotation: element none 0 13 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"angle    = [r, 0]; "
" "
"hkicker: element none 0 14 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"kick     = [r, 0],  "
"hkick    = [r, 0],  "
"chkick   = [r, 0],  "
"chflag   = [i, 1],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"bv       = [l, false, true]; "
" "
"kicker: element none 0 15 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"hkick    = [r, 0],  "
"vkick    = [r, 0],  "
"chkick   = [r, 0],  "
"chflag   = [i, 1],  "
"cvkick   = [r, 0],  "
"cvflag   = [i, 1],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"bv       = [l, false, true]; "
" "
"vkicker: element none 0 16 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0],  "
"kick     = [r, 0],  "
"vkick    = [r, 0],  "
"cvkick   = [r, 0],  "
"cvflag   = [i, 1],  "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"bv       = [l, false, true]; "
" "
"hmonitor: element none 0 17 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"monitor: element none 0 18 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"vmonitor: element none 0 19 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"ecollimator: element none 0 20 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"lrad     = [r, 0],  "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"xsize    = [r, 0],  "
"ysize    = [r, 0]; "
" "
"rcollimator: element none 0 21 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0],  "
"lrad     = [r, 0],  "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"xsize    = [r, 0],  "
"ysize    = [r, 0]; "
" "
"beambeam: element none 0 22 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"sigx     = [r, 0],  "
"sigy     = [r, 0],  "
"xma      = [r, 0],  "
"yma      = [r, 0],  "
"magnet   = [i, 0],  "
"charge   = [r, 1],  "
"angle    = [r, 0],  "
"copx     = [r, 0],  "
"copy     = [r, 0],  "
"alfxs    = [r, 0],  "
"alfys    = [r, 0],  "
"dxs      = [r, 0],  "
"dys      = [r, 0],  "
"dpxs     = [r, 0],  "
"dpys     = [r, 0],  "
"sigts    = [r, 1],  "
"siges    = [r, 1],  "
"cot      = [r, 0],  "
"copt     = [r, 0],  "
"slice    = [i, 1],  "
"iopt     = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"cox      = [r, 0],  "
"coy      = [r, 0]; "
" "
"instrument: element none 0 24 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"marker: element none 0 25 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"l        = [r, 0], "
"magnet   = [i, 0],  "
"type     = [s, none, none], "
"apertype = [s, circle, circle], "
"aperture = [r, {0}]; "
" "
"gbend: element none 0 26 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 1],  "
"l        = [r, 0], "
"angle    = [r, 0], "
"k0       = [r, 0],  "
"k0s      = [r, 0],  "
"k1       = [r, 0], "
"k1s      = [r, 0], "
"k2       = [r, 0], "
"k2s      = [r, 0], "
"e1       = [r, 0], "
"e2       = [r, 0], "
"ks       = [r, 0], "
"h1       = [r, 0], "
"h2       = [r, 0], "
"hgap     = [r, 0], "
"fint     = [r, 0, 0.5], "
"fintx    = [r, -1], "
"k3       = [r, 0], "
"k3s      = [r, 0], "
"fcsr     = [r, 0], "
"gmin     = [r, 0], "
"gmax     = [r, 0], "
"slice    = [i, 1],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"bv       = [l, false, true]; "
" "
"lcavity: element none 0 27 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"l        = [r, 0], "
"e0       = [r, 0], "
"deltae   = [r, 0], "
"phi0     = [r, 0], "
"freq     = [r, 0], "
"eloss    = [r, 0], "
"volterr  = [r, 0], "
"lagerr   = [r, 0], "
"aperture = [r, 0], "
"nbin     = [i, 0], "
"magnet   = [i, 0],  "
"binmax   = [r, 0], "
"lfile    = [s, none, lfile], "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"tfile    = [s, none, lfile]; "
" "
"profile: element none 0 28 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"wire: element none 0 29 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"slmonitor: element none 0 30 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"blmonitor: element none 0 31 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"imonitor: element none 0 32 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"type     = [s, none, none], "
"magnet   = [i, 0],  "
"apertype = [s, circle, circle], "
"aperture = [r, {0}],  "
"l        = [r, 0]; "
" "
"emit: emit none 0 0 "
"deltap   = [r, 0], "
"tol      = [r, 1.000001, 0]; "

"ealign: error none 0 0 "
"dx       = [r, 0], "
"dy       = [r, 0], "
"ds       = [r, 0], "
"dphi     = [r, 0], "
"dtheta   = [r, 0], "
"dpsi     = [r, 0], "
"mrex     = [r, 0], "
"mrey     = [r, 0], "
"mredx    = [r, 0], "
"mredy    = [r, 0], "
"arex     = [r, 0], "
"arey     = [r, 0], "
"mscalx   = [r, 0], "
"mscaly   = [r, 0]; "
" "
"efield: error none 0 0 "
"order    = [i, -1], "
"radius   = [r, 0], "
"dk       = [r, {0}], "
"dkr      = [r, {0}], "
"rot      = [r, {0}]; "
" "
"eoption: error none 0 0 "
"seed     = [i, 123456789], "
"add      = [l, true];"
" "
"eprint: error none 0 0; "
" "
"esave: error none 0 0 "
"file     = [s, esave], "
"align    = [l, true], "
"field    = [l, true], "
"order    = [i, -1], "
"radius   = [r, 1];"
" "
"efcomp: error none 0 0 "
"order    = [i, -1], "
"radius   = [r, 0], "
"dkn      = [r, {0}], "
"dks      = [r, {0}], "
"dknr     = [r, {0}], "
"dksr     = [r, {0}];"
" "
"ibs: ibs none 0 0 "
"tolerance= [r, 1.e-7], "
"file     = [s, ibs, ibs], "
"steps    = [i, 50];"
" "
"makethin: makethin none 0 0 "
"style    = [s, teapot, teapot], "
"sequence = [s, none, none]; "
" "
"survey: survey none 0 0 "
"x0       = [r, 0],   y0     = [r, 0], z0       = [r, 0], "
"theta0   = [r, 0], phi0     = [r, 0], psi0     = [r, 0], "
"file     = [s, none, survey], "
"table    = [s, none, survey], "
"sequence = [s, none, sequence]; "
" "
"twiss: twiss none 0 0 "
"betx     = [r, 0], alfx     = [r, 0], mux      = [r, 0], "
"bety     = [r, 0], alfy     = [r, 0], muy      = [r, 0], "
"x        = [r, 0], px       = [r, 0],		       "
"y        = [r, 0], py       = [r, 0],		       "
"t        = [r, 0], pt       = [r, 0],		       "
"dx       = [r, 0], dpx      = [r, 0],		       "
"dy       = [r, 0], dpy      = [r, 0],		       "
"wx       = [r, 0], phix     = [r, 0], dmux     = [r, 0], "
"wy       = [r, 0], phiy     = [r, 0], dmuy     = [r, 0], "
"ddx      = [r, 0], ddpx     = [r, 0], "
"ddy      = [r, 0], ddpy     = [r, 0], "
"r11      = [r, 0], r12      = [r, 0], "
"r21      = [r, 0], r22      = [r, 0], "
"energy   = [r, 0], "
"chrom    = [l, false, true], "
"couple   = [l, false, true], "
"file     = [s, none, twiss], "
"save     = [s, none, twiss], "
"table    = [s, none, twiss], "
"tunes    = [s, none, tunes], "
"beta0    = [s, none, beta0], "
"re11     = [r, 1], re12     = [r, 0], re13     = [r, 0], "
"re14     = [r, 0], re15     = [r, 0], re16     = [r, 0], "
"re21     = [r, 0], re22     = [r, 1], re23     = [r, 0], "
"re24     = [r, 0], re25     = [r, 0], re26     = [r, 0], "
"re31     = [r, 0], re32     = [r, 0], re33     = [r, 1], "
"re34     = [r, 0], re35     = [r, 0], re36     = [r, 0], "
"re41     = [r, 0], re42     = [r, 0], re43     = [r, 0], "
"re44     = [r, 1], re45     = [r, 0], re46     = [r, 0], "
"re51     = [r, 0], re52     = [r, 0], re53     = [r, 0], "
"re54     = [r, 0], re55     = [r, 1], re56     = [r, 0], "
"re61     = [r, 0], re62     = [r, 0], re63     = [r, 0], "
"re64     = [r, 0], re65     = [r, 0], re66     = [r, 1], "
"centre   = [l, false, true], "
"sectormap= [s, sectormap, sectormap], "
"rmatrix  = [l, false, true], "
"sequence = [s, none, sequence], "
"line     = [s, none, line], "
"deltap   = [s, none]; "
" "
"match: match match 1 0 "
"betx     = [r, {0}], alfx     = [r, {0}], mux      = [r, {0}], "
"bety     = [r, {0}], alfy     = [r, {0}], muy      = [r, {0}], "
"x        = [r, {0}], px       = [r, {0}], "
"y        = [r, {0}], py       = [r, {0}], "
"t        = [r, {0}], pt       = [r, {0}], "
"dx       = [r, {0}], dpx      = [r, {0}], "
"dy       = [r, {0}], dpy      = [r, {0}], "
"wx       = [r, {0}], phix     = [r, {0}], dmux     = [r, {0}], "
"wy       = [r, {0}], phiy     = [r, {0}], dmuy     = [r, {0}], "
"ddx      = [r, {0}], ddpx     = [r, {0}], "
"ddy      = [r, {0}], ddpy     = [r, {0}], "
"r11      = [r, {0}], r12      = [r, {0}], "
"r21      = [r, {0}], r22      = [r, {0}], "
"energy   = [r, {0}], "
"sequence = [s, {none}], "
"beta0    = [s, {none}], "
"deltap   = [r, 0], "
"vlength  = [l, false, true], "
"orbit    = [l, false, true]; "
" "
"cell: match match 0 0 "
"deltap   = [r, 0], "
"sequence = [s, {none}], "
"orbit    = [l, false, true]; "
" "
"endmatch:  match match 2 0 "
"increment = [s, none, increment]; "
" "
"migrad: match match 0 0 "
"tolerance= [r, 0.000001], "
"calls    = [i, 1000], "
"strategy = [i, 2]; "
" "
"simplex: match match 0 0 "
"tolerance= [r, 0.000001], "
"calls    = [i, 1000]; "
" "
"constraint: match match 0 0 "
"range    = [s, #s/#e, none], "
"class    = [s, none, none], "
"pattern  = [s, any, none], "
"betx     = [c, 0], alfx     = [c, 0], mux      = [c, 0], "
"bety     = [c, 0], alfy     = [c, 0], muy      = [c, 0], "
"x        = [c, 0], px       = [c, 0], "
"y        = [c, 0], py       = [c, 0], "
"t        = [c, 0], pt       = [c, 0], "
"dx       = [c, 0], dpx      = [c, 0], "
"dy       = [c, 0], dpy      = [c, 0], "
"wx       = [c, 0], phix     = [c, 0], dmux     = [c, 0], "
"wy       = [c, 0], phiy     = [c, 0], dmuy     = [c, 0], "
"ddx      = [c, 0], ddpx     = [c, 0], "
"ddy      = [c, 0], ddpy     = [c, 0], "
"energy   = [c, 0], "
"beta0    = [s, none], "
"sequence = [s, none]; "
" "
"couple: match match 0 0 "
"range    = [s, none, none], "
"mux      = [r, 0], muy      = [r, 0]; "
" "
"fix: match match 0 0 "
"name     = [s, none, none]; "
" "
"level: match match 0 0 "
"level    = [i, 2]; "
" "
"vary: match match 0 0 "
"name     = [s, none, none], "
"step     = [r, 0.0], "
"lower    = [r, -1.e20], "
"upper    = [r,  1.e20]; "
" "
"weight: match match 0 0 "
"betx     = [r, 1.0], "
"alfx     = [r, 10.0], "
"mux      = [r, 10.0], "
"bety     = [r, 1.0], "
"alfy     = [r, 10.0], "
"muy      = [r, 10.0], "
"x        = [r, 10.0], "
"px       = [r, 100.0], "
"y        = [r, 10.0], "
"py       = [r, 100.0], "
"t        = [r, 10.0], "
"pt       = [r, 100.0], "
"dx       = [r, 10.0], "
"dpx      = [r, 100.0], "
"dy       = [r, 10.0], "
"dpy      = [r, 100.0], "
"wx       = [r, 0.0], "
"phix     = [r, 0.0], "
"dmux     = [r, 0.0], "
"wy       = [r, 0.0], "
"phiy     = [r, 0.0], "
"dmuy     = [r, 0.0], "
"ddx      = [r, 0.0], "
"ddpx     = [r, 0.0], "
"ddy      = [r, 0.0], "
"ddpy     = [r, 0.0], "
"energy   = [r, 0.0], "
"circ     = [r, 0.0], "
"i1       = [r, 0.0], "
"i2       = [r, 0.0], "
"i3       = [r, 0.0], "
"i4       = [r, 0.0], "
"i5       = [r, 0.0], "
"i5i2     = [r, 0.0], "
"i5i1     = [r, 0.0], "
"dumm     = [r, 0.0]; "
" "
"lmdif: match match 0 0 "
"tolerance= [r, 0.000001, 0.000001], "
"calls    = [i, 1000, 1000]; "
" "
"rmatrix: match match 0 0 "
"range    = [s, #s/#e, none], "
"rm       = [r, {0}], "
"weight   = [r, {0}]; "
" "
"tmatrix: match match 0 0 "
"range    = [s, #s/#e, none], "
"tm       = [r, {0}], "
"weight   = [r, {0}]; "
" "
"global: match match 0 0 "
"q1       = [c, 0],   q2        = [c, 0], "
"dq1      = [c, 0],   dq2       = [c, 0], "
"ddq1     = [c, 0],   ddq2      = [c, 0], "
"dq1de1   = [c, 0],   dq1de2    = [c, 0], "
"dq2de2   = [c, 0],   gammatr   = [c, 0], "
"sequence = [s, none]; "
" "
"gweight: match match 0 0 "
"q1       = [r, 10],  q2        = [r, 10], "
"dq1      = [r, 1],   dq2       = [r, 1], "
"ddq1     = [r, 0.1], ddq2      = [r, 0.1], "
"dq1de1   = [r, 01],  dq1de2    = [r, 01], "
"dq2de2   = [r, 1],   gammatr   = [r, 1]; "
" "
"sequence: sequence none 0 0 "
"at       = [r, 1.e20], "
"from     = [s, none], "
"refpos   = [s, none], "
"l        = [r, 0], "
"refer    = [s, centre, centre]; "
" "
"endsequence: sequence none 0 0; "
" "
"track: track track 1 0 "
"rfcavity = [s, none], "
"deltap   = [r, 0], "
"onepass  = [l, false, true], "
"damp     = [l, false, true], "
"quantum  = [l, false, true], "
"dump     = [l, false, true], "
"fast     = [l, false, true], "
"aperture = [l, false, true], "
"onetable = [l, false, true]; "
" "
"dynap: track track 0 0 "
"turns   = [i, 64], "
"fastune  = [l, false,true], "
"lyapunov = [r, 1.e-7], "
"tolerance= [r, {0.1, 0.01, 0.1, 0.01, 1., 0.1}], "
"damp     = [l, true], "
"quantum  = [l, true], "
"orbit    = [l, true]; "
" "
"endtrack: track track 2 0 ; "
" "
"run: track track 0 0 "
"tolerance= [r, {0.1, 0.01, 0.1, 0.01, 1., 0.1}], "
"turns    = [i, 1], "
"ffile    = [i, 1]; "
" "
"start: track track 0 0 "
"x        = [r, 0], "
"px       = [r, 0], "
"y        = [r, 0], "
"py       = [r, 0], "
"t        = [r, 0], "
"pt       = [r, 0], "
"fx       = [r, 0], "
"phix     = [r, 0], "
"fy       = [r, 0], "
"phiy     = [r, 0], "
"ft       = [r, 0], "
"phit     = [r, 0]; "
" "
"ripple: track track 0 0 "
"variable = [s, none], "
"amplitude= [r, {0}], "
"frequency= [r, {0}], "
"phase    = [r, {0}]; "
" "
"observe: track track 0 0 "
"place    = [s, none]; "
" "
;
