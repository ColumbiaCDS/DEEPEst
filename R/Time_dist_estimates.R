#' Plot the Distribution of Estimates for Time Preference Parameters.
#' @description Plot the distributions of all parameter estimates across all subjects.
#' Only run this function when stanfit object for study \code{project_name} is saved under directory \code{path} after estimation.
#' @param project_name The name of this study.
#' @param num_question_Est How many questions used in the estimation.
#' @param type_theta Type of scaling response noise parameter used in estimation, specify either "Global", "Individual" or "Hier".
#' @param path Full path for working directory.
#' 
#' @import ggplot2
#' @importFrom gridExtra grid.arrange
#' @importFrom rstan extract
#' 
#' @return Return the distribution plot for all time parameter estimates for all subjects. 
#' @export
#'
#' @examples
#' Time_dist_estimates(project_name = 'test', num_question_Est = 12, type_theta = 'Hier', path = '/Users/ap/Desktop')
Time_dist_estimates <- function(project_name, 
                                num_question_Est,
                                type_theta, 
                                path){
  
  # Make sure the type of response noise parameter theta specified is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  load(paste0(path, '/Stan_Time_', project_name, '_Est', type_theta, num_question_Est, 
              'questions.RData'))
  estimates <- rstan::extract(hier_time)
  subtitle <- paste0(project_name, ' Time Estimated by ', 
                     type_theta, ' theta with ', num_question_Est, ' questions')

  betas <- colMeans(estimates$beta)
  rs <- colMeans(estimates$r)
  deltas <- colMeans(estimates$delta)
  
  dist_betas <- ggplot() +
    geom_histogram(mapping = aes(x = betas), bins = 30) +
    labs(x = 'Individual betas') +
    geom_vline(xintercept = mean(betas), color = 'red') +
    annotate("text", x = mean(betas), y = 0, 
             label = paste0("Mean: ", round(mean(betas),4)), col="red") +
    geom_vline(xintercept = median(betas), color = 'green') +
    annotate("text", x = median(betas), y = 5, 
             label = paste0("Median: ", round(median(betas),4)), col="green") +
    labs(title = subtitle) + 
    xlim(c(mean(betas) - 2*sd(betas), mean(betas) + 2*sd(betas)))
  
  dist_rs <- ggplot() +
    geom_histogram(mapping = aes(x = rs), bins = 40) +
    labs(x = 'Individual rs') +
    geom_vline(xintercept = mean(rs), color = 'red') +
    annotate("text", x = mean(rs), y = 0, 
             label = paste0("Mean: ", round(mean(rs),4)), col="red") +
    geom_vline(xintercept = median(rs), color = 'green') +
    annotate("text", x = median(rs), y = 5, 
             label = paste0("Median: ", round(median(rs),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(rs) - 2*sd(rs), mean(rs) + 2*sd(rs)))
  
  dist_deltas <- ggplot() +
    geom_histogram(mapping = aes(x = deltas), bins = 30) +
    labs(x = 'Individual deltas') +
    geom_vline(xintercept = mean(deltas), color = 'red') +
    annotate("text", x = mean(deltas), y = 0, 
             label = paste0("Mean: ", round(mean(deltas),4)), col="red") +
    geom_vline(xintercept = median(deltas), color = 'green') +
    annotate("text", x = median(deltas), y = 5, 
             label = paste0("Median: ", round(median(deltas),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(deltas) - 2*sd(deltas), mean(deltas) + 2*sd(deltas)))
  
  grid.arrange(dist_betas, dist_rs, dist_deltas, ncol = 1)
}
