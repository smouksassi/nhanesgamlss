#' Simulate Weight Age Pairs.
#'
#' @param gamlssbcpemodel A fitted gamlss BCPE model object.
#' @param optimizedparameters A vector of hyper parameters used to inform the fitting of the object.
#' @param modeldata The data used to fit the gamlss model. It is needed for the gamlss prediction function.
#' @param indexofparameterfortransformedage If applicable the index of the parameter in the optimizedparameters vector that refers to the power of age.
#' @param startageyears The starting age at which simulation starts in years. Default is 0 years.
#' @param endageyears The ending age at which simulation ends in years. Default is 2 years.
#' @param stepageincrease The step in years at which we increment from startageyears to endageyears. Default is 1 year.
#' @param nweightsperage The number of simulated weights for each unique age.
#' @param sex A string to add to the generated data.
#' @param exclusionthresholdup The percentile that determines at which upper percentile we exlude simulated weights. Default to 0.03 (third percentile).
#' @param exclusionthresholddown The percentile that determines at which lower percentile we exlude simulated weights. Default to 0.97 (ninety seventh percentile).
#' @param seed A seed number to ensure reproducibility
#' @return The simulated data with age in years and weight in kg and the sepcified sex character string.
#' @examples
#' require(gamlss)
#' require(tidyr)
#' require(nhanesgamlss)
#' 
#' mBOYS20 <- gamlss(WT ~ cs(nage, df = op120$par[1]),
#' sigma.fo = ~cs(nage,df = op120$par[2]),
#' nu.fo = ~cs(nage, df =  op120$par[3] ),
#' c.spar = c(-1.5,2.5),
#' tau.fo = ~cs(nage, df = op120$par[4]),
#' data = BMXBOY20, family = BCPE)
#' 
#' simwtage(gamlssbcpemodel = mBOYS20, optimizedparameters = op120, modeldata = BMXBOY20,
#' indexofparameterfortransformedage = 5, startageyears = 0, endageyears = 18,
#' stepageincrease = 1, nweightsperage = 500, sex = "boys", exclusionthresholdup = 0.97,
#' exclusionthresholddown = 0.03, seed = 456784112)
#' 
#' mGIRLS20 <- gamlss(WT ~ cs(nage, df = op2200$par[1]),
#' sigma.fo = ~cs(nage,df = op2200$par[2]),
#' nu.fo = ~cs(nage, df =  op2200$par[3] ),
#' c.spar = c(-1.5,2.5),
#' tau.fo = ~cs(nage, df = op2200$par[4]),
#' data = BMXGIRL20, family = BCPE)
#' 
#' simwtage(gamlssbcpemodel = mGIRLS20, optimizedparameters = op2200, modeldata = BMXGIRL20,
#' indexofparameterfortransformedage = 5, startageyears = 0, endageyears = 18,
#' stepageincrease = 1, nweightsperage = 500, sex = "girls", exclusionthresholdup = 0.97,
#' exclusionthresholddown = 0.03, seed = 456784112)



simwtage <- function(gamlssbcpemodel,
                     optimizedparameters,
                     modeldata,
    indexofparameterfortransformedage = NULL,
    startageyears = 0,
    endageyears = 2,
    stepageincrease = 1/12,
    nweightsperage = 500,
    sex = "boys",
    exclusionthresholdup = 0.97,
    exclusionthresholddown = 0.03,
    seed = 456784112) {
    set.seed(seed)
    powerofageparameter <- ifelse(!is.null(indexofparameterfortransformedage), optimizedparameters$par[indexofparameterfortransformedage],
        1)
    newdb <- data.frame(AGE = seq(startageyears * 12, endageyears * 12, stepageincrease *
        12), nage = c(seq(startageyears * 12, endageyears * 12, stepageincrease * 12)^powerofageparameter))
    simmodelprediction <- gamlss::predictAll(gamlssbcpemodel, newdata = newdb, type = "response")
    rrow <- length(newdb$AGE)
    simwtageoutput <- data.frame(matrix(NA, nrow = rrow, ncol = nweightsperage))
    for (i in 1:rrow) {
        simpoints <- (gamlss.dist::rBCPE(nweightsperage * 10, mu = simmodelprediction$mu[i], sigma = simmodelprediction$sigma[i],
            nu = simmodelprediction$nu[i], tau = simmodelprediction$tau[i]))
        simwtageoutput[i, ] <- sample(simpoints[simpoints < gamlss.dist::qBCPE(exclusionthresholdup,
            mu = simmodelprediction$mu[i], sigma = simmodelprediction$sigma[i], nu = simmodelprediction$nu[i],
            tau = simmodelprediction$tau[i]) & simpoints > gamlss.dist::qBCPE(exclusionthresholddown,
            mu = simmodelprediction$mu[i], sigma = simmodelprediction$sigma[i], nu = simmodelprediction$nu[i],
            tau = simmodelprediction$tau[i])], nweightsperage)
    }
    simwtageoutput <- as.data.frame(simwtageoutput)
    names(simwtageoutput) <- paste0("Var", 1:nweightsperage)
    simwtageoutput$AGEY <- newdb$AGE/12
    simwtageoutput <- tidyr::gather(simwtageoutput,"ID", "WT", paste0("Var", 1:nweightsperage))
    simwtageoutput$ID <- seq(1, nrow(simwtageoutput), 1)
    simwtageoutput <-simwtageoutput[ , c("ID", "AGEY", "WT")]
    simwtageoutput$SEX <- sex
    simwtageoutput
}



