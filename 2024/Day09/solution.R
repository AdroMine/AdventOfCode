setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'example.txt'
# file_name <- 'example2.txt'
input <- "12345"
input <- "2333133121414131402"
input <- readLines('input.txt')

input <- strsplit(input, "")[[1]]

disk_blocks <- lapply(seq_len(length(input)), \(idx){
  # disk
  char <- input[idx]
  if(idx %% 2 == 1){
    rep(idx %/% 2, as.numeric(char))
  } else {
    # free space
    rep('.', as.numeric(char))
  }
}) |> unlist()

part1_move <- function(disk_blocks){
  # move disks
  left <- Position(\(x) x == '.', x = disk_blocks) 
  right <- Position(\(x) x != '.', x = disk_blocks, right = TRUE) 
  
  while(left < right){
    # left is free space, right is not
    disk_blocks[left] <- disk_blocks[right]
    disk_blocks[right] <- '.'
    
    while(disk_blocks[left] != '.') left <- left + 1
    while(disk_blocks[right] == '.') right <- right - 1
  }
  disk_blocks
}
    

checksum <- function(blocks){
  # blocks <- blocks[blocks != '.']
  sum(as.numeric(blocks) * (seq_len(length(blocks)) - 1), na.rm = TRUE) |> 
    as.character()
}

checksum(part1_move(disk_blocks))

# Part 2

part2_move <- function(disk_blocks){
  # move disks
  # left <- Position(\(x) x == '.', x = disk_blocks) 
  right <- Position(\(x) x != '.', x = disk_blocks, right = TRUE) 
  
  # for each right block check only once from right
  # whether any free block from left can hold it
  while(right > 1){
    print(right)
    # find where current file block starts
    right_start <- right
    while((right_start - 1) > 0 && disk_blocks[right_start-1] == disk_blocks[right]) right_start <- right_start - 1
    if(right_start - 1 < 1) break
    size_block <- right - right_start + 1
    
    # find first available free block from left
    left <- Position(\(x) x == '.', x = disk_blocks) 
    
    # now for each right block, we check against each free space
    while(left < right){
      # find end of contiguous free space
      free_end <- left
      while(disk_blocks[free_end + 1] == '.') free_end <- free_end + 1
      size_free_space <- free_end - left + 1
      
      if(size_block > size_free_space) {
        # check next free block now
        left <- free_end + 1
        while(disk_blocks[left] != '.') left <- left + 1
        next
      } else {
        
        free_end <- left + size_block - 1
        disk_blocks[left:free_end] <- disk_blocks[right_start: right]
        disk_blocks[right_start:right] <- "."
        break
      }
    }
    
    right <- right_start - 1
    while(disk_blocks[right] == '.') right <- right - 1
  }
  disk_blocks
}
    
checksum(part2_move(disk_blocks))


part2_move <- function(input){
  input <- as.numeric(input)
  blocks <- input[seq(1, length(input), by = 2)]
  free_s <- input[seq(2, length(input), by = 2)]
  
  right <- length(blocks)
  # look at one block at a time
  while(right > 1){
    block_size <- blocks[right]
    # first available free space
    first_free <- Position(\(x) x >= block_size, free_s, nomatch = 0)
    if(first_free == 0) {
      right <- right - 1
      next
    } else {
      free_s[first_free] <- free_s[first_free] - block_size
      free_s[right] <- free_s[right] + block_size
      if(right < length(blocks)){
        blocks <- c(
          blocks[1:(first_free)],                # till free space
          blocks[right],                         # the block that moved
          blocks[(first_free + 1): (right - 1)], # everything until the block
          blocks[(right+1):length(blocks)]       # everything after the block
        )
      } else {
        blocks <- c(
          blocks[1:(first_free)],                # till free space
          blocks[right],                         # the block that moved
          blocks[(first_free + 1): (right - 1)] # everything until the block
        )
      }
    }
  }
  
  
  
  
}
