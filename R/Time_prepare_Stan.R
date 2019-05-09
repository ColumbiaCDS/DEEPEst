library(dplyr)

Time_prepare_Stan <- function(all_Stan_data, 
                        num_question_Est, 
                        subjectNumber){

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
  
  choices_made <- choices + 1
  
  assign("ss_amnt", ss_amnt, envir = .GlobalEnv)
  assign("ll_amnt", ll_amnt, envir = .GlobalEnv)
  assign("ss_delay", ss_delay, envir = .GlobalEnv)
  assign("ll_delay", ll_delay, envir = .GlobalEnv)
  assign("choices", choices, envir = .GlobalEnv)
  assign("choices_made", choices_made, envir = .GlobalEnv)
  
  moddat <- list("npart" = subjectNumber, 
                 "nchoice" = num_question_Est,
                 "choices" = choices,
                 "ss_amnt" = ss_amnt,
                 "ss_delay" = ss_delay,
                 "ll_amnt" = ll_amnt,
                 "ll_delay" = ll_delay)
  assign("moddat", moddat, envir = .GlobalEnv)
}
