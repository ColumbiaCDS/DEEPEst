# Prepare data and make sure the values of x and y fall into the two situations 
# clarified in the paper, that is either 1: x>y>0 or x<y<0, or 2: x < 0 < y
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