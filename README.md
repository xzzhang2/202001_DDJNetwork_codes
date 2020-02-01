# 202001_DDJNetwork_codes

 - This repository contains the replication codes of the paper *Exploring the fragmentation of the representation of data-driven journalism in the Twittersphere: A network analytics approach*.

 - [**Update**] The paper has been accepted by *Social Science Computer Review* in Jan 2020 and will be forthcoming.

 - Citation Information: Zhang, X. & Ho, J. C. F. (forthcoming). Exploring the fragmentation of the representation of data-driven journalism in the Twittersphere: A network analytics approach. *Social Science Computer Review*. [SSCI]

 - Authors Information: **Xinzhi Zhang** & **Jeffrey C. F. Ho**. Xinzhi Zhang (Ph.D., City University of Hong Kong) is an Assistant Professor at the Department of Journalism at Hong Kong Baptist University (xzzhang2@gmail.com). Jeffrey C. F. Ho (Ph.D., City University of Hong Kong) is an Assistant Professor at the School of Design of Hong Kong Polytechnic University (jeffrey.cf.ho@polyu.edu.hk). Corresponding: Xinzhi Zhang, Department of Journalism, Hong Kong Baptist University, Kowloon Tong, Hong Kong. ORCID: 0000-0003-3479-9327.

 - The codes include:

  1. A *readme.txt* file;
  2. *code_1_ddj_collection01.py* (The Python code has been executed for one year on a cloud computing service for accessing to Twitter Streaming API and collection the tweets containing the search keywords.)
  3. *code_2_ddj_appendingCSV.py* (This file append (concat) all the CSV files in the folder [1_ddj_Tweets_RawCSV] into one csv file. )
  4. *code_3_ddj_processing01.R* (This file cleans the raw data, and tweets that only sent by the **verified users** were retained.)
  5. *code_4_ddj_processing02.ipynb* (This Python file, processing 02, constructs the co-retweeted network (Finn et al., 2014)).
  6. *code_5_ddj_networkmodels.R* (This R file performs all sort of network analysis for the co-retweeted network in step 4.)
  7. *code_6_ddj_collection2.py* (This Python file scrapes the users’ profile with the known user names (without logging in and API as the information is publicly available at the users’ homepage).)

- Notes:

  1. A small part of the result of this project was included in a [Department of Computer Science Seminar - 2019 Series](https://www.comp.hkbu.edu.hk/v1/?page=seminars&id=540) in Sep 2019 as a case demonstration on the usage of social network analysis in the studies of communication practices on social media. The seminar was organized by the [DAAI University Research Cluster of HKBU](http://hkbu.ai/).
  2. Acknowledgment: The authors would like to thank the three anonymous reviewers for their insightful comments, and the help from Can He, Chen Xu, Ryan Ng, Minyi Chen, and Xiaohang Deng. The second author would like to thank the School of Design, Hong Kong Polytechnic University for their continuous support.
