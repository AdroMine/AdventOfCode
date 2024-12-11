setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'example.txt'
file_name <- 'input.txt'
input <- readLines(file_name)
input <- strsplit(input, " ")[[1]] |> as.numeric()

cache <- collections::dict()

blink_count <- function(num, steps){
  if(steps == 0)
    return(1)
  if(cache$has(c(num, steps))){
    return(cache$get(c(num, steps)))
  }
  
  if(num == 0){
    ans <- blink_count(1, steps - 1)
  } else if(num_digits(num) %% 2 == 0){
    num_l <- num_digits(num)
    left <- num %/% 10^(num_l/2)
    right <- num %% 10^(num_l/2)
    ans <- blink_count(left, steps - 1) + blink_count(right, steps - 1)
  } else {
    ans <- blink_count(num * 2024, steps - 1)
  }
  cache$set(c(num, steps), ans)
  
  ans
  
}

# Part 1
sapply(input, blink_count, steps = 25) |> sum()

# Part 2
sapply(input, blink_count, steps = 75) |> sum()







# Earlier slow never ending solution
num_digits <- function(num) floor(log10(num)) + 1

blink_once <- function(num_list){
  
  new_list <- c()
  new_list <- vector('numeric', length = length(num_list) * 2)
  idx <- 1
  for(num in num_list){
    if(num == 0){
      # new_list <- c(new_list, 1)
      new_list[idx] <- 1
      idx <- idx + 1
    } else if(num_digits(num) %% 2 == 0){
      num_l <- num_digits(num)
      left <- num %/% 10^(num_l/2)
      right <- num %% 10^(num_l/2)
      # new_list <- c(new_list, left, right)
      
      new_list[idx] <- left
      new_list[idx + 1] <- right
      idx <- idx + 2
    } else {
      # new_list <- c(new_list, num * 2024)
      new_list[idx] <- num*2024
      idx <- idx + 1
    }
  }
  new_list
}

output <- input
for(step in 1:25){
  output <- blink_once(output)
  print(log(length(output), base = 2))
}

length(output)
