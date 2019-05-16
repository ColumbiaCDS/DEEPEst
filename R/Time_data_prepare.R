# The function to make the data files from original survey data output for Stan estimation.
# This function automatically drop those "unengaged" responses (noisy ones with only random choices).
# It drops all responses which are completed within each_seconds * num_questions seconds in total.
# It also drops all responses which contain only one-side options (only left or right chose options).

#' Survey Data Read, Clean and Denoise
#' @description Read Survey
#' @param project_name The name of this study.
#' @param path Full path for working directory.
#' @param num_question How many questions are asked for each subject in this suvery.
#' @param clean_time Logical value. Default is TRUE means you want to denoise the original data by dropping those 
#' @param clean_side 
#' @param each_seconds 
#'
#' @import dplyr
#' 
#' @return Three csv files will be saved under directory indicated by \code{path}:
#' \itemize{
#'   \item "\{\code{project_name}\}_Time_options_chosen.csv" contains all estimates of individual \eqn{\beta} (present-bias parameter), \eqn{r} (daily discount rate) and yearly discount factor \eqn{\delta} respectively as in three columns. The number of rows is the number of subjects in the survey. 
#'   \item "\{\code{project_name}\}_Time_options_notchosen.csv" contains estimates of either global or individual scaling response error parameter \eqn{\theta}.
#'   \item "\{\code{project_name}\}_Time_serials.csv" contains serial number for each subject as identification.
#' }
#' @export
#'
#' @examples
#' Time_data_prepare(project_name = 'test', path = '/Users/ap/Desktop', num_question = 12)
Time_data_prepare <- function(project_name, 
                              path, 
                              num_question,
                              clean_time = T, 
                              clean_side = T, 
                              each_seconds = 3
                              ){
  
  original <- read.csv(paste0(path, '/DEEP_Time_surveydata_', project_name, '.csv'), as.is = T, header = T)
  # Keep only complete rows
  original <- original[complete.cases(original),]
  rownames(original) <- seq(nrow(original))
  
  if (clean_time == T){
    # Drop all responses with random choices defined by using time less than each_seconds seconds on average
    # This argument controls how we regard responses as noisy responses completed just randomly by subjects.
    #During data cleaning, we will first drop responses which are finished within (each_seconds * num_questions) seconds in total.
    used_time <- original %>% group_by(participant) %>% summarise(sum = sum(timesincepresentation))
    original <- original %>% filter(participant %in% used_time$participant[used_time$sum > num_question * each_seconds])
    rownames(original) <- seq(nrow(original))
  }
  
  if (clean_side == T){
    # It also drops all responses which contain only one-side options (only left or right chose options).
    # Min seconds spent on each question on average so that the responses would be considered as a normal response,  
    # otherwise, they will be considered as noisy ones and dropped. 
    all_oneside <- original %>% group_by(participant) %>% summarise(one_side = all(chosenside == 1) | all(chosenside == 0))
    original <- original %>% filter(participant %in% all_oneside$participant[all_oneside$one_side == FALSE])
    rownames(original) <- seq(nrow(original))
  }
  
  subjectNumber <- length(unique(original$participant))
  
  # Attention, as default gambles1 will contain the actual options made by subjects
  
  gambles1 <- matrix(c(original$chosendollars, original$chosentime), ncol = 2)
  gambles2 <- matrix(c(original$nonchosendollars, original$nonchosentime), ncol = 2)

  write.table(x = gambles1, paste0(path, '/', project_name, '_Time_options_chosen.csv'), col.names = F, row.names = F, sep = ',')
  write.table(x = gambles2, paste0(path, '/', project_name, '_Time_options_notchosen.csv'), col.names = F, row.names = F, sep = ',')
  write.table(unique(original$serial), paste0(path, '/', project_name, '_Time_serials.csv'), row.names = F, col.names = F, sep = ',')
}