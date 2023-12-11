setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
W <- readLines(file_name, n = 1) |> nchar()
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), comment.char = ''))

row_add <- which(rowSums(input == '#') == 0)
col_add <- which(colSums(input == '#') == 0) |> unname()

start <- which(input == '#', arr.ind = TRUE)

n_pts <- nrow(start)
combinations <- combn(n_pts, 2)

sum_distances <- function(input, times){
  dist <- 0
  for(i in 1:ncol(combinations)){
    
    st <- start[combinations[1,i],]
    ed <- start[combinations[2,i],]
    
    rows <- c(min(st[1], ed[1]), max(st[1], ed[1]))
    cols <- c(min(st[2], ed[2]), max(st[2], ed[2]))
    
    # add as many rows as needed to be added
    add_r <- sum(dplyr::between(row_add, rows[1], rows[2])) * times
    add_c <- sum(dplyr::between(col_add, cols[1], cols[2])) * times
    
    
    d <- sum(abs(st - ed)) + add_r + add_c
    dist <- dist + d
  } 
  dist
}

# part 1
sum_distances(input, 1)

# part 2
sum_distances(input, 1e6-1)

