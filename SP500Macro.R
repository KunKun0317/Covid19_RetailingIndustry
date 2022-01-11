# VAR in R using China Data

# Load required packages for running VAR

library(urca)
library(vars)
library(mFilter)
library(tseries)
library(forecast)
library(tidyverse)
library(ggplot2)
library(ggfortify)
library(lubridate)
library(dplyr)
library(tseries)
library(zoo)
library(scales)
library(TSstudio)

# Load the DataSet

SimRet <- function(data){
  sr <- diff(data)/na.omit(lag(data, k=-1))
  return(sr)
}

## Load the Crude Oil Prices
OilPrice <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/Macroeconomic_data/Crude-Oil-Price-USD-Nasdaq.csv")
OilPrice$newdate <- strptime(as.character(OilPrice$Date),"%m/%d/%Y")
format(OilPrice$newdate, "%Y-%m-%d")

OilPrice$quarter <- floor_date(OilPrice$newdate, "quarter")
df <- OilPrice %>%
  group_by(quarter) %>%
  summarize(mean = mean(`Close/Last`))

QuarterlyPrice <- data.frame(date = as.Date(df$quarter), price = df$mean)
quarter.r <- SimRet(QuarterlyPrice$price)
# oilprice <- ts(QuarterlyPrice$price, start = c(2014,1), end = c(2019,4),frequency = 4)
oilprice <- ts(quarter.r, start = c(2014,1), end = c(2019,4),frequency = 4)
ts.plot(oilprice, gpars=list(xlab="Year", ylab="Quarterly Oil Price (USD)"))

## Load Gold Prices
GoldPrice <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/Macroeconomic_data/Gold-price-USD-INVESTING.csv")
GoldPrice$newdate <- strptime(as.character(GoldPrice$Date),"%b %d,%Y")
format(GoldPrice$newdate, "%Y-%m-%d")
GoldPrice$quarter <- floor_date(GoldPrice$newdate, "quarter")
df <- GoldPrice %>%
  group_by(quarter) %>%
  summarize(mean = mean(Price))

GoldQuarterlyPrice <- data.frame(date = as.Date(df$quarter), price = df$mean)
gold.r <- SimRet(GoldQuarterlyPrice$price)
goldprice <- ts(gold.r, start = c(2014,1), end = c(2019,4), frequency = 4)
# goldprice <- ts(GoldQuarterlyPrice$price, start = c(2014,1), end = c(2019,4), frequency = 4)
ts.plot(goldprice, gpars=list(xlab="Year", ylab="Quarterly Gold Price (USD)"))

## Load S&P 500 Index
SP500 <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/Macroeconomic_data/Global_Index/美国标准普尔500指数历史数据 (1).csv")
SP500$newdate <- strptime(as.character(SP500$日期),"%Y年%m月%d日")
format(SP500$newdate, "%Y-%m-%d")
SP500$quarter <- floor_date(SP500$newdate, "quarter")
df <- SP500 %>%
  group_by(quarter) %>%
  summarize(mean = mean(收盘))

SP500Price <- data.frame(date = as.Date(df$quarter), price = df$mean)
sp500.r <- SimRet(SP500Price$price)
sp500 <- ts(sp500.r, start = c(2014,1), end = c(2019,4), frequency = 4)
# sp500 <- ts(SP500Price$price, start = c(2014,1), end = c(2019,4), frequency = 4)
ts.plot(sp500, gpars=list(xlab="Year", ylab="S&P 500 Index (USD)"))

## Load CPI Data
CPI <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/CPI_MONTHLY.csv")
CPI$quarter <- floor_date(CPI$...1, "quarter")
df <- CPI %>%
  group_by(quarter) %>%
  summarize(mean = mean(`United States`))

CPI.r <- data.frame(date = as.Date(df$quarter), price = df$mean)
cpi <- ts(CPI.r$price, start = c(2014,1), end = c(2019,4), frequency = 4)
ts.plot(cpi, gpars=list(xlab="Year", ylab="Custormer Price Index (USD)"))

## Load GDP Data
GDP <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/GDP_Q.csv")
GDP.r <- data.frame(date = as.Date(as.yearqtr(GDP$Date,format="%YQ%q")), price = GDP$US)
gdp.r <- SimRet(GDP.r$price)
gdp <- ts(gdp.r, start = c(2014,1), end = c(2019,4), frequency = 4)
ts.plot(gdp, gpars=list(xlab="Year", ylab="Seasonally Adjusted GDP (USD)"))

## Load US Covid data
USCovid <- read_csv("/Users/libingxin/Desktop/PhD/R_studio/R-computing/Thesis/US_Covid19.csv")
USCovid$month <- floor_date(USCovid$`# Date_reported`, "month")
df <- USCovid %>%
  group_by(month) %>%
  summarize(mean = mean(New_cases))
NewCase <- data.frame(date = as.Date(df$month), price = df$mean)
newcase <- ts(NewCase$price, start = c(2020,1), end = c(2021,11), frequency = 12)

# Determine the persistence of the model
acf(oilprice, main = "ACF for Oil Price")
pacf(oilprice, main = "PACF for Oil Price")

acf(goldprice, main = "ACF for Gold Price")
pacf(oilprice, main = "PACF for Gold Price")

acf(sp500, main = "ACF for SP500 Price")
pacf(sp500, main = "PACF for SP500 Price")

acf(cpi, main = "ACF for CPI")
pacf(cpi, main = "PACF for CPI")

acf(gdp, main = "ACF for GDP")
pacf(gdp, main = "PACF for GDP")

acf(newcase, main = "ACF for New Cases")
pacf(newcase, main = "PACF for New Cases")

# Doing the Augmented Dickey-Fuller Test
adf.test(oilprice)
adf.test(goldprice)
adf.test(sp500)
adf.test(cpi)
adf.test(gdp)
adf.test(newcase)

# Finding the Optimal Lags

macro.bv <- cbind(oilprice,goldprice,gdp,cpi,sp500)
colnames(macro.bv) <- cbind("Oil Price","Gold Price","GDP","CPI","SP500")
lagselect <- VARselect(macro.bv, lag.max = 10, type = "const")
lagselect$selection

# Build the Model
ModelSP500 <- VAR(macro.bv, p = 3, type = "const", season = NULL, exog = NULL)
summary(ModelSP500)

# Diagnosing the VAR

# Serial Correlation
Serial1 <- serial.test(ModelSP500, lags.pt = 12, type = "PT.asymptotic")
Serial1

# Heteroscedasticity

Arch1 <- arch.test(ModelSP500, lags.multi = 3, multivariate.only = TRUE)
Arch1

# Granger Causality
GrangerSP500 <- causality(ModelSP500, cause = "SP500")
GrangerSP500

# Impulse Response Functions

SP500irf <- irf(ModelSP500, impulse = "GDP", response = "SP500", n.ahead = 20, boot =TRUE)
plot(SP500irf, ylab ="SP500 Index", main="Shock from GDP")

# Variance Decomposition
FEVD <- fevd(ModelSP500, n.ahead = 10)
plot(FEVD)

# VAR Forecasting

forecast <- predict(ModelSP500, n.ahead = 4, ci = 0.95)
fanchart(forecast, names ="SP500")
