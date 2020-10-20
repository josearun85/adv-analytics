import requests
import json
import pandas as pd
import time
from matplotlib import pyplot as plt
import numpy as np

url = "http://127.0.0.1:5000/predict"

df=pd.read_csv("live_weather.csv")

df = df.drop_duplicates("id").reset_index(drop=True)


# prepare the data
# clean you data, to extract non duplicates
# 1 point per minute

#print(df.head())
#print(df.shape)
print(df.columns)

# extract temperature column
# call forecast api
# get next one hour forecast

# Load real time data into body every minute
body = {"data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]}


body = {"data":df.loc[:,"the_temp"].tolist()}
print("request",body)
res = requests.post(url,json=body)
print(res.status_code)
fcast = json.loads(res.content)

if("error" not in fcast):
	print(fcast)
	# next 10 values


	dff=pd.DataFrame({"actual":df["the_temp"]})
	dff["forecast"]=np.nan

	dfff=pd.DataFrame({"forecast":fcast["data"]})
	dfff["actual"]=np.nan

	final = pd.concat([dff,dfff],axis=0).reset_index()
	print(final.head())
	plt.plot(final.index,final["actual"],label="actual")
	plt.plot(final.index,final["forecast"],label="forecast")
	plt.legend()
	plt.savefig('myforecast.png')
else:
	print("Error",fcast)