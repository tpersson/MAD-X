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
dist.settotalsteps(3000)
myfile = "/home/tobias/codes/SixTrackTobias/test/orbit6d-element-quadrupole/my.dat"
tas = readtasfromdump(myfile)
sigma = 1
dist.settasmatrix(tas)
dist.setscan_para_diagonal(0,1,0,0,sigma);
dist.setscan_para_diagonal(1,1,0,0,sigma);
dist.setscan_para_diagonal(2,1,0,2,sigma);
dist.setscan_para_diagonal(3,1,0,0,sigma);
dist.setscan_para_diagonal(4,1,0,0,sigma);
dist.setscan_para_diagonal(5,1,0,0,sigma);

[x,xp,y,yp,sigma,dp]=dist.get6trackcoord()
#print(np.std(x), np.std(xp),np.std(y), np.std(yp), np.std(sigma), np.std(dp))
#print(invtas)
#print(inv(invtas))
#print(tas)
print(x[-1],xp[-1],y[-1],yp[-1],sigma[-1],dp[-1])
plt.plot(x,xp , '.')
plt.show()