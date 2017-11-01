#' Age and Weight Data of 6621 girls ged less than 18 years.
#'
#' A dataset of boys from the NHANES 1999-2000 to NHANES 2013-2014 data cuts.It contains
#' the weight, age,  and age raised to a power of 0.947. This power value was found by
#' the previously run gamlss::find.hyper step.
#'
#' @format A data frame with 6720 rows and 3 variables:
#' \describe{
#'   \item{WT}{weight, in kg}
#'   \item{AGE}{age, in in months}
#'   \item{nage}{age raised to a power of 0.947}
#' }
#' @source \url{https://wwwn.cdc.gov/nchs/nhanes/default.aspx/}
"BMXGIRL20"