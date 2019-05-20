#' Save Risk Preferences Estimates to csv Files
#' @description Save posterior point estimates for risk preferences from stanfit object to local csv files. 
#' Only run this function when stanfit object for study \code{project_name} is saved under directory \code{path} after estimation.
#' 
#' @param project_name The name of this study. 
#' @param num_question_Est How many questions you want to use in estimation.
#' @param type_theta Type of scaling response noise parameter used in estimation, specify either "Global", "Individual" or "Hier".
#' @param path Full path for working directory.
#'
#' @return Two csv files will be saved under directory indicated by \code{path}:
#' \itemize{
#'   \item "StanEstimates_Risk_parameters_\{\code{project_name}\}_Est\{\code{type_theta}\}\{\code{num_question_Est}\}questions.csv" contains all estimates of individual \eqn{\alpha} (distortion of probability parameter), \eqn{\sigma} (curvature of value function) and \eqn{\lambda} (loss aversion parameter) respectively as in three columns. The number of rows is the number of subjects in the survey. 
#'   \item "StanEstimates_Risk_theta_\{\code{project_name}\}_Est\{\code{type_theta}\}\{\code{num_question_Est}\}questions.csv" contains estimates of either global or individual scaling response error parameter \eqn{\theta}.
#' }
#' 
#' @export
#' @importFrom rstan extract
#' @examples
#' Risk_save_stantocsv(project_name = 'test', num_question_Est = 12, type_theta = 'Hier', path = path)
#' @references 
#' Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for 
#' estimating preferences: An adaptive method of eliciting time and risk parameters. 
#' Management Science, 59(3), 613-640.
#' \url{https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1120.1570}
#' 
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