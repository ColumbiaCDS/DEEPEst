#' The 'DEEPEst' package.
#'
#' @description Dynamic Experiments for Estimating Preferences (DEEP) is a novel methodology 
#' to elicit individuals' risk and time preferences by dynamically optimizing the sequences of 
#' questions presented to each subject, while leveraging information about the distribution of 
#' the parameters across individuals (heterogeneity) and modeling response error explicitly. 
#' This package provides functions to execute hierarchical Bayesian estimation for DEEP with 'Stan' <https://mc-stan.org> 
#' and posterior analysis on estimates of both time and risk preferences parameters. 
#'
#' @docType package
#' @name DEEPEst-package
#' @aliases DEEPEst
#' @useDynLib DEEPEst, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @import dplyr
#' @import ggplot2
#' @import rstantools
#' @importFrom reshape2 acast
#' @importFrom gridExtra grid.arrange
#' @importFrom rstan sampling
#' @importFrom rstan extract
#'
#' @references
#' Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for estimating preferences: An adaptive method of eliciting time and risk parameters. 
#' Management Science, 59(3), 613-640. \url{https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1120.1570}
#' Stan Development Team (2018). RStan: the R interface to Stan. R package version 2.18.2. https://mc-stan.org
#'
NULL
