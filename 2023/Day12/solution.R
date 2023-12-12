setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> 
  strsplit(' ') |> 
  lapply(\(line) {
    list(input = strsplit(line[1], '')[[1]], 
         num = as.numeric(strsplit(line[2], ',')[[1]]))
  })

cache <- collections::dict()
valid_combs <- function(txt, runs, i, rid, len){
  
  key <- c(i, rid, len)
  if(cache$has(key)) return(cache$get(key, default = NA))
  
  # Ending condition, all letters exhausted
  if(i > length(txt)) {
    # all blocks completed and no more '#' running
    if(rid > length(runs) && len == 0) return(1)
    
    # last character completes the last block
    if(rid == length(runs) && len == runs[[rid]]) return(1)
    
    return(0)
  }
  
  # Iterate through the characters
  possible <- 0
  choices <- if(txt[i] == '?') c('.', '#') else txt[i]
  
  for(choice in choices) {
    
    # if choice is '#' increment current running block
    if (choice == '#') {
      possible <- possible + Recall(txt, runs, i+1, rid, len+1)
    } else {
      # given dot
      
      # end a block if reached enough '#' and next can be '.'
      if (runs[rid] == len && rid <= length(runs)) {
        possible <- possible + Recall(txt, runs, i+1, rid+1, 0)
        
        # no running block and current '.', move onto next char
      } else if (len == 0) {
        possible <- possible + Recall(txt, runs, i+1, rid, 0)
      }
    }
  }
  cache$set(key, possible)
  possible
  
}


for(part1 in c(TRUE, FALSE)){
  
  ans <- 0
  for(i in seq_along(input)){
    # print(i)
    line <- input[[i]]
  # for(line in input){
    
    if(!part1){
      txt <- paste0(line$input, collapse = '')
      txt <- paste(txt, txt, txt, txt, txt, sep = "?")
      line$input <- strsplit(txt, '')[[1]]
      line$num <- c(line$num, line$num, line$num, line$num, line$num)
    }
    cache$clear()
    ans <- ans + valid_combs(line$input, line$num, 1, 1, 0)
  }
  print(as.character(ans))
}
