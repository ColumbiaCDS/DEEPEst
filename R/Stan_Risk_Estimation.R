library(ggplot2)
library(dplyr)
library(reshape2)

############## Main function to do Stan estimation ############
## DEEP Risk main function, estimation with stan
## num_question: the total questions we asked for each subjects in survey
## chain: number of chains in mcmc
## iter: total burn-in & sampling phases iteration, with half for burn-in and half for sampling
## thin: with what space we keep the sampling results
## adapt_delta, max_treedepth, stepsize: parameters used in NUTS sampling, details could be found in Gelman's paper, default setting here
# type_theta: 'Global' or 'Individual' or 'Hier'
# global delta setting or invidual
# save_out: whether save the stan object as a rdata file

Stan_Risk_Estimation <- function(project_name,
                                 num_question_Est, 
                                 num_question, 
                                 type_theta, 
                                 path, 
                                 stan_path, 
                                 save_out = T,
                                 chains=3, 
                                 iter=1000, 
                                 thin=3, 
                                 adapt_delta=.9,
                                 max_treedepth=12,
                                 stepsize=1){
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  gambles1 <- read.csv(paste0(path, '/', project_name, '_Risk_options_chosen.csv')
                         , header = F, col.names = c("x1","p1", "y1", "q1"))
  gambles2 <- read.csv(paste0(path, '/', project_name, '_Risk_options_notchosen.csv')
                         , header = F, col.names = c("x2","p2", "y2", "q2"))
  serials <- read.csv(paste0(path, '/', project_name, '_Risk_serials.csv'), header = F)
    
  subjectNumber <- nrow(serials)
      
  all_Stan_data <- data.frame(SubjectID = NA, QuestionNum = NA, 
                            x1 = gambles1$x1,
                            p1 = gambles1$p1,
                            y1 = gambles1$y1,
                            q1 = gambles1$q1,
                            x2 = gambles2$x2,
                            p2 = gambles2$p2,
                            y2 = gambles2$y2,
                            q2 = gambles2$q2,
                            Choice = 0)
  all_Stan_data$SubjectID <- rep(serials$V1, each = num_question)
  all_Stan_data$QuestionNum <- rep(seq(num_question), nrow(serials))
  all_Stan_data[3:10] <- t(apply(all_Stan_data[, 3:10], MARGIN = 1, Risk_resetxy))
  
  Risk_prepare_Stan(all_Stan_data, num_question_Est, subjectNumber)
  
  if (type_theta == 'Global') {
    hier_risk <- stan(paste0(stan_path, "/Stan_Risk_Global.stan"),
                      data = moddat,
                      chains = chains, 
                      iter = iter,
                      thin = thin,
                      control = list(adapt_delta = adapt_delta,
                                     max_treedepth = max_treedepth,
                                     stepsize = stepsize))
  } else {
    if (type_theta == 'Individual'){
      hier_risk <- stan(paste0(stan_path, "/Stan_Risk_Individual.stan"),
                        data = moddat,
                        chains = chains, 
                        iter = iter,
                        thin = thin,
                        control = list(adapt_delta = adapt_delta,
                                       max_treedepth = max_treedepth,
                                       stepsize = stepsize))
    } else {
      hier_risk <- stan(paste0(stan_path, "/Stan_Risk_Hier.stan"),
                        data = moddat,
                        chains = chains, 
                        iter = iter,
                        thin = thin,
                        control = list(adapt_delta = adapt_delta,
                                       max_treedepth = max_treedepth,
                                       stepsize = stepsize))
    }
  }
  
  if (save_out){
    # Save out the Stan fit subject as a RData file in your working directory
    filename_stan <- paste0(path, "/Stan_Risk_", project_name, "_Est", type_theta,
                            num_question_Est, "questions.RData")
    save(hier_risk, file = filename_stan)
  } else {
    # If not save out, return the subject
    return(hier_risk)
  }
}