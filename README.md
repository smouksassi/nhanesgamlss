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

## Simulation from provided LMS values
Several sources do not provide the data, and they provide the model LMS values instead. `gamlss.dist` has a function `rBCCG` that can be used to simulate using LMS values.
```
wtage <- read.csv (url("https://www.cdc.gov/growthcharts/data/zscore/wtage.csv"))
simulatedWT <- rBCCG(1000000, mu = wtage[1,"M"], sigma = wtage[1,"S"], nu = wtage[1,"L"])
quantile(simulatedWT,probs=c(0.03,0.05,0.1,0.25,0.5,0.75,0.90,0.95,0.97))
qBCCG(0.05, mu = wtage[1,"M"],
sigma = wtage[1,"S"], nu = wtage[1,"L"])

wtage[1,6:14]

nweightsperage <- 10
simwtageoutput <- data.frame(matrix(NA, nrow = nrow(wtage),
                                    ncol = nweightsperage))
names(simwtageoutput) <- paste0("Var", 1:nweightsperage)

for (i in 1:nrow(wtage)) {#
  simpoints <- gamlss.dist::rBCCG(nweightsperage,
                                  mu = wtage[i,"M"],
                                  sigma =  wtage[i,"S"],
                                  nu = wtage[i,"L"])
simwtageoutput[i, ] <- simpoints
}
simwtageoutput$Agemos  <- wtage$Agemos
simwtageoutput$AgeY  <- wtage$Agemos/12
simwtageoutput$Sex <- wtage$Sex

simwtageoutput <- tidyr::gather(simwtageoutput,age,Weight,
                                paste0("Var", 1:nweightsperage))

ggplot(simwtageoutput,aes(AgeY,Weight))+
  geom_point()+
  facet_grid(~Sex)
```