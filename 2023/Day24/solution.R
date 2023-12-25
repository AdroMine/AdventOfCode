setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
file_name <- 'input.txt'
input <- strsplit(readLines(file_name), ' @ |, ') |> 
  lapply(as.numeric)

line_pairs <- combn(length(input), 2, simplify = FALSE)

between <- function(x, e1, e2) x >= e1 & x <= e2

determine_intersection <- function(pt1, pt2){
  x1 <- pt1[1]; y1 <- pt1[2]; z1 <- pt1[3];
  vx1 <- pt1[4]; vy1 <- pt1[5]; vz1 <- pt1[6];
  
  x2 <- pt2[1]; y2 <- pt2[2]; z2 <- pt2[3];
  vx2 <- pt2[4]; vy2 <- pt2[5]; vz2 <- pt2[6];
  
  # slope = deltaY / deltaX
  slope1 <- vy1 / vx1
  slope2 <- vy2 / vx2
  
  if(isTRUE(all.equal(slope1, slope2, tolerance = 1e-8))) {
    return(0)
  }
  
  c1 <- y1 - slope1*x1
  c2 <- y2 - slope2*x2
  
  ix <- (c2 - c1) / (slope1 - slope2)
  iy <- slope1*ix + c1
  
  forward1 <- ((ix - x1) / vx1) > 0
  forward2 <- ((ix - x2) / vx2) > 0
  
  if(forward1 & forward2){
    return(c(ix, iy))
  } else return(0)
  
}

intersection_points <- lapply(line_pairs, \(pair){
  line1 <- input[[pair[1]]]
  line2 <- input[[pair[2]]]
  determine_intersection(line1, line2)
})


intersection_points |> 
  Filter(\(x) length(x) == 2, x = _) |> 
  Filter(\(x) all(between(x, 2e14, 4e14)), x = _) |> 
  length()


# Part 2

# in python using scipy
