require(fpp)
library(forecast)
# Please make sure at least v3.10 of the forecast is loaded
# before running these examples.

ausbeer
plot(ausbeer)

# Three examples
beer <- aggregate(ausbeer)
beer
a10
taylor

plot(beer)
plot(a10)
plot(taylor)
a10
plot(decompose(a10))


# Fully automated forecasting
plot(forecast(beer))
plot(forecast(a10))
plot(forecast(taylor))

# Test methods on a test set

beertrain <- window(beer,end=1999)
beertest <- window(beer,start=2000)


a10train <- window(a10,end=2005.99)
a10test <- window(a10,start=2006)


beertrain
beertest


# Simple methods for the BEER data
f1 <- meanf(beertrain,h=8)
f2 <- rwf(beertrain,h=8)
f3 <- rwf(beertrain,drift=TRUE,h=8)
f4<-forecast(beertrain)

plot(f1)
plot(f2)
plot(f3)
plot(f4)

# In-sample accuracy
accuracy(f1)
accuracy(f2)
accuracy(f3)
accuracy(f4)

# Out-of-sample accuracy
accuracy(f1,beertest)
accuracy(f2,beertest)
accuracy(f3,beertest)
accuracy(f4,beertest)

plot(beertrain)

# Builds model on training data
test<-ets(beertrain, model="AAN",damped=FALSE)

#Forecast N periods in to future
fcast_test<-forecast(test,h=8)

#Plot forecasted values
plot(fcast_test)

# Import data
series<-read.csv(file.choose(),header=TRUE)
series
plot(series)
#Convert to time series format
tseries<-ts(series,start=1960,frequency=12)
tseries
plot(tseries)
train<-window(tseries,end=1969.99)
test<-window(tseries,start=1970)

f<-forecast(train,h=24)
plot(f)
lines(test)
accuracy(f)
accuracy(f,test)


#Export data
write.csv(tseries,file.choose())

coef(fit1)
 plot(fit1)
summary(fit1)
 residuals(fit1)
fitted(fit1)
 simulate(fit1)
 
forecast()

# Exponential smoothing
fit1 <- ets(beertrain, model="AAN", damped=FALSE)
fit2 <- ets(beertrain)
fit1
fit2
fcast1 <- forecast(fit1, h=8)
fcast2 <- forecast(fit2, h=8)
plot(fit2)
plot(fcast1)
plot(fcast2)
lines(beertest)
accuracy(fcast1,beertest)
accuracy(fcast2,beertest)

par(mfrow=c(2,1))
plot(a10)
plot(log(a10))


####

par(mfrow=c(2,2))


fit<-forecast(a10train,h=8) # Automated forecast
summary(fit)
forecast(fit1,h=8)
forecast(fit2)
accuracy(forecast(a10train,h=8),a10test)

# Transformations
# Check accuracy without transformation
fit11<-ets(a10train)
fcast11<-forecast(fit11,h=8)
accuracy(fcast11,a10test)
plot(fcast11)

fit13<-ets(a10train, model="MMM", damped=FALSE)
fcast13<-forecast(fit13,h=8)
accuracy(fcast13,a10test)
plot(fcast13)


#Check accuracy after transformation

lam <- BoxCox.lambda(a10train)
lam<-0.13
fit51 <- ets(a10train, lambda=lam,additive=TRUE)
fcast51<-forecast(fit51,h=8)
accuracy(fcast51,a10test)
plot(fcast51)


# Check accuracy of auto
fcast31<-forecast(a10train,h=8)
accuracy(fcast31,a10test)
plot(fcast31)




lam <- BoxCox.lambda(a10)
fit5 <- ets(a10, additive=TRUE, lambda=lam)
fit6 <- ets(a10, lambda=lam)

plot(forecast(fit5))
plot(forecast(fit6))
plot(forecast(fit6),include=60)
plot(forecast(fit6))

# ARIMA forecasting

tsdisplay(beertrain)
tsdisplay(diff(beertrain))
tsdisplay(diff(diff(beertrain)))
tsdisplay(a10train)
tsdisplay(diff(a10train))
tsdisplay(diff(diff(beertrain)))
tsdisplay(taylor)

summary(fit1)

fit1 <- Arima(beertrain, order=c(0,1,0))
fit11<- Arima(beertrain, order=c(0,2,0))

