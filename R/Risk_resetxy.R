# 
# clarified in the paper, 
#' Title
#' @description Prepare data and make sure the values of x and y fall into the two situations of CPT model indicated in original paper: either \eqn{x>y>0|x<y<0}, or \eqn{x < 0 < y}.
#' Called by function \code{\link{Stan_Risk_Estimation}}.
#' @param g1g2 One row with contexts for two options in one Risk question. 
#'
#' @return Arranged data.
#' @export
#'
#' @examples
#' Risk_resetxy(g1g2)
Risk_resetxy <- function(g1g2){
  g1 <- g1g2[1:4]
  g2 <- g1g2[5:8]
  if(g1[1]*g1[3] < 0){
    if (g1[1] > 0){
      g1g2[1:2] <- g1[3:4]
      g1g2[3:4] <- g1[1:2]
    }
  } else{
    index <- which.max(c(abs(g1[1]), abs(g1[3])))
    if(index == 2){
      g1g2[1:2] <- g1[3:4]
      g1g2[3:4] <- g1[1:2]
    }
  }
  
  if(g2[1]*g2[3] < 0){
    if (g2[1] > 0){
      g1g2[5:6] <- g2[3:4]
      g1g2[7:8] <- g2[1:2]
    }
  } else{
    index <- which.max(c(abs(g2[1]), abs(g2[3])))
    if(index == 2){
      g1g2[5:6] <- g2[3:4]
      g1g2[7:8] <- g2[1:2]
    }
  }
  return(g1g2)
}