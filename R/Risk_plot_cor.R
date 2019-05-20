#' Plot Correlation between Estimates for Risk Preferences
#' @description For each subject, the function firstly computes the correlation coefficient between posterior sampling drawers of two parameters set by \code{parameter1} and \code{parameter2}. Then it draws the distribution of all correlation coefficients across all subjects. 
#' Only run this function when stanfit object for study \code{project_name} is saved under directory \code{path} after estimation.
#' @param project_name The name of this study. 
#' @param num_question_Est How many questions used in this estimation.
#' @param type_theta Type of scaling response noise parameter used in this estimation, specify either "Global", "Individual" or "Hier".
#' @param path Full path for working directory.
#' @param parameter1 First parameter. Specify either "alpha", "sigma" or "lambda".
#' @param parameter2 Second parameter. Specify another parameter in "alpha", "sigma" or "lambda".
#' 
#' @import ggplot2
#' @importFrom rstan extract
#' @return  Return the distribution plot for all individual level correlation coefficients between two parameters specified.
#' @export
#'
#' @examples
#' Risk_plot_cor(project_name = 'test', num_question_Est = 12, type_theta = 'Hier', path = '/Users/ap/Desktop', 
#' parameter1 = 'alpha', parameter2 = 'sigma')
Risk_plot_cor <- function(project_name, 
                          num_question_Est,
                          type_theta, 
                          path,
                          parameter1,
                          parameter2){
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  load(paste0(path, '/Stan_Risk_', project_name, '_Est', type_theta, num_question_Est, 
                'questions.RData'))
  stan <- rstan::extract(hier_risk)
  subtitle <- paste0(project_name, ' Risk Estimated by ', 
                     type_theta, ' theta with ', num_question_Est, ' questions')
  
  p1 <- matrix(unlist(stan[parameter1]), nrow = dim(stan$alpha)[1], byrow = F)
  p2 <- matrix(unlist(stan[parameter2]), nrow = dim(stan$alpha)[1], byrow = F)
  ind_cor <- diag(cor(p1, p2))
  
  ggplot() +
    geom_density(mapping = aes(x = ind_cor), fill = 'blue', alpha = 0.2) +
    xlab('Correlation Coefficient') +
    theme(legend.position=c(0.8,0.8)) +
    labs(title = paste0('Individual Correlation bet ', parameter1, ' and ', parameter2),
         subtitle  = subtitle) +
    geom_vline(xintercept = mean(ind_cor), col='red') +
    annotate("text", x=mean(ind_cor), y=0, label=paste0(round(mean(ind_cor),4)), col="black") 
}
