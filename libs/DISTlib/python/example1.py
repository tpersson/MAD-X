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

zero =0
one =1
pia2=3.1415*2
dist = DISTlib()
dist.initializedistribution(2)
dist.setEmittance12(1,1)
dist.settotalsteps(6000)
myfile = "/home/tobias/codes/SixTrackTobias/test/orbit6d-element-dispersion/START_DUMP"
tas = readtasfromdump(myfile)
#tas = tas*1e-3
print(tas[5,0:5])
tas[0:5,5]=tas[0:5,5]/1e3
tas[5,0:5]=tas[5,0:5]/1e3
print(tas)
exit()
invtas = inv(tas)



dist.settasmatrix(tas)
#re =np.array([-1.534723187,31.54291486,0, 0 , 1.143506729e-05  , 0.02553935348 , -0.1373767366,2.171898575,    0,    0,  9.454178188e-07,     -0.03670424548,       0,       0,       0.8024715971,8.244707436,      
# 0,       0,       0,       0,      -0.1373747061,      -0.1652572644,       0,       0   ,  -0.05984060609,1.213233084,       0,       0 , 0.9998693084,2.989308455 ,  2.200498725e-06,  -5.122421398e-05,       0,       0  ,  -8.72664626e-05  ,     0.9998694126])
re=np.array([-1.5524531239485908, -0.13792237838372001,   0.0000000000000000,   0.0000000000000000,  -5.9715128291558409E-002 ,
0.0000000000000000,   31.681145206901689,   2.1704609594173210,   0.0000000000000000,   0.0000000000000000,   1.2061148347117667,   0.0000000000000000,   0.0000000000000000,  
0.0000000000000000,  0.79402554803488146, -0.13792038390052824,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   8.2636867099291997, 
-0.17597776773423202,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   0.0000000000000000,   1.0000000000000000,  
0.0000000000000000,   1.9406907464606604E-002,  -3.6740871963909925E-002 ,  0.0000000000000000,   0.0000000000000000,   3.0000287407276174,   1.0000000000000000])

#re=np.array([-1.5524531239485908   ,   -0.13792237838372001   ,     31.681145206901689      ,  2.1704609594173210 ])
#re=np.array([[-1.552453124 ,       31.68114521 ]     ,[-0.1379223784      ,  2.170460959]])
o = 1/np.sqrt(2)
i = (1/np.sqrt(2))*np.complex(0,1)

q = np.array(
[[ 1, 1,  0, 0,  0, 0],
[-i,  i,  0, 0,  0, 0],
[ 0,  0,  1, 1,  0, 0],
[ 0,  0, -i, i,  0, 0],
[ 0,  0,  0, 0,  1, 1],
[ 0,  0,  0, 0, -i, i]])
s=np.array(
[[ 0, 1,  0, 0,  0, 0],
[-1,  0,  0, 0,  0, 0],
[ 0,  0,  0, 1,  0, 0],
[ 0,  0, -1, 0,  0, 0],
[ 0,  0,  0, 0,  0, 1],
[ 0,  0,  0, 0, -1, 0]])

print(invtas.transpose().dot(s).dot(invtas)-s)
print(tas[:,5])
exit()
re = re.reshape(6,6).transpose() #correct
print(re)

values, vectors = la.eig(re)
print(values)
print(vectors[:,3])

#newv = np.zeros((6, 6),dtype=complex)
#v1 = np.zeros((6),dtype=complex)
#v2 = np.zeros((6),dtype=complex)
#v1 = vectors[:,1]/0.257175451283
#v2 = vectors[:,2]/0.244175451283
#v5 = vectors[:,4]/0.244175451283
nu = np.sqrt(0.0597175451283)
v5 =vectors[:,1]
v6 =vectors[:,2]/nu
vectors =vectors/nu
vectors[:,0] = v6
vectors[:,1] = v5
s2 = np.array([[ 0, 1], [-1, 0]])
q2 = np.array([[ 1, i], [1, -i]])
e1 = np.array([[ 1, 0], [0, 1]])/2

print("iii", v5.transpose().conjugate().dot(s).dot(v5))
exit()
print("iii", vectors.transpose().dot(s).dot(vectors))

nmat = (vectors).dot(q2)

print("uuu", (nmat).dot(e1).dot((nmat).transpose()))
# create matrix from eigenvectors
print( values[0]*values[5])
print( values[1]*values[2])
print( values[3]*values[4])
print(newv.transpose().conjugate().dot(s).dot(newv).imag)
#Q = inv(vectors).dot(re.transpose()).dot(vectors)
#n = (q.dot(inv(vectors)))
#print("shoudl be s " ,vectors.transpose().dot(s).dot(vectors).imag)
#print("QQ", n)
# create inverse of eigenvectors matrix
#R = la.inv(Q)
# create diagonal matrix from eigenvalues
#L = np.diag(values)
# reconstruct the original matrix
#B = Q.dot(L).dot(R)
#print(B.real)
#print("vvv", v)

stop

dist.setscan_para_diagonal(0,0,6,zero,one);
dist.setscan_para_diagonal(1,0,4,zero,pia2);
dist.setscan_para_diagonal(2,0,6,zero,one);
dist.setscan_para_diagonal(3,0,4,zero,pia2);
dist.setscan_para_diagonal(4,0,6,zero,one);
dist.setscan_para_diagonal(5,0,4,zero,pia2);

[x,xp,y,yp,sigma,dp]=dist.get6trackcoord()
print(invtas)
print(inv(invtas))
print(tas)
plt.plot(x,y , '.')
plt.show()