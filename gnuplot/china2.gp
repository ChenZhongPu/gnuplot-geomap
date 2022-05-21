set terminal svg size 1000,800 enhanced font 'Verdana,20'
set out "china2.svg"

unset key
set border 0
unset tics

set style line 1 lc rgb '#999999' lt 1 lw 0 # --- grey 
set style line 2 lc rgb '#ffffff' lt 1 lw 0.5 # --- white

stats '../data/china.txt' u 1 prefix "M" nooutput

set palette defined ( 0 '#F7FBFF',\
    	    	      1 '#DEEBF7',\
		      2 '#C6DBEF',\
		      3 '#9ECAE1',\
		      4 '#6BAED6',\
		      5 '#4292C6',\
		      6 '#2171B5',\
		      7 '#084594' )

POPU = ''
stats '../data/population.txt' u 2:(POPU = POPU.sprintf(' %i',$2)) prefix 'P' nooutput

set cbrange [P_min_x:P_max_x]
set cblabel "Population of China in 2022"

f(idx) = word(POPU, idx + 1) + 0

set style fill solid
set xrange [M_min:M_max]
plot for [idx=0:32] '../data/china.txt' i idx u 1:2:(f(idx)) w filledcurves lc palette lw 0, '' u 1:2 w lines ls 2