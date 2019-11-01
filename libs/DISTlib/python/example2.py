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
e3 = 0.2
zero =0
one =1
pia2=3.1415*2
dist = DISTlib()
dist.initializedistribution(2)
dist.setEmittance12(e1,e2)
dist.setEmittance3(e3)
dist.setEandMass(6500, 0.938)
dist.settotalsteps(35000)
myfile = "/home/tobias/codes/SixTrackTobias/test/orbit6d-element-quadrupole/my.dat"
tas = readtasfromdump(myfile)


tmp = tas
#tas = tas*1e-3
#tas[:,5] = tas[:,5]*(np.sqrt(1e3))
print(tas-tmp) 
dist.set_action_angle_cuts(0, 0, 3)
#dist.set_action_angle_cuts(2, 0, 0.01)
#dist.set_action_angle_cuts(4, 0, 0.01)
dist.settasmatrix(tas)
dist.setscan_para_diagonal(0,0,6,zero,one);
dist.setscan_para_diagonal(1,0,4,zero,pia2	);
dist.setscan_para_diagonal(2,0,0,zero,one);
dist.setscan_para_diagonal(3,0,0,zero,pia2);
dist.setscan_para_diagonal(4,0,0,zero,one);
dist.setscan_para_diagonal(5,0,0,zero,pia2);


[x,xp,y,yp,sigma,dp]=dist.gettasunitcoord()
x=np.array(x)
xp=np.array(xp)
print(np.std(x))	
#print(np.std(x), np.std(xp),np.std(y), np.std(yp), np.std(sigma), np.std(dp))
#print(invtas)
#print(inv(invtas))
#print(tas)
print(x[-1],xp[-1],y[-1],yp[-1],sigma[-1],dp[-1])
plt.hist(x)
plt.show()