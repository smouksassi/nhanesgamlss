#' Output from the find.hyper function run on BMXGIRL20 dataset.
#'
#' While the user can rerun the code on his own data or on the included BMXGIRL20 data
#' it might be time consuming and as such this object is included for convenience.
#' \preformatted{mod2200<-quote(gamlss(WT~cs(nage,df=p[1]),
#' sigma.fo=~cs(nage,p[2]),
#' nu.fo=~cs(nage,p[3], c.spar=c(-1.5,2.5)),
#' tau.fo=~cs(nage,p[4], c.spar=c(-1.5,2.5)),
#' data=BMXGIRL20, family=BCPE, control=gamlss.control(trace=FALSE)))
#' }
#' \preformatted{op2200<-find.hyper(model=mod2200, other=quote(nage2<-AGE^p[5]),
#' par=c(17,7,6,7,0.5),
#' lower=c(0.1,0.1,0.1,0.1,0.001), steps=c(0.1,0.1,0.1,0.1,0.2), factr=2e9,
#' parscale=c(1,1,1,1,0.035), penalty=2 )
#' }
"op2200"