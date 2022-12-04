setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- read.table('input.txt', sep = ',')

count <- 0
overlap <- 0
for(i in seq_len(nrow(input))){
  
  p1 <- as.integer(strsplit(input[i, 1], '-')[[1]])
  p2 <- as.integer(strsplit(input[i, 2], '-')[[1]])
  
  p1 <- seq.int(p1[1], p1[2])
  p2 <- seq.int(p2[1], p2[2])
  
  if(length(setdiff(p1, p2)) == 0 || length(setdiff(p2, p1)) == 0) 
    count <- count + 1
  
  if(length(intersect(p1, p2)) > 0) overlap <- overlap + 1
  
}

# Part 1 
count

# Part 2
overlap




# What if ranges were very big?
# Creating those ranges would be memory intensive

count <- 0
overlap <- 0


is_subset <- function(p1, p2){
  
  (p2[1] >= p1[1] && p2[2] <= p1[2]) ||  # p2 subset of p1
   (p1[1] >= p2[1] && p1[2] <= p2[2]) # p1 subset of p2
  
}

overlaps <- function(p1, p2){
  
  dplyr::between(p1[1], p2[1], p2[2]) || 
    dplyr::between(p2[1], p1[1], p1[2])
    
}

for(i in 1:nrow(input)){
  
  p1 <- as.integer(strsplit(input[i, 1], '-')[[1]])
  p2 <- as.integer(strsplit(input[i, 2], '-')[[1]])
  
  if(is_subset(p1, p2)){
    count <- count + 1
    overlap <- overlap + 1
  }  else if(overlaps(p1, p2)){
    overlap <- overlap + 1
  } 
  
}

count
overlap
