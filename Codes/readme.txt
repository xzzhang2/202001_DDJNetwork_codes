readme.txt

# Replication codes for the submission Exploring the fragmentation of the representation of data-driven journalism in the Twittersphere: A network analytics approach 
# authors: Xinzhi Zhang, Hong Kong Baptist University; Jeffrey C. F. Ho, Hong Kong Polytechnic University 
# manuscript revised and resubmitted to Social Science Computer Review on 20 Jan 2020 

#Filenames and Notes
code_1_ddj_collection01.py 
The Python code has been executed for one year on a cloud computing service for accessing to Twitter Streaming API and collection the tweets containing the search keywords. 

code_2_ddj_appendingCSV.py
This file append (concat) all the CSV files in the folder [1_ddj_Tweets_RawCSV] into one csv file

code_3_ddj_processing01.R
This file cleans the raw data, and tweets that only sent by the **verified users** were retained. 

code_4_ddj_processing02.ipynb
This Python file, processing 02, constructs the co-retweeted network (Finn et al., 2014).  (by Can He 0409) 

code_5_ddj_networkmodels.R
This R file performs all sort of network analysis for the co-retweeted network in step 4. 

code_6_ddj_collection2.py
This Python file scrapes the users’ profile with the known user names (without logging in and API as the information is publicly available at the users’ homepage). 
