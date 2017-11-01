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

simulatedboys <- simwtage(gamlssbcpemodel = mBOYS20,
optimizedparameters = op120,
modeldata = BMXBOY20,
indexofparameterfortransformedage = 5, startageyears = 0, endageyears = 18,
stepageincrease = 1, nweightsperage = 500, sex = "boys", exclusionthresholdup = 0.97,
exclusionthresholddown = 0.03, seed = 456784112)

mGIRLS20 <- gamlss(WT ~ cs(nage, df = op2200$par[1]),
sigma.fo = ~cs(nage,df = op2200$par[2]),
nu.fo = ~cs(nage, df =  op2200$par[3] ),
c.spar = c(-1.5,2.5),
tau.fo = ~cs(nage, df = op2200$par[4]),
data = BMXGIRL20, family = BCPE)

simulatedgirls <- simwtage(gamlssbcpemodel = mGIRLS20,
optimizedparameters = op2200,
modeldata = BMXGIRL20,
indexofparameterfortransformedage = 5,
startageyears = 5,
endageyears = 12,
stepageincrease = 0.1,
nweightsperage = 500,
sex = "girls",
exclusionthresholdup = 0.75,
exclusionthresholddown = 0.25,
seed = 456784112)

ggplot2::ggplot(rbind(simulatedboys,simulatedgirls),ggplot2::aes(AGEY,WT))+
ggplot2::geom_point()+
ggplot2::facet_grid(~SEX)+
ggplot2::labs(x="Age (years)",y="Weight (kg)")
```
![Example output with different arguments](./exampleoutput.png?raw=true "Example output")

