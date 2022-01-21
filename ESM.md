* **Event Study Methodology (ESM)**

  This method is cited from [The impact of the SARS outbreak on Taiwanese hotel stock performance: An event-study approach](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7116915/)
  
  1. To study the impact of Covid-19 outbreak on monthly stock price, we can calculate the one-month stock returns (SR), which is based on changes in monthly closing stock price :
  $S R=\ln \left(P_{\text {May }} / P_{\text {April }}\right)-100$
  
  2. ESM has been widely used to measure the effect of an ecnomic event on the portfolio(stock price) of a firm. The very first propety is called as "abnormal" return (AR), which is computed as the difference between actual return and expected return around the time of the event. A negative AR signals bad news. Acoordingly, the cumulative mean abnormal return(CAR) and the mean abnormal return should be calculated. Then the statistical significance of the CARs is tested. 
  3. Measuring AR/hypothesis:
  * First step is to calculate the expected returns (ER) of hotel stocks: regressing the stock return against return of the market index to control the overall market effects:
  $R_{j, t}=\alpha_{j}+\beta_{j} R_{m, t}+\varepsilon_{j, t}$
  where $R_{j, t}$ is the return of the stock i on day t, which is calculated from:
  $R_{j, t}=\ln \left(P_{j, t} / P_{j, t-1}\right) \times 100$
  
  * The next step is to estimate the event window $[-t_1,t_2]$, for example, in the SARS event, the estimation period is about 232 days. Then the estimated coefficients from the regression to calculated the ER of the stocks over the event window. 
  $\begin{aligned}
&A R_{j, t}=R_{j, t}-E R_{j, t} \\
&E R_{j, t}=\hat{\alpha}_{j}+\hat{\beta}_{j} R_{m, t}
\end{aligned}$

  * Consequently, the abnormal return is decomposed into two parts: a market-determined part (the expected stock return) and a firm-specific component. 
  * The standardized abnormal return (SAR) is defined as:
  $S A R_{j, t}=\frac{A R_{j, t}}{s_{j, t}}$
  and ${s_{j, t}}$ is the standard error of the abnormal returns for stock j at time t, which is calculated as:
  $s_{j, t}=\left(s_{j}^{2}\left[1+\frac{1}{T}+\frac{\left(R_{m, t}-\bar{R}_{m}\right)^{2}}{\sum_{i=1}^{T}\left(R_{m, i}-\bar{R}_{m}\right)^{2}}\right]\right)^{1 / 2}$
  and 
  $s_{j}^{2}=\left[\sum_{t=1}^{T}\left(\varepsilon_{j, t}-u_{j}\right)^{2}\right] /(T-1)$
  
  * The standardized CAR is calculated as:
  $C A R_{j}=\frac{1}{\sqrt{m}} \sum_{t=-t_{1}}^{t_{2}} S A R_{t}$
  
  * To determine whether the CARs are significant, the test statistic on any day t in the event window for all $n$ stocks is constructed as:
  $t \text {-statistic }=\frac{1}{\sqrt{n}} \sum_{i=1}^{n} C A R_{i}$
  If the event caused abnormal returns, the t-statistic should be significantly different from zero.
  
  
