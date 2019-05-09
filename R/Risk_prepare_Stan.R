## The function for formatting the input data to be compatible in stan 
Risk_prepare_Stan <- function(all_Stan_data, num_question_Est, subjectNumber)
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
  
  #choices_made <- choices + 1
  
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
