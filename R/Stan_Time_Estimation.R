library(ggplot2)
library(dplyr)
library(reshape2)

############## Main function to do Stan estimation ############
# project_name: the default is "NULL". Only change this if you are doing Stan estimation
#           on your survey PHP data. In that case, change it to the name of your study.
# num_question_Est: how many questions you want to use in estimation
# num_question: how many questions are asked for each subject
# type_theta: type of scaling parameter used in simulation, specify either "Global", "Individual" or "Hier"
# path: your full working directory path 
# save_out: whether save the stan fit object as a rdata file
# chains, iter, thin, adapt_delta, max_treedepth and stepsize: these are parameters which control
#               how the samplers work. Please refer to Stan help for detailed description. Only 
#               change them if you find the convergence is awful in diagnosis.
#               For Time estimation, usually no much changes needed.

Stan_Time_Estimation <- function(project_name, 
                                 num_question_Est, 
                                 num_question, 
                                 type_theta, 
                                 path,
                                 save_out = T,
                                 chains=3, 
                                 iter=1000, 
                                 thin=3, 
                                 adapt_delta=.9, 
                                 max_treedepth=12, 
                                 stepsize=1) {
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
    
  gambles1 <- read.csv(paste0(path, '/', project_name, '_Time_options_chosen.csv')
                         , header = F, col.names = c("ssamount","ssdelay"))
  gambles2 <- read.csv(paste0(path, '/', project_name, '_Time_options_notchosen.csv')
                         , header = F, col.names = c("llamount","lldelay"))
  serials <- read.csv(paste0(path, '/', project_name, '_Time_serials.csv'), header = F)
  
  subjectNumber <- nrow(serials)
  
  all_Stan_data <- data.frame(SubjectID = NA, QuestionNum = NA, SS_Amount = gambles1$ssamount, SS_Delay = gambles1$ssdelay,
                            LL_Amount = gambles2$llamount, LL_Delay = gambles2$lldelay, Choice = 0)
  
  all_Stan_data <- Time_index_Questions(all_Stan_data, subjectNumber, num_question)
  
  # create data list for running Stan
  Time_prepare_Stan(all_Stan_data, num_question_Est, subjectNumber)
  
  # Set initial values to begin MCMC sampling based on empirical knowledge
  chain <- list('beta' = rep(0.8, subjectNumber), 'r' = rep(0.002, subjectNumber),
                'delta' = rep(exp(-365*0.002), subjectNumber), 'theta' = rep(0.5, subjectNumber),
                'delta_phi' = rep(0, subjectNumber),
                'mubeta' = 0.8, 'sigmabeta' = 0.2,
                'mudelta_phi' = 0, 'sigmadelta_phi' = 0.2,
                'mutheta' = -1, 'sigmatheta' = 1)

  initial_chains <- list(chain, chain, chain)
  
  # run stan model with indiviual or global or hierarchical scaling parameter
  if (type_theta == 'Global') {
    hier_time <- stan(stanmodels$Stan_Time_Global,
                 data = moddat,
                 chains = chains, 
                 iter = iter,
                 init = initial_chains,
                 thin = thin,
                 control = list(adapt_delta = adapt_delta,
                                max_treedepth = max_treedepth,
                                stepsize = stepsize))
    } else {
      if (type_theta == 'Individual'){
        hier_time <- stan(stanmodels$Stan_Time_Individual,
                     data = moddat,
                     chains = chains, 
                     iter = iter,
                     init = initial_chains,
                     thin = thin,
                     control = list(adapt_delta = adapt_delta,
                                    max_treedepth = max_treedepth,
                                    stepsize = stepsize))
      } else {
        hier_time <- stan(stanmodels$Stan_Time_Hier,
                     data = moddat,
                     chains = chains, 
                     iter = iter,
                     init = initial_chains,
                     thin = thin,
                     control = list(adapt_delta = adapt_delta,
                                    max_treedepth = max_treedepth,
                                    stepsize = stepsize))
      }
    }
  
  if (save_out){
    # Save out the Stan fit subject as a RData file in your working directory
    filename_stan   <- paste0(path, "/Stan_Time_", project_name, "_Est", type_theta,
                                          num_question_Est, "questions.RData")
    save(hier_time, file = filename_stan)
  } else {
    # If not save out, return the subject
    return(hier_time)
  }
}

