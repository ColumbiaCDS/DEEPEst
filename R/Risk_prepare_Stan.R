#' Prepare Data for Stan Risk Estimation
#' @description After reading, processing and denoising necessary data. This function will create an R list object containing all data to run estimation for DEEP Risk.
#' Called by function \code{\link{Stan_Risk_Estimation}}.
#' @param all_Stan_data Data needed to be processed.
#' @param num_question_Est How many questions are going to be used in this estimation.
#' @param subjectNumber Number of subjects in this survey.
#'
#' @import dplyr
#' @importFrom reshape2 acast
#' 
#' @return Several objects will be returned into global enviornment:
#' \itemize{
#'   \item x1: a dataframe contains amounts of first rewards in the left options. 
#'   \item p1: a dataframe contains the probabilities receiving \code{x1}.
#'   \item y1: a dataframe contains amounts of second rewards in the left options.
#'   \item q1: a dataframe contains the probabilities receiving \code{y1}.
#'   \item x2: a dataframe contains amounts of first rewards in the right options.
#'   \item p2: a dataframe contains the probabilities receiving \code{x2}.
#'   \item y2: a dataframe contains amounts of second rewards in the right options.
#'   \item q2: a dataframe contains the probabilities receiving \code{y2}.
#'   \item choices: a dataframe contains all choices made by subjects with "0" means left option is chosen and "1" means right option is chosen.
#'   \item moddat: a list object contains all these data needed in estimation model.
#' }
#' 
#' @export
#'
#' @examples
#' Risk_prepare_Stan(all_Stan_data = all_Stan_data, num_question_Est = 12, subjectNumber = 200)

Risk_prepare_Stan <- function(all_Stan_data, subjectNumber, num_question_Est)
{
  all_Stan_data <- all_Stan_data %>% filter(QuestionNum <= num_question_Est)
  
  
  x1 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, x1) %>%
    acast(SubjectID ~ QuestionNum, value.var = "x1")
  p1 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, p1) %>%
    acast(SubjectID ~ QuestionNum, value.var = "p1")
  y1 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, y1) %>%
    acast(SubjectID ~ QuestionNum, value.var = "y1")
  q1 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, q1) %>%
    acast(SubjectID ~ QuestionNum, value.var = "q1")
  
  x2 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, x2) %>%
    acast(SubjectID ~ QuestionNum, value.var = "x2")
  p2 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, p2) %>%
    acast(SubjectID ~ QuestionNum, value.var = "p2")
  y2 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, y2) %>%
    acast(SubjectID ~ QuestionNum, value.var = "y2")
  q2 <- all_Stan_data %>%
    select(SubjectID, QuestionNum, q2) %>%
    acast(SubjectID ~ QuestionNum, value.var = "q2")
  
  choices <- all_Stan_data %>%
    select(SubjectID, QuestionNum, Choice)  %>%
    acast(SubjectID ~ QuestionNum, value.var = "Choice")
    
  assign("x1", x1, envir = .GlobalEnv)
  assign("p1", p1, envir = .GlobalEnv)
  assign("y1", y1, envir = .GlobalEnv)
  assign("q1", q1, envir = .GlobalEnv)
  assign("choices", choices, envir = .GlobalEnv)
  assign("x2", x2, envir = .GlobalEnv)
  assign("p2", p2, envir = .GlobalEnv)
  assign("y2", y2, envir = .GlobalEnv)
  assign("q2", q2, envir = .GlobalEnv)
  
  moddat <- list("npart" = subjectNumber, 
                 "nchoice" = num_question_Est,
                 "choices" = choices,
                 "x1" = x1,
                 "p1" = p1,
                 "y1" = y1,
                 "q1" = q1,
                 "x2" = x2,
                 "p2" = p2,
                 "y2" = y2,
                 "q2" = q2)
  assign("moddat", moddat, envir = .GlobalEnv)
}
