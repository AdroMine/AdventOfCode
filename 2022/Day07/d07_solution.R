setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readLines('sample.txt')
input <- readLines('input.txt')

# define a node (with items child / parent / size)
node <- function(child = list(), parent = NA, size = 0){
  
  list(
    child  = child, 
    parent = parent,
    size   = size
  )
  
}

i <- 1
cur <- ""
file_system <- list()
while(i <= length(input)){
  
  line <- input[i]
  
  # command
  if(startsWith(line, '$ cd')){
    
    # Go UP
    if(line == '$ cd ..'){
      cur <- file_system[[cur]]$parent
      stopifnot(!is.na(cur))
      i <- i + 1
      
    } else if(line == '$ cd /'){
      # start
      file_system[['/']] <- node()
      i <- i + 1
      cur <- "/"
    } else {
      # go down, create new node
      dir_name <- gsub("\\$ cd ", "", line)
      cur <- file.path(cur, dir_name)
      i <- i + 1
      
      # # does folder exist
      # if(dir_name %in% names(file_system[[cur]]$child)){
      #   # yes, modify existing folder
      #   
      # } else {
      #   # no, create new folder
      #   file_system[[dir_name]] <- node(parent = cur)
      # }
      # cur <- dir_name
      # move to next line
      
    }
    
  } else if(line == '$ ls'){
    i <- i + 1 # move to next line
    line <- input[i]
    
    # keep reading until we reach next command
    while(i <= length(input) && !startsWith(line, '$')){
      # read file structure
      if(startsWith(line, 'dir ')){
        # directories, create new node
        
        dir_name <- file.path(cur, gsub("dir ", "", line))
        file_system[[dir_name]] <- node(parent = cur)
        
      } else {
        
        # files, 
        
        temp <- strsplit(line, " ")[[1]] # get size name
        size <- as.integer(temp[1])
        file_name <- temp[2]
        file_system[[cur]]$child[[file_name]] <- node(parent = cur,
                                                      size   = size)
      }
      
      i <- i + 1
      line <- input[i]
    }
  }
}

size_node <- function(node){
  size <- node$size
  for(child in node$child){
    size <- size + size_node(child)
  }
  size
}

# find sizes of each directory
for(dir in names(file_system)){
  
  node_size <- size_node(file_system[[dir]])
  file_system[[dir]]$size <- node_size
  
  parent <- file_system[[dir]]$parent
  while(!is.na(parent)){
    file_system[[parent]]$size <- file_system[[parent]]$size + node_size
    parent <- file_system[[parent]]$parent
  }
}


# Part 1
# directories with sum <= 100,000
all_dir_size <- sapply(file_system, function(x) x$size)
idx <- which(all_dir_size <= 100000)
sum(sapply(file_system[idx], function(x) x$size))


# Part 2
# disk space 7e7
# need space 3e7
available_space <- 7e7 - file_system[['/']]$size
delete_required <- 3e7 - available_space
unname(sort(all_dir_size[all_dir_size >= delete_required])[1])





# Solution 2 --------------------------------------------------------------

directories <- numeric()
path <- c()

for(line in input){
  
  temp <- strsplit(line, " ")[[1]]
  
  if(temp[2] == 'cd'){
    if(temp[3] == '..'){
      path <- head(path, -1)
    } else {
      path <- c(path, temp[3])
    }
  } else if(temp[2] == 'ls'){
    next 
  } else if(temp[1] == 'dir'){
    next 
  } else {
    # files
    size <- as.integer(temp[1])
    for(i in seq_along(path)){
      dir_name <- paste(path[1:i], collapse = '/')
      if(!dir_name %in% names(directories)){
        directories[dir_name] <- 0
      }
      directories[dir_name] <- directories[dir_name] + size
    }
  }
}

# Part 1
sum(directories[directories <= 1e5])

# Part 2
used <- 7e7 - directories['/']
to_free <- 3e7 - as.integer(used)
min(directories[directories >= to_free])
