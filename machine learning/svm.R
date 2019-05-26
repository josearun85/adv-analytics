library(caret)

setwd("D:/Work/Classes/Advanced analytics/Decision trees/data")
df <- read.csv("car_acceptability.csv")

set.seed(100)
indx <- sample(1:nrow(df), 1400)
train <- df[indx,]
test <- df[-indx,]


names(getModelInfo())


fit <- train(car_accept ~ .,train, method="svmLinear")

prd <- predict(fit,test)
