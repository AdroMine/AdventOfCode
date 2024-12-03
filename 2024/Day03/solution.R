setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')

p1 <- 0
p2 <- 0

safe <- function(line){
  diffs <- diff(line)
  inc_dec <- all(diffs > 0) || all(diffs < 0)
  lev <- all(abs(diffs) %in% c(1, 2, 3))
  inc_dec && lev
}

for(line in input){
  line <- as.integer(strsplit(line, " ")[[1]])
  
  if(safe(line)) {
    p1 <- p1 + 1
  } else {
    
    for(i in seq_along(line)){
      
      if(safe(line[-i])){
        p2 <- p2 + 1
        break
      }
    }
  }
}

p1
p1 + p2
