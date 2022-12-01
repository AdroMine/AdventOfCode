
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')
  
seps <- which(input == "")

start <- c(1, seps[-length(seps)] + 1)
end <- seps

inputs <- purrr::map2(start, end, ~as.numeric(input[.x:(.y - 1)]))

# Part 1 
all_sums <- sapply(inputs, sum)

max(all_sums)

# Part 2 

sort(all_sums, decreasing = TRUE)[1:3] |> sum()
