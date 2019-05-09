library(ggplot2)
library(dplyr)
library(reshape2)

### Save the stan estimated individual parameters out as csv file. With the first column being alpha, second sigma and third lambda
## path sould be set to the working directory where you save your stan result (.rdata file) and the document "RISKSIM0"
## By setting argument "isGerman" to be true, it will save the estimated parameters of DEEP German Risk
## "isGlobal=T" means stan set parameter delta globally for each subject
## SimID is the simulation ID, denoting which simulated dataset we are estimating here with stan
## questionEst: number of questions each subjects used here in estimation
## subfolder: the name of the document which saves all the outputs of running simulation, mine is 'RISKSIM0'
## path: working directory, where you save all the files and the document which contains all simulated data 
Risk_save_stantocsv <- function(project_name,
                           num_question_Est,
                           type_theta, 
                           path){
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  load(paste0(path, '/Stan_Risk_', project_name, '_Est', type_theta, num_question_Est, 
                'questions.RData'))
  stan <- rstan::extract(hier_risk)
  serials <- read.csv(paste0(path, '/', project_name, '_Risk_serials.csv'), header = F)$V1
  filename_wts <- paste0(path, '/StanEstimates_Risk_parameters_', project_name, '_Est', 
                         type_theta, num_question_Est, "questions.csv")
  filename_theta <- paste0(path, '/StanEstimates_Risk_theta_', project_name, '_Est', 
                           type_theta, num_question_Est, "questions.csv")

  stan_alpha <- colMeans(stan$alpha)
  stan_sigma <- colMeans(stan$sigma)
  stan_lambda <- colMeans(stan$lambda)
  
  if (type_theta == 'Global'){
    stan_theta <- matrix(c(1, mean(stan$global_theta)), nrow = 1, byrow = T)
    colnames(stan_delta) <- c('serial', 'global theta')
  } else {
    stan_theta <- matrix(c(serials, colMeans(stan$theta)), ncol = 2)
    colnames(stan_theta) <- c('serial', 'individual theta')
  }
  stan <- matrix(c(serials, stan_alpha, stan_sigma, stan_lambda), ncol = 4)
  colnames(stan) <- c('serial', 'alpha', 'sigma', 'lambda')
  
  write.table(stan, filename_wts, col.names = T, row.names = F, sep = ',')
  write.table(stan_theta, filename_theta, col.names = T, row.names = F, sep = ',')
}