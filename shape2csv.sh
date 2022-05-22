while getopts o:i: flag
do
    case "${flag}" in
        o) output=${OPTARG};;
        i) input=${OPTARG};;
    esac
done
ogr2ogr -f CSV $output.csv $input.shp -lco GEOMETRY=AS_WKT