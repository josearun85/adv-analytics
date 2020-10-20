import requests
import json
import pandas as pd
import time
## Where is my prediction server
#url = "http://127.0.0.1:5000/predict"

city_of_interest = "bangalore"


# weather api url
loc_url = "https://www.metaweather.com/api/location/search/?query="+city_of_interest
loct = requests.get(loc_url)
locations = json.loads(loct.content)
print(locations)

woeid = locations[0]["woeid"]

url_city_weather = "https://www.metaweather.com/api/location/"+str(woeid)+"/"


try:
	f=1
	df=pd.read_csv("live_weather.csv")
except:
	f=0
while True:
	live_weather = requests.get(url_city_weather)
	live_weather = json.loads(live_weather.content)
	if(f):
		df = pd.concat([pd.DataFrame(live_weather['consolidated_weather']),df])
	else:
		df = pd.DataFrame(live_weather['consolidated_weather'])
	print(df.head())
	df.to_csv("live_weather.csv",index=False)
	time.sleep(60)
	
	
exit()

# Load real time data into body every minute
body = {"data":[10,2,3,4,5]}

# POST raw data to the prediction server
# Decode the response
for i in range(0,5):
	body["data"][0]=body["data"][0]+1
	print("Body is:",body)
	res = requests.post(url, json= body)
	print(res.status_code)
	mypred = json.loads(res.content)
	print("Prediction is:",mypred)
	