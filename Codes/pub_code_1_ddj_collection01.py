
import sys
import tweepy
import codecs
import json
import datetime

import time

from time import clock
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

access_token = "**"
access_token_secret = "**"
consumer_key = "**"
consumer_secret = "**"


# file = open("tweets_dd.csv",'wb') # save to a local csv file

current_milli_time = lambda: int(round(time.time() * 1000))

#override tweepy.StreamListener to add logic to on_status
class MyStreamListener(tweepy.StreamListener):
	currentfilename = ""
	file = None
	errfilenameJson = "errorJson.json"
	errfilenameMsg = "errorMsg.txt"
	errfile = None
	errCount = 0


	def on_data(self, data):
		try: 
			currentTS_milli = current_milli_time()
			target_date_time_ms = currentTS_milli
			base_datetime = datetime.datetime( 1970, 1, 1 )
			delta = datetime.timedelta( 0, 0, 0, target_date_time_ms )
			target_date = base_datetime + delta
			#dateString = target_date.strftime('%a, %d %b %Y %H:%M:%S GMT')
			dateString = target_date.strftime('%Y%m%d')
			
			filenameJson = dateString + "_" + str(currentTS_milli) + ".json"
			self.file = open(filenameJson, "wb")
			print >>self.file, data
			self.file.close()
			
		except Exception, e:
			currentTS_milli = current_milli_time()
			target_date_time_ms = currentTS_milli
			base_datetime = datetime.datetime( 1970, 1, 1 )
			delta = datetime.timedelta( 0, 0, 0, target_date_time_ms )
			target_date = base_datetime + delta
			#dateString = target_date.strftime('%a, %d %b %Y %H:%M:%S GMT')
			dateString = target_date.strftime('%Y%m%d')
			
			filenameJson = dateString + "_" + str(currentTS_milli) + "_err.json"
			self.file = open(filenameJson, "wb")
			print >>self.file, data
			self.file.close()
			pass
		
	def on_error(self, status_code):
			if status_code == 420:
				#returning False in on_data disconnects the stream
				return False
				
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

# Get the User object for twitter...
user = api.get_user('twitter')


myStreamListener = MyStreamListener()
myStream = tweepy.Stream(auth = api.auth, listener=myStreamListener)
myStream.filter(track=['datajournalism','datadrivenjournalism','computationaljournalism','computerassistedreporting','data journalism','data-driven journalism','computational journalism','computer-assisted reporting'])
