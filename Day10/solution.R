setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- as.integer(readLines("input.txt"))

# Add start and end and sort
input <- sort(c(input, max(input) + 3, 0))

# Answer 1
differences <- input[-1] - input[-length(input)]
prod(table(differences))

# Answer 2

# initialise empty vector
# combs <- vector("integer", length = length(input)-1)
# 
# for(i in 1:(length(input)-1)){
#     # Extract next
#     n <- input[i]
#     nxt_nums <- input[(i):(i+3)]
#     nxt_nums <- na.omit(nxt_nums[nxt_nums - n <=3])
#     # Get possible combos
#     combs[i] <- switch(length(nxt_nums), 1, 1, 2, 4)
# }
# 
# # Go through list and replace pattern [4,2] with [4, 1] and [4, 4] with [7,1]
# for(i in length(combs):2){
#     if(combs[i] == 2 && combs[i-1] == 4)
#         combs[i] <- 1
#     if(combs[i] == 4 && combs[i-1] == 4){
#         combs[i] <- 1
#         combs[i-1] <- 7
#     }
# }

# Better method

# Get runs of equal values in differences
k <- rle(differences)

# Extract no of groups of 1
k <- k$lengths[which( k$values != 3 )]

# Create mapping (based on tribonacci series)
mapping <- c(1, 2, 4, 7, 13)
prod(mapping[k])

# if there are 4 consecutive ones, implies 7 possible combinations, 
# for 3 consecutive ones 3 possible combinations
# for 2 consecutive ones 2 possible combinations, etc. 
# for 5 consecutive ones 13 possible combinations would have been there


# Dynamic Programming based on arknave
n <- length(input)
dp <-  rep(0, n-1)
dp[1] <- 1

for(i in 2:(n-1)){
    ans = 0
    # look at previous three elements
    idx <- max(1, i-3):(i-1)
    b <- input[idx] + 3 >= input[i]
    ans <- sum(dp[idx[b]])
    dp[i] <- ans
        
}

print(dp[n-1], digits = 20)


