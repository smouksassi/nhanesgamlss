require(gamlss)
require(ggplot2)
require(tidyr)
require(dplyr)

########################

op120<- readRDS("op120.rds")
mBOYS20<- readRDS("mBOYS20.rds")
BMXBOY20 <- readRDS("BMXBOY20.rds")

op2200<- readRDS("op2200.rds")
mGIRLS20BCPE<- readRDS("mGIRLS20BCPE.rds")
BMXGIRL20 <- readRDS("BMXGIRL20.rds")

simwtage <- function (
  gamlssbcpemodel=mBOYS20,
  optimizedparameters=op120,
  modeldata=BMXBOY20,
  indexofparameterfortransformedage=5,
  startageyears=0,
  endageyears  =  2,
  stepageincrease= 1/12,
  nweightsperage = 500,
  sex="boys",
  exclusionthresholdupdown = 0.03,
  seed = 456784112){
  set.seed(seed)
  powerofageparameter<- ifelse(!is.null(indexofparameterfortransformedage),
                               optimizedparameters$par[indexofparameterfortransformedage],1 )
  newdb <- data.frame(
    AGE=seq(startageyears*12,endageyears*12,stepageincrease*12),
    nage=c(seq(startageyears*12,endageyears*12,stepageincrease*12)^powerofageparameter))
  simmodelprediction <- predictAll(gamlssbcpemodel, newdata=newdb, type = "response")
  rrow<-length(newdb$AGE)
  simwtageoutput <- data.frame(matrix(NA,nrow=rrow,ncol=nweightsperage))
  for (i in 1:rrow ){
    simpoints <-(rBCPE(nweightsperage*10,mu= simmodelprediction$mu[i] , sigma=simmodelprediction$sigma[i] , nu= simmodelprediction$nu[i] ,tau= simmodelprediction$tau[i]))
    simwtageoutput[i,]<- sample(simpoints[
      simpoints < qBCPE((1-exclusionthresholdupdown),mu= simmodelprediction$mu[i] , sigma=simmodelprediction$sigma[i] , nu= simmodelprediction$nu[i] ,tau= simmodelprediction$tau[i])&
        simpoints > qBCPE((exclusionthresholdupdown),mu= simmodelprediction$mu[i] , sigma=simmodelprediction$sigma[i] , nu= simmodelprediction$nu[i] ,tau= simmodelprediction$tau[i])
      ],nweightsperage)
  }
  simwtageoutput<- as.data.frame(simwtageoutput)
  names(simwtageoutput) <- paste0("Var",1:ncol(simwtageoutput))
  simwtageoutput$AGEY  <-  newdb$AGE/12

  simwtageoutput <- simwtageoutput %>%
    gather( variable,value, -AGEY)
  simwtageoutput$variable <- seq(1,nrow(simwtageoutput),1)
  names(simwtageoutput) <- c("AGEY","ID","WT")
  simwtageoutput$SEX<- sex
  simwtageoutput
}
simwtageboys <- simwtage(
  gamlssbcpemodel=mBOYS20,
  optimizedparameters=op120,
  modeldata=BMXBOY20,
  indexofparameterfortransformedage=5,
  startageyears=0,
  endageyears  =  18,
  stepageincrease= 1,
  nweightsperage = 500,
  sex="boys",
  exclusionthresholdupdown = 0.03,
  seed = 456784112
)

simwtagegirls <- simwtage(
  gamlssbcpemodel=mGIRLS20BCPE,
  optimizedparameters=op2200,
  modeldata=BMXGIRL20,
  indexofparameterfortransformedage=5,
  startageyears=0,
  endageyears  =  18,
  stepageincrease= 1,
  nweightsperage = 500,
  sex="girls",
  exclusionthresholdupdown = 0.03,
  seed = 456784112
)

simwtagegirls$ID <- simwtagegirls$ID+1000000
simwtageall <- rbind(simwtageboys,simwtagegirls)
ggplot(simwtageall ,aes(AGEY,WT,col=SEX) )+
  facet_grid(~SEX)+
  geom_point(alpha=0.5)+
  scale_x_continuous(breaks=c(0,6,12,18) ,labels=c(0,6,12,18))+
  ylab("Weight (kg)")+xlab("Age (years)")+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))



#write.csv(simwtageall , file="simwtageall.csv",row.names=FALSE)


