from distpyinterface import *
import numpy as np
import matplotlib.pyplot as plt
from numpy.linalg import inv
import scipy.linalg as la
def readtasfromdump(filename):
	file = open(filename, "r")
	splitlines = (file.readlines())
	tasstr = (str.split(splitlines[3]))
	tasstr = np.array(tasstr[3:])
	tas = tasstr.astype(np.float)
	tasm = tas.reshape(6,6)
	return tasm
e1 = 0.5
e2 = 1.2
e3 = 0.0
zero =0
one =1
pia2=3.1415*2
dist = DISTlib()
dist.initializedistribution(2)
dist.setEmittance12(e1,e2)
dist.setEmittance3(e3)
dist.setEandMass(6500, 0.938)
dist.settotalsteps(3000)
myfile = "/home/tobias/codes/SixTrackTobias/test/orbit6d-element-quadrupole/my.dat"
tas = readtasfromdump(myfile)



#tas = tas*1e-3
tas[:,5] = tas[:,5]*(np.sqrt(1e3)) 
dist.settasmatrix(tas)
dist.setscan_para_diagonal(0,0,0,2,2);
dist.setscan_para_diagonal(1,0,0,zero,pia2);
dist.setscan_para_diagonal(2,0,0,2,one);
dist.setscan_para_diagonal(3,0,0,zero,pia2);
dist.setscan_para_diagonal(4,0,0,zero,zero);
dist.setscan_para_diagonal(5,0,0,zero,zero);

[x,xp,y,yp,sigma,dp]=dist.get6trackcoord()
#print(np.std(x), np.std(xp),np.std(y), np.std(yp), np.std(sigma), np.std(dp))
#print(invtas)
#print(inv(invtas))
#print(tas)
print(x[-1]*1e-3,xp[-1]*1e-3,y[-1]*1e-3,yp[-1]*1e-3,sigma[-1]*1e-3,dp[-1])
plt.plot(x,xp , '.')
plt.show()