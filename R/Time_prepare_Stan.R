#' Prepare Data for Stan Time Estimation
#' @description After reading, processing and denoising necessary data. This function will create an R list object containing all data to run estimation for DEEP Time.
#' Called by function \code{\link{Stan_Time_Estimation}}.
#' @param all_Stan_data Data needed to be processed.
#' @param subjectNumber Number of subjects in this survey.
#' @param num_question_Est How many questions are going to be used in this estimation.
#'
#' @import dplyr
#' @importFrom reshape2 acast
#' 
#' @return Several objects will be returned into global enviornment:
#' \itemize{
#'   \item ss_amnt: a dataframe contains amounts of rewards in all smaller-sooner options.
#'   \item ll_amnt: a dataframe contains amounts of rewards in all larger-later options.
#'   \item ss_delay: a dataframe contains delayed days of rewards in all smaller-sooner options.
#'   \item ll_delay: a dataframe contains delayed days of rewards in all larger-later options.
#'   \item choices: a dataframe contains all choices made by subjects with "0" means smaller-sooner option is chosen and "1" means larger-later option is chosen.
#'   \item moddat: a list object contains all these data needed in estimation model.
#' }
#' 
#' @export
#'
#' @examples
#' Time_prepare_Stan(all_Stan_data = all_Stan_data, num_question_Est = 12, subjectNumber = 200)
Time_prepare_Stan <- function(all_Stan_data, 
                              subjectNumber,
                              num_question_Est){

  all_Stan_data <- all_Stan_data %>% filter(QuestionNum <= num_question_Est)
  
  ss_amnt <- all_Stan_data %>%
    select(SubjectID, QuestionNum, SS_Amount) %>%
    acast(SubjectID ~ QuestionNum, value.var = "SS_Amount")
  
  ll_amnt <- all_Stan_data %>%
    select(SubjectID, QuestionNum, LL_Amount) %>%
    acast(SubjectID ~ QuestionNum, value.var = "LL_Amount")
  
  ss_delay <- all_Stan_data %>%
    select(SubjectID, QuestionNum, SS_Delay)  %>%
    acast(SubjectID ~ QuestionNum, value.var = "SS_Delay")
  ss_delay <- ss_delay
  
  ll_delay <- all_Stan_data %>%
    select(SubjectID, QuestionNum, LL_Delay)  %>%
    acast(SubjectID ~ QuestionNum, value.var = "LL_Delay")
  ll_delay <- ll_delay
  
  choices <- all_Stan_data %>%
    select(SubjectID, QuestionNum, Choice)  %>%
    acast(SubjectID ~ QuestionNum, value.var = "Choice")
    
  assign("ss_amnt", ss_amnt, envir = .GlobalEnv)
  assign("ll_amnt", ll_amnt, envir = .GlobalEnv)
  assign("ss_delay", ss_delay, envir = .GlobalEnv)
  assign("ll_delay", ll_delay, envir = .GlobalEnv)
  assign("choices", choices, envir = .GlobalEnv)
  
  moddat <- list("npart" = subjectNumber, 
                 "nchoice" = num_question_Est,
                 "choices" = choices,
                 "ss_amnt" = ss_amnt,
                 "ss_delay" = ss_delay,
                 "ll_amnt" = ll_amnt,
                 "ll_delay" = ll_delay)
  assign("moddat", moddat, envir = .GlobalEnv)
}
