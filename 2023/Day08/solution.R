setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- strsplit(readr::read_file(file_name), '\n\n')[[1]]

dirs <- strsplit(chartr('LR', '12',input[1]), '')[[1]] |> 
  as.numeric()

maps <- strsplit(input[2], '\n')[[1]] |> stringr::str_extract_all('\\w+')

map <- setNames(lapply(maps, `[`, -1), sapply(maps, `[[`, 1))


cur <- 'AAA'
target <- 'ZZZ'

d <- 1
steps <- 0

while(cur != target) {
  
  nxt_dir <- dirs[[d]]
  cur <- map[[cur]][nxt_dir]
  steps <- steps + 1
  
  d <- (d + 1 - 1) %% length(dirs) + 1
  
}

steps

# Part 2

# Get cycle lengths for each start point to reach a Z, which repeat
# Then get LCM of these cycles to find when they all reach end together

cur_pts <- grep('A$', names(map), value = TRUE)
cycle_lengths <- c()
for(pt in cur_pts){
  steps <- 0
  d <- 1
  while (!grepl('Z$', pt)) {
    nxt_dir <- dirs[[d]]
    pt <- map[[pt]][nxt_dir]
    steps <- steps + 1
    d <- (d + 1 - 1) %% length(dirs) + 1
  }
  
  cycle_lengths[pt] <- steps
  
}


as.character(Reduce(pracma::Lcm, cycle_lengths))
