#!/usr/bin/python
from numpy import arange,array,ones,random,linalg
import csv

## Globals
smoothadd = 'smoothed/'
flipadd = 'flipped/'
maxfile = 'results/maximums'
fitfile = 'results/fiteqs'
maxguess = [18.7,23.2,27.7,32.5,37.4,42.4,47.4,52.4]
maxdict = {}
fitdict = {}

filelist = ['run01', ##{{{
'run02',
'run03', 
'run04',
'run05',
'run06',
'run07',
'run08',
'run09',
'run10'] ##}}}

for filename in filelist:

	## {{{ Smooth The data
	reader = csv.reader(open(filename, 'r'))
	x = []
	y = []
	for row in reader:
		x.append(float(row[1]))
		y.append(-float(row[0]))

	binsize = 64
	x2 = []
	y2 = []
	for i in range(binsize//2,len(x)-binsize//2):
		xtemp = x[i-binsize//2:i+binsize//2]
		ytemp = y[i-binsize//2:i+binsize//2]
		x2.append(sum(xtemp)/len(xtemp))
		y2.append(sum(ytemp)/len(ytemp))

	writer = csv.writer(open(smoothadd+filename, 'w'), delimiter='\t')
	for i in range(len(x2)):
		writer.writerow([str(x2[i]),' '+str(y2[i])])
	## }}}

	## Find Maximums {{{
	guesswidth = 2.0
	maximums = []
	for i in maxguess:
		curmax = [0,0]
		for j in range(len(x2)):
			if x2[j] > i+guesswidth: break
			if x2[j] < i-guesswidth: continue
			if y2[j] > curmax[1]: curmax = [x2[j],y2[j]]
		maximums.append(curmax[0])
	## }}}

	maxdict[filename] = maximums

	## fit the data
	y1 = maximums[1:-1]
	x1 = arange(2,len(y1)+2)
	A = array([x1,ones(len(y1))])
	w = linalg.lstsq(A.T,y1)[0]
	fitdict[filename] = w

## Write maximums to file {{{
writer = csv.writer(open(maxfile, 'w'), delimiter='\t')

headerrow = ['n']
for key in maxdict.keys(): headerrow.append(key)
writer.writerow(headerrow)

for n in range(6):
	newrow = [n+1]
	for key in maxdict.keys():
		newrow.append(maxdict[key][n])
	writer.writerow(newrow)
## }}}

## Write fits to file {{{
writer = csv.writer(open(fitfile, 'w'))
writer.writerow(['Filename',' m',' b'])
for k,v in fitdict.items():
	newrow = [k]
	for num in v:
		newrow.append(' '+str(num))
	writer.writerow(newrow)
## }}}
