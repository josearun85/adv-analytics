library(randomForest)

setwd("D:/Work/Classes/Advanced analytics/Decision trees/data")
df <- read.csv("car_acceptability.csv")

set.seed(100)
indx <- sample(1:nrow(df), 1400)
train <- df[indx,]
test <- df[-indx,]
rf.model <- randomForest(car_accept ~ ., data = train,
                         ntree = 100, nodesize = 50)
rf.predict <- predict(rf.model, test)
importance(rf.model)
varImpPlot(rf.model)

table(rf.predict,test$car_accept)
summary(rf.model)
rf.predict

confusionMatrix(rf.predict,test$car_accept)
