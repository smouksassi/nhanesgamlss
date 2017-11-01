# nhanesgamlss
Simulation function to use a fitted BCPE GAMLSS model on NHANES data allowing a user friendly simulation of pediatric age /weight pairs.

```
devtools::install_github("smouksassi/nhanesgamlss")

require(gamlss)
require(tidyr)
require(nhanesgamlss)

mBOYS20 <- gamlss(WT ~ cs(nage, df = op120$par[1]),
sigma.fo = ~cs(nage,df = op120$par[2]),
nu.fo = ~cs(nage, df =  op120$par[3] ),
c.spar = c(-1.5,2.5),
tau.fo = ~cs(nage, df = op120$par[4]),
data = BMXBOY20, family = BCPE)

simwtage(gamlssbcpemodel = mBOYS20, optimizedparameters = op120, modeldata = BMXBOY20,
indexofparameterfortransformedage = 5, startageyears = 0, endageyears = 18,
stepageincrease = 1, nweightsperage = 500, sex = "boys", exclusionthresholdup = 0.97,
exclusionthresholddown = 0.03, seed = 456784112)


```
