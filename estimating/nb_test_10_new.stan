// generated with brms 2.13.1
functions {
}
data {
  int<lower=1> N;  // number of observations
  int Y[N];  // response variable
  vector<lower=0>[N] denom;  // response denominator
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  // log response denominator
  vector[N] log_denom = log(denom);
}
parameters {
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> shape;  // shape parameter
}
transformed parameters {
}
model {
  // initialize linear predictor term
  vector[N] mu = Intercept + rep_vector(0, N);
  // priors including all constants
  target += student_t_lpdf(Intercept | 3, 3.8, 2.5);
  target += gamma_lpdf(shape | 0.01, 0.01);
  // likelihood including all constants
  if (!prior_only) {
    target += neg_binomial_2_log_lpmf(Y | mu + log_denom, shape * denom);
  }
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept;
}
