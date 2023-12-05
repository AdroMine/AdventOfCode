setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- strsplit(readr::read_file(file_name), '\\n\\n')[[1]]

seeds <- strsplit(input[1], ": ")[[1]][2] |> 
  strsplit(" ") |> 
  unlist() |> 
  as.numeric()

seed_maps <- strsplit(input[-1], "\\n") |> 
  lapply(\(x) x[-1]) |> # remove first element (map name)
  lapply(strsplit, ' ') |> # multiple lines of numbers
  purrr::map_depth(2, as.numeric) # convert each to number

# Part 1
p1 <- Inf
for(i in seq_along(seeds)) {
  
  seed <- seeds[[i]]
  
  for(j in seq_along(seed_maps)) {
    
    sm <- seed_maps[[j]]
    
    for(k in seq_along(sm)) {
      
      sm_row <- sm[[k]]
      seed_in_range <- seed >= sm_row[2] && seed <= (sm_row[2] + sm_row[3])
      if(seed_in_range) {
        temp <- seed - sm_row[2]
        seed <- sm_row[1] + temp
        break
      }
    }
    
  }
  p1 <- min(p1, seed)
}
print(p1)



# Part 2
s_idx <- seq(1, length(seeds), by = 2)
r_idx <- seq(2, length(seeds), by = 2)

sds <- seeds[s_idx]
rng <- seeds[r_idx]


# Part 2 Non brute force

p2 <- Inf
for(i in seq_along(sds)){
  
  # create a range of seed locations
  cur_ranges <- list(c(sds[i], sds[i] + rng[i]))
  
  # for each mapping 
  for(j in seq_along(seed_maps)) {

    sm <- seed_maps[[j]]
    
    # ranges that have been mapped to the next seed map
    mapped_ranges <- list()
    
    # go with each row of current seed map
    for(k in seq_along(sm)) {
      
      sm_row <- sm[[k]]
      start <- sm_row[2]
      end <- sm_row[2] + sm_row[3]
      # new ranges that we will have to create (that are not mapped)
      # due to splits
      new_ranges <- list()
      
      # while we still have ranges to go through
      while(length(cur_ranges) > 0) {
        
        # take one object and remove from list
        cr <- cur_ranges[[length(cur_ranges)]]
        cur_ranges[[length(cur_ranges)]] <- NULL
        
        
        # create ranges (before mapping interval, overlapping interval, after mapping interval)
        part1 <- c(cr[1], min(cr[2], start))
        part2 <- c(max(cr[1], start), min(cr[2], end))
        part3 <- c(max(end, cr[1]), cr[2])
        
        # only part 2 will be part of mapping
        
        # if part1 and part3 are valid ranges, add them to next list of ranges to check/map
        if(part1[1] < part1[2]) new_ranges <- c(new_ranges, list(part1))
        if(part3[1] < part3[2]) new_ranges <- c(new_ranges, list(part3))
        
        # this is the only part that will have some mapping, add this to mapped ranges
        if(part2[1] < part2[2]) {
          mapped_part2 <- c(part2[1] - sm_row[2] + sm_row[1], 
                            part2[2] - sm_row[2] + sm_row[1])
          mapped_ranges <- c(mapped_ranges, list(mapped_part2))
        }
        
      }
      # iterate over any new ranges created
      cur_ranges <- new_ranges
    }
    # if any range still left, that goes unmapped, add the mapped ranges to it
    cur_ranges <- c(cur_ranges, mapped_ranges)
  }
  
  # All ranges are now mapped to location and present in cur_ranges
  
  # the first will always be lower, so take the first from each range and min over all
  p2 <- min(p2, min(sapply(cur_ranges, `[[`, 1)))
  
}

p2








# BRUTE FORCE EARLIER SOLUTION  (Takes ~10 minutes)
# Go from back to front (location to seed) and start from 0. break at the earliest found
# number
reverse_map <- function(num){
  
  for(i in rev(seq_along(seed_maps))) {
    
    sm <- seed_maps[[i]]
    
    for(j in seq_along(sm)){
      
      sm_row <- sm[[j]]
      
      if(num >= sm_row[1] && num <= (sm_row[1] + sm_row[3])) {
        difference <- num - sm_row[1]
        num <- sm_row[2] + difference
        break
      } 
    }
  }
  num
}

start <- 0
found <- FALSE

while(TRUE) {
  
  seed <- reverse_map(start)
  
  for(i in seq_along(seeds)){
    
    if(seed >= seeds[i] && seed <= (seeds[i] + ranges[i])){
      
      found <- TRUE
      break
    }
  }
  
  if(found) break
  
  start <- start + 1
  if(start %% 10000 == 0) print(start)
  
}


start # 77435348



