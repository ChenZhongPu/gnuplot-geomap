# Tutorial: USA Map

## Download shapes file
There are many shapes files available on the Internet. As for the USA map, you can download it from [Earthworks](https://earthworks.stanford.edu/catalog/stanford-vt021tk4894). After downloaded, you can extract files:

```
├── state-fgdc.xml
├── state-iso19110.xml
├── state-iso19139.xml
├── state.dbf
├── state.prj
├── state.sbn
├── state.sbx
├── state.shp
├── state.shp.xml
└── state.shx
```

## Convert to CSV

```bash
ogr2ogr -f CSV usa.csv state.shp -lco GEOMETRY=AS_WKT
```

The resulting is nearly 116 MB, because it has a relatively high resolution.

## Pre-processing

Then we need to get the summarization of the data, because you have to understand your data before plotting. The following is based on *bash command*, and you can also use any other tools/languages (e.g., `pandas` in Python).

```bash
# First line (filed names)
head -1 usa.csv
```

> WKT,STFIPS,STATE,STPOSTAL,DotRegion

The 1st column `WKT` is the *polygon* (or *multipolygon*), and the 3rd column `STATE` is the region's name.

Now let's have a look at a data row (or use `less`):

```bash
awk 'NR==2' usa.csv
```

> "POLYGON ((-79.4766651051004 39.7210858526213,-79.4766741050385 39.7201548524396, ... "54",West Virginia,WV,"3"

Next, let's check how many lines there are.

```bash
wc -l usa.csv
```

The result is 57, indicating there are 56 regions. Sometimes we may would like to use 50 principal political divisions (e.g. showing election results). So we need to filter those unneeded lines. 

> People who know USA may quickly realize the extra 6 regions are the District of Columbia, and the [five major U.S. territories](https://en.wikipedia.org/wiki/Territories_of_the_United_States).

Let's print all states in the data by getting its last 3rd column:

```bash
cat usa.csv | rev | cut -d, -f 3 | rev
```

| STATE |
| ---- |
| West Virginia |
| Florida |
| Illinois |
| Minnesota |
| Maryland |
| Rhode Island |
| Idaho |
| ... |

After a careful checking, we can find the data contains:

- United States Virgin Islands
- Commonwealth of the Northern Mariana Islands
- American Samoa
- Puerto Rico
- Guam
- District of Columbia

Since both Hawaii and Alaska are located differently, it would be nice to place those two regions as the last two in the result.

## Convert to Txt

```bash
python3 usa.csv --name=STATE --last Hawaii Alaska --filter "Virgin Islands" Mariana Samoa Rico Guam Columbia
```

This command would convert csv file to txt (`out.txt`) for gnuplot. Note that the `--filter` option is to filter rows whose region name *contains* those names; and `--last` option is to put both Hawaii and Alaska at the end of the result.

## Plot

```gnuplot
set terminal pngcairo transparent size 800,800 enhanced font 'Verdana,16'
set out 'usa.png'

unset key
set border 0
unset tics

set style line 1 lc rgb '#999999' lt 1 lw 0 # --- grey 
set style line 2 lc rgb '#ffffff' lt 1 lw 0.5 # --- white

# skip last two rows: Hawaii and Alaska

stats 'out.txt' i 0:47 u 1 nooutput
set xrange [STATS_min:STATS_max]

plot for [idx=0:47] 'out.txt' i idx u 1:2 w filledcurves ls 1, '' u 1:2 w lines ls 2
```

![usa](usa.png)