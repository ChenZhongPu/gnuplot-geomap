set terminal svg size 1000,800 enhanced font 'Verdana,20'
set out "china1.svg"

unset key
set border 0
unset tics

set style line 1 lc rgb '#999999' lt 1 lw 0 # --- grey 
set style line 2 lc rgb '#ffffff' lt 1 lw 0.5 # --- white

stats '../data/china.txt' u 1 nooutput
set xrange [STATS_min:STATS_max]

plot for [idx=0:32] '../data/china.txt' i idx u 1:2 w filledcurves ls 1, '' u 1:2 w lines ls 2