setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> stringr::str_extract_all('\\d+')

times <- as.numeric(input[[1]])
distances <- as.numeric(input[[2]])

ways_to_win <- vector('numeric', length(time))

for(i in seq_along(time)){
  
  tm <- times[i]
  dist <- distances[i]
  
  
  hold_down_for <- seq_len(tm - 1)
  distances_travelled <- hold_down_for * (tm - hold_down_for)
  
  wins <- sum(distances_travelled > dist)
  
  ways_to_win[i] <- wins
  
  
  
}

# Part 2
time <- as.numeric(paste0(input[[1]], collapse = ''))
dist <- as.numeric(paste0(input[[2]], collapse = ''))

hold_down_for <- seq_len(time - 1)
dist_travelled <- hold_down_for * (time - hold_down_for)

wins <- sum(dist_travelled > dist)
