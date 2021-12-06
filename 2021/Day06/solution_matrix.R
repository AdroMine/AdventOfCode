setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- as.integer(strsplit(readLines("input.txt", n = 1), ",")[[1]])

# Create transition matrix
# total 9 transition states (index starts at 1 here)
mat <- matrix(0, nrow = 9, ncol = 9) 
mat[row(mat) - 1 == col(mat)] <- 1
mat[1, c(7, 9)] <- 1

# Transition matrix = 

#      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
# [1,]    0    0    0    0    0    0    1    0    1
# [2,]    1    0    0    0    0    0    0    0    0
# [3,]    0    1    0    0    0    0    0    0    0
# [4,]    0    0    1    0    0    0    0    0    0
# [5,]    0    0    0    1    0    0    0    0    0
# [6,]    0    0    0    0    1    0    0    0    0
# [7,]    0    0    0    0    0    1    0    0    0
# [8,]    0    0    0    0    0    0    1    0    0
# [9,]    0    0    0    0    0    0    0    1    0

# first row defines what is the prob of moving from state 1 (day 0) to other
# states we know that with 100% prob, fish in day 0 (state 1) will move to day 6
# and 8 (state 7 and 9) so they both columns have values 1 for first row
# similarly for fish in day 2 will move to day 1 (thus mat[2, 1] = 1) and so on


fishes <- rep(0, 9)
fishes[1:9] <- sapply(1:9, function(x) sum(input == x-1))

k <- fishes
for(day in 1:256){
    # status of fishes after one iteration -> fishes_after = fishes_before %*% transition_matrix
    k <- k %*% mat
    if(day %in% c(80, 256))
        print(sum(k), digits = 22)
}



# can remove the for loop and use this instead
Reduce(function(x, y) x %*% mat, 1:80, init = fishes) |> sum() |> as.character()
Reduce(function(x, y) x %*% mat, 1:256, init = fishes) |> sum() |> as.character()
