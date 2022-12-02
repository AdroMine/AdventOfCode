setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')

match_result <- function(turn){
  switch(
    turn, 
    `A X` = 1 + 3,  `A Y` = 2 + 6,  `A Z` = 3 + 0, 
    `B X` = 1 + 0,  `B Y` = 2 + 3,  `B Z` = 3 + 6,
    `C X` = 1 + 6,  `C Y` = 2 + 0,  `C Z` = 3 + 3
  )
}

# Part 1
sum(sapply(input, match_result))

# Part 2
match_result2 <- function(turn){
  switch(
    turn, 
    `A X` = 3 + 0,  `A Y` = 1 + 3,  `A Z` = 2 + 6, 
    `B X` = 1 + 0,  `B Y` = 2 + 3,  `B Z` = 3 + 6,
    `C X` = 2 + 0,  `C Y` = 3 + 3,  `C Z` = 1 + 6
  )
}

sum(sapply(input, match_result2))


## Update!!
# Using modular
# Rock Paper Scissors
# the next element is what defeats (+1) (wins)
# the one after that is what loses (+2) (loses)
# so if we convert ABC to 123 and similarly XYZ to 123, we can
# check for differences to find if win/lose/draw

input2 <- read.table('input.txt')

input2$V1 <- chartr('ABC', '123', input2$V1) # p1 move
input2$V3 <- chartr('XYZ', '123', input2$V2) # p2 move for part1

# Part 2 helpers
input2$V4 <- chartr('XYZ', '036', input2$V2) # win-lose-score part2
# part 2 helper for computing move of P2
# XYZ - lose/draw/win - 2 ahead, same, 1 ahead
input2$V2 <- chartr('XYZ', '201', input2$V2) # p2 move helper for part2 

input2[,] <- lapply(input2, as.integer)

# differences (add 1 since index begins at 1 in R)
# 1 - draw, 2 - win, 3 - lose
diffs <- (input2$V3 - input2$V1) %% 3 + 1
scores <- c(3, 6, 0)

# Part 1 
sum(input2$V3 + scores[diffs])


# Part 2 

# compute move for p2
# XYZ - p2 loses, draws, wins - moves 2 ahead, same, 1 ahead

input2$V2 <- (input2$V1 + input2$V2 - 1) %% 3 + 1 # p2 move

sum(input2$V2 + input2$V4)



