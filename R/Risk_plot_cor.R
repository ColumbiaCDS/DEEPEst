# The function to get the correlation coefficient between parameter estimates across all subjects
Risk_plot_cor <- function(project_name, 
                          num_question_Est,
                          type_theta, 
                          path,
                          parameter1,
                          parameter2){
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  # Make sure we have individual estimates for response noise parameter
  if('theta' %in% c(parameter1, parameter2)){
    stopifnot(type_theta %in% c('Individual', 'Hier'))
  }
  
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