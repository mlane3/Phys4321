#!/usr/bin/python
import csv

filelist = ['FH-HG-611-250',
'FH-Hg-612-100-2',
'FH-Hg-612-100-6',
'FH-Hg-700-100',
'FH-Hg',
'FH-Hg-612-100-3',
'FH-Hg-612-100-7',
'FH-Hg-750-100',
'FH-Hg-612-050',
'FH-Hg-612-100-4',
'FH-Hg-612-200',
'FH-Hg2', 
'FH-Hg-612-100', 
'FH-Hg-612-100-5',
'FH-Hg-650-100,'
'FH-Hg3-exp']
smoothadd = '-smooth'
testfile = 'FH-HG-611-250'


reader = csv.reader(open(testfile, 'r'))
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

writer = csv.writer(open(testfile+smoothadd, 'w'))
for i in range(len(x)):
	writer.writerow([x[i],y[i]])
