for i in $(ls *.csv)
do
/usr/local/bin/Rscript --vanilla *mod.R $i > $i.output
done
