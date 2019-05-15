#' Save Time Preferences Estimates to csv Files
#' @description Save posterior point estimates for time preferences from stanfit object to csv files.
#' @param project_name The name of this study. 
#' @param num_question_Est How many questions you want to use in estimation.
#' @param type_theta Type of scaling response noise parameter used in estimation, specify either "Global", "Individual" or "Hier".
#' @param path Full working path.
#'
#' @return Two csv files will be saved under directory indicated by \code{path}:
#' \itemize{
#'   \item "StanEstimates_Time_parameters_\{\code{project_name}\}_Est\{\code{type_theta}\}\{\code{num_question_Est}\}questions.csv" contains all estimates of individual \eqn{\beta} (present-bias parameter), \eqn{r} (daily discount rate) and yearly discount factor \eqn{\delta} respectively as in three columns. The number of rows is the number of subjects in the survey. 
#'   \item "StanEstimates_Time_theta_\{\code{project_name}\}_Est\{\code{type_theta}\}\{\code{num_question_Est}\}questions.csv" contains estimates of either global or individual scaling response error parameter \eqn{\theta}.
#' }
#' 
#' @export
#' @importFrom rstan extract
#' @examples
#' Time_save_stantocsv(project_name = 'test', num_question_Est = 12, type_theta = 'Hier', path = path)

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
