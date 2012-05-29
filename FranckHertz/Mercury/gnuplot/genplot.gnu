set terminal svg enhanced size 1000,1000 fname "Arial" fsize 32 solid lw 2 
set output "fig.svg"
set pointsize 0.2

## Filenames
## FH-HG-611-250
## FH-Hg-612-200
## FH-Hg-612-100
## FH-Hg-612-050
## FH-Hg-612-100-2
## FH-Hg-612-100-3
## FH-Hg-612-100-4
## FH-Hg-612-100-5
## FH-Hg-612-100-6
## FH-Hg-612-100-7
## FH-Hg-750-100
## FH-Hg-700-100
## FH-Hg-650-100

## Plot data and smoothed data
plot "../FH-HG-611-250" using 2:(-$1) with points lt 1 pt 7,\
"../smoothed/FH-HG-611-250" with lines

unset output
