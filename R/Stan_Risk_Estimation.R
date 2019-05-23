#' Stan Estimation Function for DEEP Risk
#' @description The main function to do estimation on DEEP Risk data. This function will automatically call stan models.
#' @param project_name The name of this study. 
#' @param num_question_Est How many questions you want to use in estimation.
#' @param num_question How many questions are asked for each subject.
#' @param type_theta Type of scaling response noise parameter used in estimation, specify either "Global", "Individual" or "Hier".
#' @param path Full path for working directory.
#' @param save_out Whether save the stanfit object as a rdata file. The default is "TRUE".
#' @param chains A positive integer specifying the number of Markov chains. The default is 3.
#' @param iter A positive integer specifying the number of iterations for each chain (including warmup). The default is 1000.
#' @param thin A positive integer specifying the period for saving samples. The default is 3. For details, refer to help page for function \code{\link[rstan]{stan}}.
#' @param adapt_delta A double value between 0 and 1 controlling the accept probability in sampling. The default is 0.9. For details, refer to help page for function \code{\link[rstan]{stan}}.
#' @param max_treedepth A positive integer specifying how deep in tree exploration. The default is 12. For details, refer to help page for function \code{\link[rstan]{stan}}.
#' @param stepsize A double and positive value controlling sampler's behavior. The default is 1. For details, refer to help page for function \code{\link[rstan]{stan}}.
#' 
#' @return Return a large stanfit object called "hier_risk" if \code{save_out=FALSE}. Otherwise, return nothing but save the stanfit object into a local RData file named 
#' "Stan_Risk_\{\code{project_name}\}_Est\{\code{type_theta}\}\{\code{num_question_Est}\}questions.RData" under directory \code{path}.
#' @export
#'
#' @importFrom rstan sampling
#' @importFrom rstan rstan_options
#' @importFrom rstan options
#' @examples
#' Stan_Risk_Estimation(project_name = 'Test', num_question_Est = 12, num_question = 12, 
#' type_theta = 'Hier', path = '/Users/ap/Desktop')
#' @references 
#' Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for 
#' estimating preferences: An adaptive method of eliciting time and risk parameters. 
#' Management Science, 59(3), 613-640.
#' \url{https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1120.1570}
#' 
Stan_Risk_Estimation <- function(project_name,
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
                                 stepsize=1){
  
  rstan_options(auto_write = TRUE)
  options(mc.cores = parallel::detectCores()-1)
  
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
    hier_risk <- sampling(stanmodels$Stan_Risk_Global,
                      data = moddat,
                      chains = chains, 
                      iter = iter,
                      thin = thin,
                      control = list(adapt_delta = adapt_delta,
                                     max_treedepth = max_treedepth,
                                     stepsize = stepsize))
  } else {
    if (type_theta == 'Individual'){
      hier_risk <- sampling(stanmodels$Stan_Risk_Individual,
                        data = moddat,
                        chains = chains, 
                        iter = iter,
                        thin = thin,
                        control = list(adapt_delta = adapt_delta,
                                       max_treedepth = max_treedepth,
                                       stepsize = stepsize))
    } else {
      hier_risk <- sampling(stanmodels$Stan_Risk_Hier,
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