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
part2_move_opt <- function(input){
  input <- as.numeric(input)
  blocks <- vector('list', length = ceiling(length(input) / 2))
  free   <- vector('list', length = floor(length(input) / 2))
  b <- f <- p <- 1
  file_id <- 0
  
  for(i in seq_along(input)) {
    
    if(i %% 2 == 0){
      free[[f]] <- c(p, input[i])
      f <- f + 1
    } else {
      blocks[[b]] <- c(p, input[i], file_id) 
      file_id <- file_id + 1
      b <- b + 1
    }
    p <- p + input[i]
  }
  
  final <- disk_blocks
  
  for(right in length(blocks):1){
    # if(right %% 1000 == 0) print(right)
    
    cur_block  <- blocks[[right]]
    b_pos      <- cur_block[1]
    block_size <- cur_block[2]
    file_id    <- cur_block[3]
    
    for(sp_idx in 1:length(free)){
      
      space  <- free[[sp_idx]]
      f_pos  <- space[1]
      f_size <- space[2]
      
      if(f_size >= block_size && b_pos > f_pos){
        final[b_pos:(b_pos + block_size - 1)] <- '.'
        final[f_pos:(f_pos + block_size - 1)] <- file_id
        free[[sp_idx]] <- c(f_pos + block_size, f_size - block_size)
        break
      }
    }
  }
  final
}

checksum(part2_move_opt(input))













# old slow solution
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

