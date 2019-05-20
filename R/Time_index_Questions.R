#' Index and Arrange Time Questions
#' @description Index and arrange questions so that smaller-sooner and larger-later options would be arranged as expected. 
#' Called by function \code{\link{Stan_Time_Estimation}}.
#' @param stan_data Data needed to be processed.
#' @param subjectNumber Number of subjects in this survey.
#' @param num_question How many questions are asked for each subject in this survey.
#'
#' @return Return the indexed and arranged data.
#' @export
#'
#' @examples
#' Time_Index_Questions(stan_data = stan_data, subjectNumber = 200, num_question = 20)
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