setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')

match_result <- function(turn){
  
  switch(
    turn, 
    `A X` = 1 + 3, 
    `A Y` = 2 + 6, 
    `A Z` = 3 + 0, 
    `B X` = 1 + 0, 
    `B Y` = 2 + 3, 
    `B Z` = 3 + 6,
    `C X` = 1 + 6, 
    `C Y` = 2 + 0, 
    `C Z` = 3 + 3
  )
  
}

score <- 0

# Part 1
sum(sapply(input, match_result))



# Part 2
match_result2 <- function(turn){
  
  switch(
    turn, 
    `A X` = 3 + 0, 
    `A Y` = 1 + 3, 
    `A Z` = 2 + 6, 
    `B X` = 1 + 0, 
    `B Y` = 2 + 3, 
    `B Z` = 3 + 6,
    `C X` = 2 + 0, 
    `C Y` = 3 + 3, 
    `C Z` = 1 + 6
  )
  
}


sum(sapply(input, match_result2))
