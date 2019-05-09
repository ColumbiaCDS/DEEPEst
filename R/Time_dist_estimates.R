library(ggplot2)
library(dplyr)
library(reshape2)

## The function to plot the distribution of preference parameter estimates
Time_dist_estimates <- function(project_name, 
                           num_question_Est,
                           type_theta, 
                           path){
  
  # Make sure the type of delta used is correct
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
    annotate("text", x = mean(betas), y = 40, 
             label = paste0("Mean: ", round(mean(betas),4)), col="red") +
    geom_vline(xintercept = median(betas), color = 'green') +
    annotate("text", x = median(betas), y = 60, 
             label = paste0("Median: ", round(median(betas),4)), col="green") +
    labs(title = subtitle) + 
    xlim(c(mean(betas) - 2*sd(betas), mean(betas) + 2*sd(betas)))
  
  dist_rs <- ggplot() +
    geom_histogram(mapping = aes(x = rs), bins = 40) +
    labs(x = 'Individual rs') +
    geom_vline(xintercept = mean(rs), color = 'red') +
    annotate("text", x = mean(rs), y = 40, 
             label = paste0("Mean: ", round(mean(rs),4)), col="red") +
    geom_vline(xintercept = median(rs), color = 'green') +
    annotate("text", x = median(rs), y = 60, 
             label = paste0("Median: ", round(median(rs),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(rs) - 2*sd(rs), mean(rs) + 2*sd(rs)))
  
  dist_deltas <- ggplot() +
    geom_histogram(mapping = aes(x = deltas), bins = 30) +
    labs(x = 'Individual deltas') +
    geom_vline(xintercept = mean(deltas), color = 'red') +
    annotate("text", x = mean(deltas), y = 40, 
             label = paste0("Mean: ", round(mean(deltas),4)), col="red") +
    geom_vline(xintercept = median(deltas), color = 'green') +
    annotate("text", x = median(deltas), y = 60, 
             label = paste0("Median: ", round(median(deltas),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(deltas) - 2*sd(deltas), mean(deltas) + 2*sd(deltas)))
  
  multiplot(dist_betas, dist_rs, dist_deltas,
            cols=1)
}
