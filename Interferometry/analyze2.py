#!/usr/bin/env python2

import csv
import matplotlib.pyplot as plt
from matplotlib import rc
from pylab import *
from numpy import *

rc('font', **{'family':'sans-serif', 'sans-serif':['Helvetica']})
rc('text', usetex=True)

x = [] ## Slit position in microns
y = [] ## Voltage
csvfile = csv.reader( open('twoslit2.csv','r'), delimiter=',')
for row in csvfile:
	x.append( float(row[0]) )
	y.append( float(row[1]) )

print len(x)

## Find maximums
maxx = []
maxy = []
for n in range(1,len(x)-1):
	if y[n-1]<y[n] and y[n+1]<y[n]:
		maxx.append(x[n])
		maxy.append(y[n])

center = 0.1*maxx[1]+0.15*maxx[2]+0.5*maxx[3]+0.15*maxx[4]+0.1*maxx[5]

L = 5.16*10**8 # nm - box length
k = 2.*pi/670. # 1/nm - wavenumber
b = 9.*10**4 # nm - slit width
h = 4.*10**5 # nm - slit separation
N = 10

beta = lambda t: 0.5*k*b*sin(t)
gamma = lambda t: 0.5*k*h*sin(t)

theta_exp = (array(x)-center)*10**3/L
intensity_exp = array(y)/maxy[3]

theta = linspace(theta_exp[0],theta_exp[-1],10**3)
print theta_exp
intensity = (sinc(beta(theta))*sin(N*gamma(theta))/(N*sin(gamma(theta))))**2

print intensity_exp
print intensity

plt.figure(1, figsize=(5,4))
plt.scatter(theta_exp,intensity_exp)
plt.plot(theta,intensity)
plt.axis( (theta_exp[0],theta_exp[-1],0,1.1) )
plt.show()
