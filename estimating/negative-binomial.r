library(brms)
library(data.table)
set.seed(5)
#Sample from a negative binomial with a known distribution
r = 3
p = 0.4

#The distribution should have this mean and shape:
mu = r*(1-p)/p #4.5
phi = r        #3

data = data.table(N=1, y=rnbinom(1000, size=3, prob=0.4), group=rep(seq(100), 10))

# Now fit a model to the full dataset, and to an aggregated dataset (aggregated into groups of 10):
b_1 = brm(y | rate(N)  ~ 1, family=negbinomial, data=data, save_model='nb_test.stan')
b_10 = brm(y | rate(N)  ~ 1, family=negbinomial, data=data[, .(.N, y=sum(y)), group], save_model='nb_test_10_new.stan')

#A little helper function to check that the parameter is within the credible interval
between <- function(fit, value, parameter){return(
     (value > posterior_summary(fit)[parameter, 'Q2.5']) & 
      (value < posterior_summary(fit)[parameter, 'Q97.5'])
)}

#The means from the full and aggregated datasets are as expected
stopifnot(between(b_1, log(mu), 'b_Intercept'))
stopifnot(between(b_10, log(mu), 'b_Intercept'))

# The shape from the full dataset is as expected:
stopifnot(between(b_1, phi, 'shape'))

# But the shape from the aggregated dataset gives an error
stopifnot(between(b_10, phi, 'shape'))
#Error: between(b_10, phi, "shape") is not TRUE
# In fact `posterior_summary(b_10)['shape', 'Estimate']` is around 60, around
# ten times higher than it should be

devtools::install_github('paul-buerkner/brms@e5a283')

