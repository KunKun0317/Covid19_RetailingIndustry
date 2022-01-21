for i in $(ls *.xlsx)
do
python3 xls2csv.py -f $i
done
