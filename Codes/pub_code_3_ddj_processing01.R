# ddj data cleaning and case selection

library(foreign)
library(dplyr)
library(readr)
library(psy)
library(psych)
sessionInfo()

## input the CSV files ####
ddj_tweets_all <- read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE) 
dim(ddj_tweets_all) # original raw:  (126610, 20)
head(ddj_tweets_all)
names(ddj_tweets_all) 

# Data cleaning ####

# 0: cleaning the timestamp
class(ddj_tweets_all$timestamp) #character
ddj_tweets_cleaned <- ddj_tweets_all[!(is.na(ddj_tweets_all$timestamp) | ddj_tweets_all$timestamp=="" | ddj_tweets_all$timestamp=="Nonetimestamp" | ddj_tweets_all$timestamp=="Notimestamp"), ]
head(ddj_tweets_cleaned$timestamp)
dim(ddj_tweets_cleaned) #126608

# 1. cleaning the timestamp_ms
class(ddj_tweets_cleaned$timestamp_ms) #character
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(as.numeric(ddj_tweets_cleaned$timestamp_ms)) | ddj_tweets_cleaned$timestamp_ms=="" | ddj_tweets_cleaned$timestamp_ms=="Nonetimestamp_ms" | ddj_tweets_cleaned$timestamp_ms=="Notimestamp_ms"), ]
ddj_tweets_cleaned$X <- NULL
ddj_tweets_cleaned$Unnamed..0 <- NULL
table(is.na((ddj_tweets_cleaned$timestamp_ms))) 
dim(ddj_tweets_cleaned) #126575

# 2. cleaning userid
head(ddj_tweets_cleaned$userid) 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(as.numeric(ddj_tweets_cleaned$userid)) | ddj_tweets_cleaned$userid=="" | ddj_tweets_cleaned$userid=="Noneid" | ddj_tweets_cleaned$userid=="Noid"), ]
dim(ddj_tweets_cleaned) #126575

# 3. creating the history 
head(ddj_tweets_cleaned$historylength)
class(ddj_tweets_cleaned$historylength) # character 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$historylength) | ddj_tweets_cleaned$historylength=="" | ddj_tweets_cleaned$historylength=="Nonehistory" | ddj_tweets_cleaned$historylength=="Nohistory"), ]
dim(ddj_tweets_cleaned) #126575

# 4. the username (screenname, the names you used to @ someone)
head(ddj_tweets_cleaned$username) 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$username) | ddj_tweets_cleaned$username=="" | ddj_tweets_cleaned$username=="Noneusername" | ddj_tweets_cleaned$username=="Nousername"), ]
dim(ddj_tweets_cleaned) #126575

# 5. cleaning nfollowers, nfollowings, nposts 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$nfollowers) | ddj_tweets_cleaned$nfollowers=="" | ddj_tweets_cleaned$nfollowers=="Nonefollowers" | ddj_tweets_cleaned$nfollowers=="Nofollowers"), ]
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$nfollowings) | ddj_tweets_cleaned$nfollowings==""  | ddj_tweets_cleaned$nfollowings=="Nonefriends" | ddj_tweets_cleaned$nfollowings=="Nofriends" ), ]
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$nposts) | ddj_tweets_cleaned$nposts=="" | ddj_tweets_cleaned$nposts=="Noneposts" | ddj_tweets_cleaned$nposts=="Noposts" ), ]

# 6. cleaning geo disclosure (self-disclosure on geographical locations)
class(ddj_tweets_cleaned$geodisclosure)
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$geodisclosure) | ddj_tweets_cleaned$geodisclosure=="" | ddj_tweets_cleaned$geodisclosure=="Nonedisclosure" | ddj_tweets_cleaned$geodisclosure=="Nodisclosure" ), ]

# 7. cleaning verified status
class(ddj_tweets_cleaned$bigV)
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$bigV) | ddj_tweets_cleaned$bigV=="" | ddj_tweets_cleaned$bigV=="NonebigV" | ddj_tweets_cleaned$bigV=="NobigV" ), ]
dim(ddj_tweets_cleaned)

# 8. cleaning the biography 
class(ddj_tweets_cleaned$biography) 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$biography) | ddj_tweets_cleaned$biography==""), ]
dim(ddj_tweets_cleaned)   # 126574

# 9. cleaning tweet 
# here is different, should remove those without text 
class(ddj_tweets_cleaned$tweet) 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$tweet) | ddj_tweets_cleaned$tweet=="" | ddj_tweets_cleaned$tweet=="Nonetext" | ddj_tweets_cleaned$tweet=="Notext"), ]
dim(ddj_tweets_cleaned) #126561

# 10. userlocation 
class(ddj_tweets_cleaned$userlocation) 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$userlocation) | ddj_tweets_cleaned$userlocation==""), ]
ddj_tweets_cleaned$userlocation_tolower <- sapply(ddj_tweets_cleaned$userlocation, tolower)
dim(ddj_tweets_cleaned) # 126541

# 11. place and place_code are sense making because it is the country 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$place) | ddj_tweets_cleaned$place==""), ]
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$place_code) | ddj_tweets_cleaned$place_code==""), ]
dim(ddj_tweets_cleaned) # 126541

# 12. timezone 
class(ddj_tweets_cleaned$timezone)
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$timezone) | ddj_tweets_cleaned$timezone==""), ]
dim(ddj_tweets_cleaned) #126541
ddj_tweets_cleaned$timezone_tolower <- sapply(ddj_tweets_cleaned$timezone, tolower)

# 13. user-defined language settings
class(ddj_tweets_cleaned$language)
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$language) | ddj_tweets_cleaned$language==""), ]
ddj_tweets_cleaned$language_formatted <- sapply(ddj_tweets_cleaned$language, tolower)
ddj_tweets_cleaned$language_formatted <- sub('\\-.*','',ddj_tweets_cleaned$language_formatted)  

# 14. finally, devices 
ddj_tweets_cleaned <- ddj_tweets_cleaned[!(is.na(ddj_tweets_cleaned$sourcedevice) | ddj_tweets_cleaned$sourcedevice=="" | ddj_tweets_cleaned$sourcedevice=="Nonesource" | ddj_tweets_cleaned$sourcedevice=="Nosource"), ]
dim(ddj_tweets_cleaned) # 126541

# 15. export the output as the cleaned and technically correct dataset (126541, 19)
write.csv(ddj_tweets_cleaned, file= "data_3a_ddjtweets_cleaned.csv" )

# end of primilary data cleaning 

## Case selection ----

# Keeping the verified accounts only 
ddj_tweets_bigVonly <- ddj_tweets_cleaned[ddj_tweets_cleaned$bigV=="True", ] 
dim(ddj_tweets_bigVonly) # n = 11247; 11247/126541, % = 0.08888028

## the raw texts: all the tweets from the verified accounts 
write.csv(as.data.frame(ddj_tweets_bigVonly), file="data_3b_ddj_tweets_bigVonly.csv")

# end of case selection 





