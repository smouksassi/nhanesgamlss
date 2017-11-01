#' Output from the find.hyper function run on BMXBOY20 dataset.
#'
#' While the user can rerun the code on his own data or on the included BMXBOY20 data
#' it might be time consuming and as such this object is included for convenience.
#' \preformatted{mod120<-quote(gamlss(WT~cs(nage,df=p[1]), 
#' sigma.fo=~cs(nage,p[2]),
#' nu.fo=~cs(nage,p[3], c.spar=c(-1.5,2.5)),
#' tau.fo=~cs(nage,p[4], c.spar=c(-1.5,2.5)),
#' data=BMXBOY20, family=BCPE, control=gamlss.control(trace=FALSE)))
#' }
#' \preformatted{op120<-find.hyper(model=mod120, other=quote(nage<-AGE^p[5]),
#' par=c(25,15,10,10,0.5),
#' lower=c(0.1,0.01,0.1,0.1,0.001), steps=c(0.1,0.1,0.1,0.1,0.1), factr=2e9,
#' parscale=c(1,1,1,1,0.035), penalty=2 )
#' }
"op120"