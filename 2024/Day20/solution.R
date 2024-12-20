setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

W <- nchar(readLines(file_name, n = 1))

input <- read.fwf(file_name, widths = rep(1, W), comment.char = "") |> as.matrix()
R <- nrow(input); C <- ncol(input);
distance <- matrix(Inf, R, C)

dirs <- list(
  c(-1, 0),  # top
  c(0 , 1),  # right
  c(1,  0),  # down
  c(0, -1)   # left
)

start <- unname(which(input == "S", arr.ind = TRUE)[1,])
end   <- unname(which(input == "E", arr.ind = TRUE)[1,])

get_distances <- function(grid){
  
  distances <- matrix(Inf, R, C)
  distances[start[1], start[2]] <- 0
  
  Q       <- collections::Queue(list(c(start)))
  visited <- collections::dict()
  
  while(Q$size() > 0){
    pos <- Q$pop()
    
    for(d in dirs){
      nxt <- pos + d
      if(nxt[1] < 1 || nxt[1] > R || 
         nxt[2] < 1 || nxt[2] > C || 
         grid[nxt[1], nxt[2]] == "#") next
      
      if(is.infinite(distances[nxt[1], nxt[2]])){
        
        distances[nxt[1], nxt[2]] <- distances[pos[1], pos[2]] + 1
        Q$push(nxt)
      }
    }
  }
  distances
}

orig_distances <- get_distances(input)

path_points <- which(!is.infinite(orig_distances), arr.ind = TRUE)


# Fast solution
library(dplyr)
df <- data.frame(path_points, dist = orig_distances[path_points]) |> as_tibble()

computed <- dplyr::cross_join(df, df) |> 
  dplyr::mutate(apart = abs(row.x - row.y) + abs(col.x - col.y)) |> 
  dplyr::mutate(saved = dist.y - dist.x - apart) 

# part 1
computed |> 
  dplyr::filter(apart == 2, saved >= 100) |> 
  nrow()

# Part 2
computed |> 
  dplyr::filter(apart <= 20, saved >= 100) |> 
  nrow()





# Slow normal solution
combinations <- combn(nrow(path_points), 2)

p1 <- 0
p2 <- 0


for(i in 1:ncol(combinations)){
  if(i %% 50000 == 0) {
    print(paste0("iteration: ", round(i/ncol(combinations)*100, 2), "%"))
  }
  combs <- combinations[,i]
  pt1 <- path_points[combs[1], ]
  pt2 <- path_points[combs[2], ]
  
  dist <- sum(abs(pt2 - pt1))
  d1 <- orig_distances[pt1[1], pt1[2]]
  d2 <- orig_distances[pt2[1], pt2[2]]
  if(dist == 2 && (abs(d2 - d1) - dist) >= 100){
    p1 <- p1 + 1
  }
  if(dist <= 20 && (abs(d2 - d1) - dist) >= 100){
    p2 <- p2 + 1
  }
}

p1
p2


