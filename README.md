# Parameterisation of the negative binomial

The purpose of this note is to explore how the different
parameterisations of the neagtive binomial distribution used
in R and Stan relate to one another.

If you have R installed you can compile the document (you will
need the rstan library installed). If you are on a Linux
computer with Docker, then running `make` should download
a (large - several GB) docker image and compile it for you.

There is some discussion relating to this in the Stan forum:
https://discourse.mc-stan.org/t/scaling-of-the-overdispersion-in-negative-binomial-models/15581
