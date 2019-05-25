# Classification Tree with rpart
library(rpart)
library(rpart.plot)

set.seed(50)

# grow tree 
fit <- rpart(Kyphosis ~ Age + Number + Start,
             method="class", data=kyphosis,
             control=rpart.control(cp=0.001))

printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# plot tree 
plot(fit, uniform=TRUE, 
     main="Classification Tree for Kyphosis")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# prune the tree 
pfit<- prune(fit, cp=   fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])

# plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Classification Tree for Kyphosis")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)

setwd("D:/Work/Classes/Advanced analytics/Decision trees/data")
df <- read.csv("car_acceptability.csv")
fit <- rpart(car_accept ~ ., method="class", data=df)
printcp(fit)
plotcp(fit)
plot(fit)

rpart.plot(fit,cex=.5)

text(fit, use.n=TRUE, all=TRUE, cex=.8)
# prune the tree 
pfit<- prune(fit, cp=   fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
# plot the pruned tree 

rpart.plot(pfit,cex=.5)
pr <- predict(fit,df)





setwd("D:/Work/Classes/base-analytics-master/data")
df <- read.csv("florence.csv")
df$Florence <- as.factor(df$Florence)

fit <- rpart(Florence ~ . -Seq -ID, df, 
             control=rpart.control(cp=0.0005),
             method = "class")
rpart.plot(fit)
fit
printcp(fit)
summary(fit)
