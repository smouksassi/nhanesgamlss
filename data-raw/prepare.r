op120 <- readRDS("op120.rds")
mBOYS20 <- readRDS("mBOYS20.rds")
BMXBOY20 <- readRDS("BMXBOY20.rds")

op2200 <- readRDS("op2200.rds")
mGIRLS20 <- readRDS("mGIRLS20BCPE.rds")
BMXGIRL20 <- readRDS("BMXGIRL20.rds")


BMXBOY20$nage <- BMXBOY20$AGE^op120$par[5]

mBOYS20 <- gamlss::gamlss(WT ~ gamlss::cs(nage, df = op120$par[1]),
                  sigma.fo = ~ gamlss::cs(nage,df = op120$par[2]),
                     nu.fo = ~ gamlss::cs(nage, df =  op120$par[3] ),
                    c.spar = c(-1.5,2.5),
                    tau.fo = ~gamlss::cs(nage, df = op120$par[4]),
                      data = BMXBOY20, family = BCPE)



gamlss::gamlss(WT ~ cs(nage, df = op120$par[1]), sigma.fo = ~cs(nage,df = op120$par[2]),
       nu.fo = ~cs(nage, df =  op120$par[3] ),
       c.spar = c(-1.5,2.5), tau.fo = ~cs(nage, df = op120$par[4]),
       data = BMXBOY20, family = BCPE)


plot(mBOYS20)
centiles(mBOYS20 , xvar = BMXBOY20$AGE, ylab = "Weight", xlab = "AGE")
centiles.fan(mBOYS20,xvar = BMXBOY20$AGE, ylab = "Weight", xlab = "AGE")
# shows the fitted model

saveRDS(op120, "op120.rds")
op120<- readRDS("op120.rds")
saveRDS(mBOYS20, "mBOYS20.rds")



devtools::use_data(op120)
devtools::use_data(mBOYS20)
devtools::use_data(BMXBOY20)
devtools::use_data(op2200)
devtools::use_data(mGIRLS20)
devtools::use_data(BMXGIRL20)




