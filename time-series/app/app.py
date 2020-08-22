from flask import Flask
from flask import request
app = Flask(__name__)
import json

@app.route('/')
def hello():
    return "I am coming from app"
	
@app.route('/predict',methods=['POST'])
def predict():
    my_data = request.json["data"]
    my_pred = my_data[0]+1
    return json.dumps({"data":my_pred}),200
	

if __name__ == '__main__':
    app.run()