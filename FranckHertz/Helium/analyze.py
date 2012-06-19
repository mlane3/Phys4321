#!/usr/bin/python
from numpy import arange,array,ones,random,linalg
import csv

## Globals
smoothadd = 'smoothed/'
flipadd = 'flipped/'
outfile = 'results/minimums'
fitfile = 'results/fiteqs'
mindict = {}

filelist = ['run01', ##{{{
'run02',
'run03',
'run04',
'run05',
'run06',
'run07',
'run08',
'run09',
'run10' ] ##}}}

for filename in filelist:

	## {{{ Smooth The data
	reader = csv.reader(open(filename, 'r'))
	x = []
	y = []
	for row in reader:
		x.append(float(row[1]))
		y.append(-float(row[0]))

	binsize = 32
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

	## Find the minimums {{{
	minimums = []

	## Guess the first min is around 12.5
	for i in range(1250,len(y2)):
		if len(minimums) == 0:
			if y2[i]-y2[i-20] > .05:
				minimums.append(x2[i])
		elif len(minimums) == 4:
			break
		elif y2[i] == min(y2[i-10:i+10]) and x2[i] > minimums[-1]+0.6:
			minimums.append(x2[i])

	mindict[filename] = minimums
	print(filename)
	print(minimums)
	## }}}

writer = csv.writer(open(outfile, 'w'), delimiter='\t')
for k,v in mindict.items():
	newrow = [k]
	for val in v:
		newrow.append(' '+str(val))
	writer.writerow(newrow)