fit2 <- Arima(beertrain, order=c(1,1,0))
fit21<-Arima(beertrain, order=c(2,1,0))
fit23<-Arima(beertrain, order=c(2,1,1))
fit4 <- auto.arima(beertrain)

fit22<-Arima(beertrain, order=c(2,2,0))
fit3 <- Arima(beertrain, order=c(0,1,1))
fcast1 <- forecast(fit1,h=8)
fcast11<-forecast(fit11,h=8)
fcast2 <- forecast(fit2,h=8)
fcast21 <- forecast(fit21,h=8)
fcast22 <- forecast(fit22,h=8)
fcast23 <- forecast(fit23,h=8)
fcast3 <- forecast(fit3,h=8)
fcast4 <- forecast(fit4,h=8)

accuracy(fcast1,beertest)
accuracy(fcast11,beertest)
accuracy(fcast2,beertest)
accuracy(fcast21,beertest)
accuracy(fcast22,beertest)
accuracy(fcast23,beertest)
accuracy(fcast3,beertest)
accuracy(fcast4,beertest)

plot(fcast4)
summary(fit4)

fcast1 <- forecast(fit1,h=8)

fcast3<-forecast(beertrain)
plot(fcast1)
plot(fcast2)
plot(fcast3)
lines(beertest)
accuracy(fcast1,beertest)
accuracy(fcast2,beertest)
accuracy(fcast3,beertest)

lam <- BoxCox.lambda(a10train)
tsdisplay(BoxCox(a10train,lam))
tsdisplay(a10train)
tsdisplay(diff(BoxCox(a10train,lam),12))
tsdisplay(diff(diff(BoxCox(a10train,lam),12)))

fit1 <- Arima(a10train,lambda=lam, order=c(2,1,0),seasonal=list(order=c(0,1,2),period=12))
fit2 <- Arima(a10train,lambda=0.06,order=c(3,0,0),seasonal=list(order=c(2,2,3),period=12))
fit3 <- auto.arima(a10train)
fcast4<-forecast(a10train,h=30,lambda=lam)

fcast1 <- forecast(fit1,h=30)
fcast2 <- forecast(fit2,h=30)
fcast3 <- forecast(fit3,h=30)

accuracy(fcast1,a10test)
accuracy(fcast2,a10test)
accuracy(fcast3,a10test)
accuracy(fcast4,a10test)


plot(fcast1)
plot(fcast2)
plot(fcast3)
plot(fcast4)

plot(fcast1,include=60)

lines(fcast2$mean,col="red")
lines(a10test)

accuracy(fcast1,a10test)
accuracy(fcast2,a10test)
fit1
# High frequency data
plot(taylor)
taylor.stl <- stl(taylor,s.window=7)
plot(taylor.stl)
plot(seasadj(taylor.stl))
fcast <- forecast(taylor.stl)
plot(fcast)

# Equivalent to:
fcast <- stlf(taylor)
plot(fcast)
?stl
# Double frequency data

fcast <- dshw(taylor,336,48)
plot(fcast)

# Time series cross-validation

k <- 196
n <- length(a10)
mae1 <- mae2 <- mae3 <- matrix(NA,n-k-1,12)
for(i in 1:(n-k-1))
{
  xshort <- window(a10,end=1995+5/12+i/12)
  xnext <- window(a10,start=1995+(6+i)/12,end=1996+(5+i)/12)
  fit1 <- tslm(xshort ~ trend + season, lambda=0)
  fcast1 <- forecast(fit1,h=12)
  fit2 <- auto.arima(xshort, lambda=0)
  fcast2 <- forecast(fit2,h=12)
  fit3 <- ets(xshort)
  fcast3 <- forecast(fit3,h=12)
  mae1[i,] <- c(abs(fcast1$mean-xnext),rep(NA,12-length(xnext)))
  mae2[i,] <- c(abs(fcast2$mean-xnext),rep(NA,12-length(xnext)))
  mae3[i,] <- c(abs(fcast3$mean-xnext),rep(NA,12-length(xnext)))
}
     
plot(1:12,colSums(mae3,na.rm=TRUE),type="l",col=4,xlab="horizon",ylab="MAE")
lines(1:12,colSums(mae2,na.rm=TRUE),type="l",col=3)
lines(1:12,colSums(mae1,na.rm=TRUE),type="l",col=2)
legend("topleft",legend=c("LM","ARIMA","ETS"),col=2:4,lty=1)