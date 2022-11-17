library(brms)
library(data.table)
set.seed(5)
#Sample from a negative binomial with a known distribution

#The distribution should have this mean and shape:
mu =  4.5
sd = 3

data = data.table(N=1, y=rnorm(1000, mean=4.5, sd=3), group=rep(seq(100), 10))

# Now fit a model to the full dataset, and to an aggregated dataset (aggregated into groups of 10):
b_1 = brm(y  ~ 1 + offset(log(N)), data=data, save_model='normal.stan', family=gaussian(link='log'))
b_10 = brm(bf(y   ~ 1 + offset(log(N)), sigma ~ 1 + offset(I(sqrt(N)))), data=data[, .(.N, y=sum(y)), group], family=gaussian(link='log'))

#A little helper function to check that the parameter is within the credible interval
between <- function(fit, value, parameter){return(
     (value > posterior_summary(fit)[parameter, 'Q2.5']) & 
      (value < posterior_summary(fit)[parameter, 'Q97.5'])
)}

#The means from the full and aggregated datasets are as expected
stopifnot(between(b_1, log(mu), 'b_Intercept'))
stopifnot(between(b_10, log(mu), 'b_Intercept'))

# The shape from the full dataset is as expected:
stopifnot(between(b_1, sd, 'sigma'))

# But the shape from the aggregated dataset gives an error
stopifnot(between(b_10, sd, 'sigma'))
#Error: between(b_10, phi, "shape") is not TRUE
# In fact `posterior_summary(b_10)['shape', 'Estimate']` is around 60, around
# ten times higher than it should be
