
# This Python file scrapes the public profiles of the accounts 

import requests
from bs4 import BeautifulSoup
import pandas as pd
import csv

from time import sleep
from random import randint
from time import time

#url = u'https://twitter.com/search?q='
url = u'https://twitter.com/'

def start_request(q):
    r = requests.get(url+q)
    print(url+q)
    return r.text

def parse(text, req):
    soup = BeautifulSoup(text, 'html.parser')
    soupfindall = soup.find_all('div', class_='ProfileHeaderCard')
    soupfindall2 = soup.find_all ('div', class_="ProfileCanopy-nav")
    mydict = {}
    mydict['accountname']=req
    for soupall in soupfindall:
        try:
            mydict['name'] = soupall.find('span', class_ = "username u-dir").find("b", class_="u-linkComplex-target").get_text()
        except:
            mydict['name'] = 'null'
        try:
            mydict['biography'] = soupall.find('p', class_ = "ProfileHeaderCard-bio u-dir").get_text()
        except:
            mydict['biography'] = 'null'
        try:
            mydict['location'] = soupall.find('span',class_= "ProfileHeaderCard-locationText u-dir").get_text()
        except:
            mydict['location'] = 'null'
        try:
            mydict['joindate'] = soupall.find('span', class_= "ProfileHeaderCard-joinDateText js-tooltip u-dir")["title"]
        except:
            mydict['joindate'] = 'null'
    for soupall in soupfindall2:
        try:
            twclass = soupall.find("a", class_= "ProfileNav-stat ProfileNav-stat--link u-borderUserColor u-textCenter js-tooltip js-nav")
            mydict['tweetcounts'] = twclass.find("span", class_="ProfileNav-value")["data-count"]
        except:
            mydict['tweetcounts'] = 'null'
        try:
            fwiclass = soupall.find('li', class_= "ProfileNav-item ProfileNav-item--following")
            mydict['following'] = fwiclass.find("span",class_="ProfileNav-value")["data-count"]
        except:
            mydict['following'] = 'null'
        try:
            fweclass = soupall.find("li", class_ = "ProfileNav-item ProfileNav-item--followers")
            mydict['followers'] = fweclass.find('span', class_="ProfileNav-value")["data-count"]
        except:
            mydict['followers'] = 'null'
    result_list.append(mydict)

def main(req):
    t = start_request(req)
    parse(t, req)

def read_csv(filename):
    with open(filename) as f:
        reader = csv.DictReader(f)
        for row in reader:
            people_name = row['username']
            main(people_name)
            sleep(randint(6, 13))

result_list = []

# all the usernames
read_csv('nodenames.csv') 

ddj_profiles_auto = pd.DataFrame(result_list)
ddj_profiles_auto.to_csv('ddj_profiles_auto.csv')

# This output file will be sent to two human coders for further manual labeling and verification 




