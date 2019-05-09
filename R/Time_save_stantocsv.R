library(ggplot2)
library(dplyr)
library(reshape2)

############## Main function to do Stan estimation ############
##### The function to save estimates from Stan fit object to csv files
Time_save_stantocsv <- function(project_name,
                           num_question_Est, 
                           type_theta, 
                           path){
  
  # Make sure the type of theta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  load(paste0(path, "/Stan_Time_", project_name, "_Est", type_theta, num_question_Est, "questions.RData"))
  stan <- rstan::extract(hier_time)
  serials <- read.csv(paste0(path, '/', project_name, '_Time_serials.csv'), header = F)$V1
  filename_wts <- paste0(path, '/StanEstimates_Time_parameters_', project_name, '_Est', 
                         type_theta, num_question_Est, "questions.csv")
  filename_theta <- paste0(path, '/StanEstimates_Time_theta_', project_name, '_Est', 
                           type_theta, num_question_Est, "questions.csv")

  stan_beta <- colMeans(stan$beta)
  stan_r <- colMeans(stan$r)
  stan_delta <- colMeans(stan$delta)
  
  if (type_theta == 'Global'){
    stan_theta <- matrix(c(1, mean(stan$global_theta)), nrow = 1, byrow = T)
    colnames(stan_delta) <- c('serial', 'global theta')
  } else {
    stan_theta <- matrix(c(serials, colMeans(stan$theta)), ncol = 2)
    colnames(stan_theta) <- c('serial', 'individual theta')
  }
  stan <- matrix(c(serials, stan_beta, stan_r, stan_delta), ncol = 4)
  colnames(stan) <- c('serial', 'beta', 'r', 'delta')
  
  write.table(stan, filename_wts, col.names = T, row.names = F, sep = ',')
  write.table(stan_theta, filename_theta, col.names = T, row.names = F, sep = ',')
}
