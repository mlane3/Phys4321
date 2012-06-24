#!/usr/bin/env python2
import csv
import matplotlib.pyplot as plt
from matplotlib import rc
from pylab import *
from numpy import *
from scipy.optimize import leastsq

rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)

Files = [
'12-06-05-14-37.data',
'12-06-05-14-39.data',
'12-06-05-14-40.data',
'12-06-05-14-41.data',
'12-06-05-14-46.data',
'12-06-05-14-49.data',
'12-06-05-14-50.data',
'12-06-05-14-51.data',
'12-06-05-14-52-12-06-07-13-52-00.data',
'12-06-05-14-52.data',
'12-06-07-13-55.data',
'12-06-07-14-02.data',
'12-06-07-14-03.data',
'12-06-07-14-08.data',
'12-06-07-14-10.data',
'12-06-12-14-09.data',
'12-06-14-13-58 (2).data',
'12-06-14-13-58.data',
]

events = []
etimes = []

totalevents = 0

csvr = csv.reader( open('muon2.data', 'r'), delimiter=' ')
for row in csvr:
	try:
		event = int( row[0] )
		etime = int( row[1] )
		if event < 40000:
			totalevents += 1
			events.append( event )
			etimes.append( etime )
	except:
		print row
#print totalevents
#print max(events), min(events), sum(events)//len(events)

emax = max(events)+1.0
bins = 200
x_data = [ emax * i * 10**-3 / (bins-1) for i in range(bins) ]
y_data = [0]*bins
for event in events:
	binno = int(event*bins//emax)
	#if binno == bins: binno = bins-1
	y_data[binno] += 1
y_data = array( y_data ) 
x_fit = array( x_data[:bins/2] )
y_fit = log( array( y_data[:bins/2] ) )
## Raw data plot
#plt.scatter( x, y )

## Fit data
# fp = lambda v, x: v[0]*exp(x/v[1]) + v[2]
# err = lambda v, x, y: (fp(v,x)-y)
# v0 = [ y_data[0], -2.0, 0 ]
# v, success = leastsq(err, v0, args=(x_data,y_data))
fp = lambda v, x: v[0]*x + v[1]
err = lambda v, x, y: (fp(v,x)-y)
v0 = [ -2.0, 10.0 ]
v, success = leastsq(err, v0, args=(x_fit,y_fit))

y_mean = sum(y_fit) / len(y_fit)
stot = 0
serr = 0
v[0] += 0.03*v[0]
for n in range(len(y_fit)):
	stot += ( y_fit[n] - y_mean )**2
	serr += ( fp( v, x_fit[n] ) - y_fit[n] )**2
print 'r2: ', ( 1.0-serr/stot)

x1 = arange(0.0, 20, .1)
plt.figure(1, figsize = (4,4) )
plt.scatter( x_data, y_data, marker='.', s=5 )
plt.plot( x1, exp(fp(v, x1)) )
plt.xlabel( "Muon Decay Time ($\mu$s)" )
plt.ylabel( "Occurances (counts)" )
plt.title( "Occurances of Muon Decay Time" )
ax = gca()
ax.set_yscale('log')
ax.annotate( 'log(N) = -t/$\\tau$ + log(N$_{0})$\n$\\tau$=-2.198$\\mu$s\nN$_{0}$=2010.2', xy=(0.5,0.5) )
plt.axis( (0,20,0,10**4) )
plt.show()
