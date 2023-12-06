setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> stringr::str_extract_all('\\d+')

times <- as.numeric(input[[1]])
distances <- as.numeric(input[[2]])

ways_to_win <- vector('numeric', length(times))

for(i in seq_along(times)){
  
  tm <- times[i]
  dist <- distances[i]
  
  
  hold_down_for <- seq_len(tm - 1)
  distances_travelled <- hold_down_for * (tm - hold_down_for)
  
  wins <- sum(distances_travelled > dist)
  
  ways_to_win[i] <- wins
  
}

# Part 1
prod(ways_to_win)

# Part 2
time <- as.numeric(paste0(input[[1]], collapse = ''))
dist <- as.numeric(paste0(input[[2]], collapse = ''))

hold_down_for <- seq_len(time - 1)
dist_travelled <- hold_down_for * (time - hold_down_for)

wins <- sum(dist_travelled > dist)
wins


# Non Brute force
# We have equation for distance travelled
# x * (T - x)
# We want -> xT - x^2 > D
# -x2 + xT - D > 0
# We can solve for -x2 + xT -D = 0 (quadratic equation)
# we will get two points where the parabola meets the horizontal axis. Any points between 
# them will be valid points that will lead to winning situation
# quadratic formula x = (-b + c(-1, 1) * root(b^2 - 4ac)) / 2(a)
# x = (-T + c(-1, 1) * (T^2 - 4 * (-1)*(-D))^(1/2)) / (2 * (-1))
# x = (T - c(-1, 1) * (T^2 - 4D)^0.5) / (2)

quad_sol <- function(time, distance){
  
  sort(floor((time - c(-1, 1) * (time^2 - 4*distance)^0.5) / 2))
  
}

num_win_methods <- function(time, distance){
  diff(quad_sol(time, distance))
}

# Part 1
mapply(num_win_methods, times, distances) |> prod()


# Part 2

time <- as.numeric(paste0(input[[1]], collapse = ''))
dist <- as.numeric(paste0(input[[2]], collapse = ''))

num_win_methods(time, dist)
