setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'example.txt'
# file_name <- 'example2.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name)[1])
input <- read.fwf(file_name, widths = rep(1, W), comment.char = "") |> as.matrix()
R <- nrow(input)
C <- ncol(input)

antinodes1 <- matrix(FALSE, R, C) # For part 1
antinodes2 <- matrix(FALSE, R, C) # For part 2
antennas <- sort(unique(input[which(input != '.', arr.ind = TRUE)]))

in_bounds <- function(coord, R, C){
  unname(coord[1] >= 1 & coord[1] <= R & coord[2] >= 1 & coord[2] <= C)
}

# Part 1 & 2

for(ant in antennas){
  
  indices <- which(input == ant, arr.ind = TRUE)
  # skip antenna if only one
  if(nrow(indices) < 2) next
  
  combs <- combn(seq_len(nrow(indices)), m = 2)
  for(i in 1:ncol(combs)){
    
    pairs <- indices[combs[,i],]
    pair1 <- pairs[1,]
    pair2 <- pairs[2,]
    dist  <- abs(pair1 - pair2)
    # should I add dist to pair1 or substract
    # if pair1 is to left of pair1 , subtract from pair1, otherwise add
    left <- if(pair1[2] < pair2[2]) 1 else -1
    up <- if(pair1[1] < pair2[1]) 1 else -1
    
    # possible antinodes from pair 1
    antinode1 <- pair1 - c(up * dist[1], left * dist[2]) 
    if(in_bounds(antinode1, R, C)) antinodes1[antinode1[1], antinode1[2]] <- TRUE
    while(TRUE){
      if(in_bounds(antinode1, R, C)) {
        antinodes2[antinode1[1], antinode1[2]] <- TRUE
        antinode1 <- antinode1 - c(up * dist[1], left * dist[2]) 
      } else {
        break
      }
    }
    
    # possible antinodes from pair 2
    antinode2 <- pair2 + c(up * dist[1], left * dist[2])
    if(in_bounds(antinode2, R, C)) antinodes1[antinode2[1], antinode2[2]] <- TRUE
    while(TRUE){
      if(in_bounds(antinode2, R, C)) {
        antinodes2[antinode2[1], antinode2[2]] <- TRUE
        antinode2 <- antinode2 + c(up * dist[1], left * dist[2])
      } else {
        break
      }
    }
    antinodes2[pair1[1], pair1[2]] <- TRUE
    antinodes2[pair2[1], pair2[2]] <- TRUE
  }
}

sum(antinodes1)
sum(antinodes2)
