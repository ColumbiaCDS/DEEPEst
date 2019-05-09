# use the output as the input of RStan
Time_index_Questions <- function(stan_data, 
                         subjectNumber,
                         num_question)
{
  for(subjN in 1:subjectNumber)
  {
    for(questN in 1:num_question)
    {
      rowIndex <- (subjN - 1) * num_question + questN
      stan_data$SubjectID[rowIndex] <- subjN
      stan_data$QuestionNum[rowIndex] <- questN
      
      # ensure that we have ss and ll in the right order
      if(stan_data$LL_Delay[rowIndex] < stan_data$SS_Delay[rowIndex])
      {
        temp_lldelay <- stan_data$SS_Delay[rowIndex]
        temp_llamount <- stan_data$SS_Amount[rowIndex]
        
        stan_data$SS_Delay[rowIndex] <- stan_data$LL_Delay[rowIndex]
        stan_data$SS_Amount[rowIndex] <- stan_data$LL_Amount[rowIndex]
        
        stan_data$LL_Delay[rowIndex] <- temp_lldelay
        stan_data$LL_Amount[rowIndex] <- temp_llamount
        
        stan_data$Choice[rowIndex] <- 1
      }
    }
  }
  return(stan_data)
}