import pandas as pd
import numpy as np
import argparse

parser = argparse.ArgumentParser(description="Convert Excel File into CSV File")
parser.add_argument('-f', action='store', dest='filename', help='set the filename')
args = parser.parse_args()

file = args.filename
csvname = file.split('.')[0] + '.csv'

df = pd.read_excel(file)
if (df['Date'].to_numpy() < np.datetime64('2015-01-01')).sum() > 0:
    df.to_csv(csvname)
else:
    print('%s cannot be used' % file.split('.')[0])
