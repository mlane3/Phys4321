#!/usr/bin/env python2
import matplotlib.pyplot as plt
from matplotlib import rc
from pylab import *
from numpy import *

rc('font', **{'family':'sans-serif', 'sans-serif':['Helvetica']})
rc('text', usetex=True)
print 'test'

# Open the data
filename = 'Data1.txt'
datafile = open(filename, 'r')
datafile.readline()
x = []
y = []
for row in datafile.readlines():
	x.append(float(row[1]))
	y.append(-float(row[0]))
print 'test'

# Smooth The data
binsize = 32
x2 = []
y2 = []
for i in range(binsize//2,len(x)-binsize//2):
	xtemp = x[i-binsize//2:i+binsize//2]
	ytemp = y[i-binsize//2:i+binsize//2]
	x2.append(sum(xtemp)/len(xtemp))
	y2.append(sum(ytemp)/len(ytemp))
print 'test'

plt.figure(1, figsize=(5,4))
plt.scatter(x,y)
#plt.axis( (theta_exp[0],theta_exp[-1],0,1.1) )
plt.show()
print 'test'
