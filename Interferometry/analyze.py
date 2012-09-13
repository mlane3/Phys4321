#!/usr/bin/env python2
import matplotlib.pyplot as plt
from matplotlib import rc
from pylab import *
from numpy import *

rc('font', **{'family':'sans-serif', 'sans-serif':['Helvetica']})
rc('text', usetex=True)
print 'test'

# Open the data
filename = 'gas 1.txt'
datafile = open(filename, 'r')
datafile.readline()
x = []
y = []

print 'test'

csvfile = csv.reader( open('twoslit2.csv','r'), delimiter='\t')
for row in csvfile:
	x.append( float(row[0]) )
	y.append( float(row[1]) )
#for row in datafile.readlines():
        #row = row.strio().split('\t') # does this go here? My friend suggested it
	#x.append(float(row[1]))
	#y.append(-float(row[0]))
print row
print len(x)


# Smooth The data
# binsize = 32
# x2 = []
# y2 = []
# for i in range(binsize//2,len(x)-binsize//2):
#	xtemp = x[i-binsize//2:i+binsize//2]
#	ytemp = y[i-binsize//2:i+binsize//2]
#	x2.append(sum(xtemp)/len(xtemp))
#	y2.append(sum(ytemp)/len(ytemp))
# print 'test'

# plt.figure(1, figsize=(5,4))
# plt.scatter(x2,y2)
#plt.axis( (theta_exp[0],theta_exp[-1],0,1.1) )
# plt.show()
# print 'test'
