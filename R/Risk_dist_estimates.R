## The function to plot the distribution of preference parameter estimates
Risk_dist_estimates <- function(project_name,
                                num_question_Est,
                                type_theta,
                                path){
  
  # Make sure the type of delta used is correct
  stopifnot(type_theta %in% c('Global', 'Individual', 'Hier'))
  
  load(paste0(path, '/Stan_Risk_', project_name, '_Est', type_theta, num_question_Est, 
                'questions.RData'))
  estimates <- rstan::extract(hier_risk)
  subtitle <- paste0(project_name, ' Risk Estimated by ', 
                     type_theta, ' theta with ', num_question_Est, ' questions')
  
  alphas <- colMeans(estimates$alpha)
  sigmas <- colMeans(estimates$sigma)
  lambdas <- colMeans(estimates$lambda)
  
  dist_alphas <- ggplot() +
    geom_histogram(mapping = aes(x = alphas), bins = 30) +
    labs(x = 'Individual alphas') +
    geom_vline(xintercept = mean(alphas), color = 'red') +
    annotate("text", x = mean(alphas), y = 40, 
             label = paste0("Mean: ", round(mean(alphas),4)), col="red") +
    geom_vline(xintercept = median(alphas), color = 'green') +
    annotate("text", x = median(alphas), y = 60, 
             label = paste0("Median: ", round(median(alphas),4)), col="green") +
    labs(title = subtitle) + 
    xlim(c(mean(alphas) - 2*sd(alphas), mean(alphas) + 2*sd(alphas)))
  
  dist_sigmas <- ggplot() +
    geom_histogram(mapping = aes(x = sigmas), bins = 40) +
    labs(x = 'Individual sigmas') +
    geom_vline(xintercept = mean(sigmas), color = 'red') +
    annotate("text", x = mean(sigmas), y = 40, 
             label = paste0("Mean: ", round(mean(sigmas),4)), col="red") +
    geom_vline(xintercept = median(sigmas), color = 'green') +
    annotate("text", x = median(sigmas), y = 60, 
             label = paste0("Median: ", round(median(sigmas),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(sigmas) - 2*sd(sigmas), mean(sigmas) + 2*sd(sigmas)))
  
  dist_lambdas <- ggplot() +
    geom_histogram(mapping = aes(x = lambdas), bins = 30) +
    labs(x = 'Individual lambdas') +
    geom_vline(xintercept = mean(lambdas), color = 'red') +
    annotate("text", x = mean(lambdas), y = 40, 
             label = paste0("Mean: ", round(mean(lambdas),4)), col="red") +
    geom_vline(xintercept = median(lambdas), color = 'green') +
    annotate("text", x = median(lambdas), y = 60, 
             label = paste0("Median: ", round(median(lambdas),4)), col="green") +
    labs(title = subtitle) +
    xlim(c(mean(lambdas) - 2*sd(lambdas), mean(lambdas) + 2*sd(lambdas)))
  
  multiplot(dist_alphas, dist_sigmas, dist_lambdas,
            cols=1)
  
}
