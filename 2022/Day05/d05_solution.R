setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# read stacks
stacks <- read.fwf('input.txt', widths = rep(4, 9), n = 8) 
stacks[,] <- lapply(stacks, trimws) # remove leading/trailing  whitespaces
  
stacks[,] <- lapply(stacks, function(x) gsub("\\]|\\[", "", x)) # remove braces
stacks <- as.list(stacks) # convert to list from data.frame
stacks <- lapply(stacks, function(x) Filter(function(y) y!="", x)) # remove empty positions
stacks2 <- stacks # create a copy for part 2 


# read instructions as a table
inst <- read.table('input.txt', skip = 10)[, c(2, 4, 6)]
names(inst) <- c('move', 'from', 'target') # update names

for(i in 1:nrow(inst)){
  
  move <- inst$move[i]
  from <- inst$from[i]
  target <- inst$target[i]
  
  # move one by one
  for(j in seq_len(move)){
    stacks[[target]] <- c(stacks[[from]][1], stacks[[target]])
    stacks[[from]] <- stacks[[from]][-1]
  }
  
}
# Part 1
paste(sapply(stacks, `[`, 1), collapse = "")


# Part 2
for(i in 1:nrow(inst)){
  
  move <- inst$move[i]
  from <- inst$from[i]
  target <- inst$target[i]
  
  # move all together
  stacks2[[target]] <- c(stacks2[[from]][seq_len(move)], stacks2[[target]])
  stacks2[[from]] <- stacks2[[from]][-c(seq_len(move))]
  
}

paste(sapply(stacks2, `[`, 1), collapse = "")
