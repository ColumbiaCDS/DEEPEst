#' The 'DEEPEst' package.
#'
#' @description Hierarchical Bayesian Estimation for DEEP with Stan
#'
#' @docType package
#' @name DEEPEst-package
#' @aliases DEEPEst
#' @useDynLib DEEPEst, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @import dplyr
#' @import ggplot2
#' @importFrom reshape2 acast
#' @importFrom gridExtra grid.arrange
#' @importFrom rstan stan
#' @importFrom rstan extract
#'
#' @references
#' Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for estimating preferences: An adaptive method of eliciting time and risk parameters. 
#' Management Science, 59(3), 613-640. \url{https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1120.1570}
#' Stan Development Team (2018). RStan: the R interface to Stan. R package version 2.18.2. https://mc-stan.org
#'
NULL
