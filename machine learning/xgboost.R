library(xgboost)

data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')
train <- agaricus.train
test <- agaricus.test

model <- xgboost(data = train$data, label = train$label,
                 nrounds = 2, objective = "binary:logistic",
                 params = list(eta=0.2))
summary(model)
preds = predict(model, test$data)

cv.res <- xgb.cv(data = train$data, label = train$label, nfold = 5,
                 nrounds = 2, objective = "binary:logistic")


table(test$label,preds)
