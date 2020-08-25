from flask import Flask
from flask import request
app = Flask(__name__)
import json
from statsmodels.tsa.api import ExponentialSmoothing, SimpleExpSmoothing, Holt
from statsmodels.tsa.arima_model import ARIMA
import math

FCAST_HORIZON=10

@app.route('/')
def hello():
    return "I am coming from app"

# simple exponential
def simpleExp(data):
	ses = SimpleExpSmoothing(data).fit()
	sesfcast = ses.forecast(FCAST_HORIZON)
	return sesfcast
	
# holt linear method
def holt(data):
	hlt = Holt(data).fit(smoothing_level=0.8, smoothing_slope=0.2, optimized=False)
	holtfcast = hlt.forecast(FCAST_HORIZON)
	return holtfcast

# holt linear method
def expSmooth(data):
	expSm = ExponentialSmoothing(data, seasonal_periods=4, trend='add', seasonal='add').fit(use_boxcox=True)
	expSmfcast = expSm.forecast(FCAST_HORIZON)
	return expSmfcast

	
# arima
def arimaFit(data):
	expSm = ARIMA(data, order=(1,1,1)).fit(use_boxcox=True)
	expSmfcast = expSm.predict(start=len(data),end=len(data)+FCAST_HORIZON)
	return expSmfcast

def rmse(x,y):
	err = 0
	for i in range(0,FCAST_HORIZON):
		err = err + (x[i]-y[i])*(x[i]-y[i])
	return math.sqrt(err)
	
@app.route('/predict',methods=['POST'])
def predict():
	my_data = request.json["data"]
	print(my_data)
	if(len(my_data) <= 15):
		return json.dumps({"error":"Data not enough to build model"}),200

	# 1. split into train test [train: everything else ; test: last 10]
	train = my_data[0:len(my_data)-FCAST_HORIZON]
	test = my_data[len(my_data)-FCAST_HORIZON:]
	
	# 2. fit each model type and get forecasts 
	ses_pred = simpleExp(train)
	holt_pred = holt(train)
	expsm_pred = expSmooth(train)
	#arm_pred = arimaFit(train)
	
	ses_rmse = rmse(ses_pred,test)
	holt_rmse = rmse(holt_pred,test)
	expsm_rmse = rmse(expsm_pred,test)
	min_rmse = min(ses_rmse,holt_rmse,expsm_rmse)
	
	# 3. pick best model from all forecasts # use rmse
	# 4. refit best model to full data and make forecasts
	if(ses_rmse==min_rmse):
		final = simpleExp(my_data)
		choice = "ses"
	elif(holt_rmse==min_rmse):
		final = holt(my_data)
		choice="holt"
	else:
		final = expSmooth(my_data)
		choice = "exp smooth"	
	# 5. return this value to the callers

	result = json.dumps({"data":list(final),"choice":choice})
	print(result)

	return result,200
	

if __name__ == '__main__':
    app.run()