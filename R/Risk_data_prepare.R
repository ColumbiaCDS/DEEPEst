#' Read, Clean and Denoise Risk Survey Data
#' @description Read and denoise the original suvery output data. Only complete rows would be reserved. In addition, this function automatically drops those "unengaged" responses (noisy ones with only random choices, not involving utility consideration).
#' Once you obtain the original output csv file from DEEP survey under directory \code{path}, rename it to be "DEEP_\{\code{model}\}_surveydata_\{\code{project_name}\}.csv", where "\code{model}" is either "Time" or "Risk".

#' @param project_name The name of this study.
#' @param path Full path for working directory.
#' @param num_question How many questions are asked for each subject in this suvery.
#' @param each_seconds How many seconds spent on each question on average so that the observation would be considered as a reasonable response.
#' @param clean_time Logical value. Default is \code{TRUE} means you want to denoise the original data by dropping all responses which are completed within \code{num_question} times \code{each_seconds} seconds.
#' @param clean_side Logical value. Default is \code{TRUE} means you want to denoise the original data by dropping all responses which only contain one-side options, namely, only left or right options chosen.
#'
#' @import dplyr
#' 
#' @return Three csv files will be saved under directory indicated by \code{path} and used in estimation function \code{\link{Stan_Risk_Estimation}}:
#' \itemize{
#'   \item "\{\code{project_name}\}_Risk_options_chosen.csv" contains amounts of rewards (first column) and delayed days (second column) of all chosen options. The number of rows is \code{num_question} times \code{num_subjects}, where \code{num_subjects} is the number of subjects in this survey after denoising.
#'   \item "\{\code{project_name}\}_Risk_options_notchosen.csv" is same as the above one except this contains data of unchosen options among all questions.
#'   \item "\{\code{project_name}\}_Risk_serials.csv" contains serial number for each subject as identification.
#' }
#' @export
#'
#' @examples
#' Risk_data_prepare(project_name = 'test', path = '/Users/ap/Desktop', num_question = 12)
Risk_data_prepare <- function(project_name, 
                              path, 
                              num_question,
                              clean_time = T, 
                              clean_side = T, 
                              each_seconds = 2
                              ){
  
  original <- read.csv(paste0(path, '/DEEP_Risk_surveydata_', project_name, '.csv'), as.is = T, header = T)
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
  
  gambles1 <- matrix(c(original$chosenamount1, original$chosenprob1, original$chosenamount2, original$chosenprob2), ncol = 4)
  gambles2 <- matrix(c(original$nonchosenamount1, original$nonchosenprob1, original$nonchosenamount2, original$nonchosenprob2), ncol = 4)

  write.table(x = gambles1, paste0(path, '/', project_name, '_Risk_options_chosen.csv'), col.names = F, row.names = F, sep = ',')
  write.table(x = gambles2, paste0(path, '/', project_name, '_Risk_options_notchosen.csv'), col.names = F, row.names = F, sep = ',')
  write.table(unique(original$serial), paste0(path, '/', project_name, '_Risk_serials.csv'), row.names = F, col.names = F, sep = ',')
}