
import pandas as pd
import glob, os

path = r'../folder_RAW_CSVfiles ' # input files: use the path of the folder 
allFiles = glob.glob(path + "/*.csv")
frame = pd.DataFrame()
list_ = []

for file_ in allFiles:
    df = pd.read_csv(file_, engine='python')
    list_.append(df)

frame = pd.concat(list_)

frame.to_csv('ddjtweets_rawcsv_all.csv')  # the output file is the csv file



