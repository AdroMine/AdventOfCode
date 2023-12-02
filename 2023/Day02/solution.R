
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')

p1 <- 0
p2 <- 0

total <- c(red = 12, green = 13, blue = 14)

for(i in seq_along(input)){
  
  iterations <- strsplit(input[i], ": ")[[1]][2]
  
  required <- c(green = 0, red = 0, blue = 0)
  p1_possible <- TRUE
  
  for (it in strsplit(iterations, "; ")[[1]]) {
    
    balls_shown <- strsplit(it, ', ')[[1]]
    for(b in balls_shown){
      
      temp <- strsplit(b, ' ')[[1]]
      colour <- temp[2]
      num <- as.numeric(temp[1])
      
      required[colour] <- max(required[colour], num)
      if(total[colour] < num) p1_possible <- FALSE
      
    }
  }
  
  power_min_set <- prod(required)
  p1 <- p1 + i*p1_possible
  p2 <- p2 + power_min_set
  
}


p1
p2
