set terminal png truecolor enhanced size 1600,1200 font "Arial" 48
set output "He-smoothed.png"
set key left top ## move legend to top-left

## Filenames and their fits
## column, Filename, m, b
## 2, FH-Hg-612-100, 4.81371428571, 13.239952381
## 3, FH-Hg-612-050, 4.82257142857, 13.3284285714
## 4, FH-HG-611-250, 4.84771428571, 13.2786190476
## 5, FH-Hg-612-100-3, 4.77514285714, 12.8518571429
## 6, FH-Hg-612-100-6, 4.72714285714, 13.0945238095
## 7, FH-Hg-612-100-7, 4.72571428571, 13.095952381
## 8, FH-Hg-612-100-4, 4.77371428571, 12.8466190476
## 9, FH-Hg-612-100-5, 4.76628571429, 12.8867142857
## 10, FH-Hg-750-100, 4.32914285714, 15.6371904762
## 11, FH-Hg-612-200, 4.8, 13.445
## 12, FH-Hg-612-100-2, 4.77685714286, 12.8341428571
## 13, FH-Hg-650-100, 4.71885714286, 13.5534761905
## 14, FH-Hg-700-100, 4.56028571429, 14.542047619


## Uncomment the following lines to
## Plot data and smoothed data
#set pointsize 0.5
#set title "Current vs Accelerating Voltage"
#set xlabel "Accelerating Voltage (V)"
#set ylabel "Electron Current (arb)"
#plot "run05" using 2:(-$1) with points lt 1 pt 7 title "Raw Data",\
#  "smoothed/run05" with lines lw 2.5 title "Smoothed Data"\

set pointsize 0.5
set title "Current vs Accelerating Voltage"
set xlabel "Accelerating Voltage (V)"
set ylabel "Electron Current (arb)"
set arrow from 13.805,0.3 to 13.805,1.2 nohead lt 1 lw 2
set arrow from 12.954,0.3 to 12.954,1.2 nohead lt 1 lw 2
set arrow from 15.335,0.3 to 15.335,1.2 nohead lt 1 lw 2
set arrow from 16.785,0.3 to 16.785,1.2 nohead lt 1 lw 2
plot "~/run05-2" with lines lw 2.5 notitle
## Uncomment the following two lines to
## Plot peaks vs n and fit line
## copy and paste m/b from above which matches column in "maxiums"
## ex to plot file FH-Hg-612-100-3 would be:
#set pointsize 5
#set title "Accelerating Voltage vs Peak Number"
#set xlabel "Peak Number"
#set ylabel "Accelerating Voltage (V)"
#m = 4.77514285714 
#b = 12.8518571429
#
#f(x) = m*x+b
#plot [x=0:7] "maximums" using 1:5 with points notitle lt 1 pt 7, \
#f(x) with lines lw 4 title "y=4.775x+12.852"

unset output
