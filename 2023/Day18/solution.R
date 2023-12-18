setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'sample.txt'
file_name <- 'input.txt'
input <- strsplit(readLines(file_name), ' ')

movements <- list(
  'R' = c(0, 1),  'D' = c(1, 0), 
  'L' = c(0, -1), 'U' = c(-1, 0) 
)

# condensed function that doesn't store coordinates below
lava_volume <- function(instructions){
  
  grid <- collections::dict()
  
  rx <- 1
  cy <- 1
  grid$set(c(1, 1), TRUE)
  
  perimeter_points <- 0
  
  for(line in instructions) {
    
    dir <- line[1]
    num <- as.numeric(line[2])
    
    mov <- movements[[dir]]
    
    # set vertices
    rx <- rx + mov[1] * num
    cy <- cy + mov[2] * num
    grid$set(c(rx, cy), TRUE)
    perimeter_points <- perimeter_points + num
  }
  
  coords <- do.call(rbind, grid$keys())
  
  # compute area using shoelace formula
  shifter <- function(x, n = 1) {
    if (n == 0) x else c(tail(x, -n), head(x, n))
  }
  S1 <- sum(coords[,1] * shifter(coords[,2]))
  S2 <- sum(coords[,2] * shifter(coords[,1]))
  area <- 0.5 * abs(S1 - S2)
  
  # Pick's formula for area
  # Area = interiorN + 0.5*perimeterN - 1
  # area + 1 - 0.5*perimN = interiorN
  if(all(c(rx, cy) != c(1,1))) perimeter_points <- perimeter_points + 1
  interior_count <- area + 1 - 0.5 * perimeter_points
  total_vol <- interior_count + perimeter_points
  total_vol
  
}

# Part 1
lava_volume(input)


# Part 2
insts <- lapply(input, \(line){
  hex <- line[3]
  # convert steps
  num <- strtoi(sprintf("0x%s", substr(line[3], 3, 7)))
  mov <- chartr('0123', 'RDLU', substr(line[3], 8, 8))
  c(mov, num)
})

# Part 2
as.character(lava_volume(insts))


# running version where we compute line by line
greens_area <- function(instructions){
  
  area <- perim <- x <- 0
  
  for(line in instructions){
    num <- as.integer(line[2]) 
    mov <- movements[[line[1]]]*num # (y, x) movement
    x <- x + mov[2]
    # area = xdy
    area <- area + x * mov[1]
    perim <- perim + num
  }
  # pick area = interior + perim/2 - 1
  # interior = area - perim/2 + 1
  # reqd area = interior + perim = area - perim/2 + 1 + perim
  # reqd area = interiod + 1 + perim/2
  
  area + perim %/% 2 + 1
  
}

greens_area(input)
greens_area(insts) |> as.character()






# Initially using Flood fill, takes around 5-10 mins for just the first part
mat <- matrix('.', 2000, 2000)

rx <- 1000
cy <- 1000
mat[rx, ry] <- '#'
for(line in input) {
  
  dir <- line[1]
  num <- as.integer(line[2])
  mov <- movements[[dir]]
  for(i in 1:num){
    rx <- rx + mov[1]
    cy <- cy + mov[2]
    mat[rx, cy] <- '#'
  }
}

cds <- which(mat == '#', arr.ind = TRUE)
r_s <- min(cds[,1]) - 1
r_e <- max(cds[,1]) + 1
c_s <- min(cds[,2]) - 1
c_e <- max(cds[,2]) + 1

mat2 <- mat[r_s:r_e, c_s:c_e]

R <- nrow(mat)
C <- nrow(mat)
# initialise Q with 4 corners
Q <- collections::queue(list(c(1,1), c(R, 1), c(1, C), c(R, C)))
while(Q$size() > 0) {
  
  cur <- as.integer(Q$pop())
  if(Q$size() %% 100 == 0) print(Q$size())
  
  # north east south west
  adjacent <- list(c(-1, 0), c(0, 1), c(1, 0), c(0, -1))
  for(dir in adjacent){
    
    dir <- as.integer(dir)
    
    nx <- cur[1] + dir[1]
    ny <- cur[2] + dir[2]
    
    # boundary condition
    if(nx < 1 || ny < 1 || nx > R || ny > C) next
    
    # can't move towards filled point
    if(mat[nx,ny] %in% c('#', 'O')) next
    
    mat[nx, ny] <- 'O'
    Q$push(c(nx, ny))
  }
}

sum(mat != 'O')
