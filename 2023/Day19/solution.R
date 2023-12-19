setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
file_name <- 'input.txt'
input <- strsplit(readr::read_file(file_name), '\n\n')[[1]]

instructions <- strsplit(input[1], '\n')[[1]] |> 
  strsplit('\\{') |> 
  lapply(\(instr){
    nm <- instr[1]
    act <- strsplit(gsub("\\}", "", instr[2]), ',')[[1]]
    list(nm = nm, act = act)
  }) 
inst_nms <- sapply(instructions, `[[`, 'nm')
inst_act <- setNames(lapply(instructions, `[[`, 'act'), inst_nms)
parts <- strsplit(input[2], '\n')[[1]] |> 
  gsub("\\{|\\}", "", x = _) |> 
  strsplit(',')


eval_part <- function(k){
  
  inst <- 'in' # start with 'in' instruction
  
  # keep repeating until we reach accept/reject
  while(TRUE){
    
    cur_insts <- inst_act[[inst]]
    
    # go through current instructions
    for(cur_in in cur_insts){
      
      # if has evaluation
      if(grepl(':', cur_in)){
        
        chain <- strsplit(cur_in, ':')[[1]]
        res <- eval(parse(text = chain[1]), envir = k)
        
        # res <- tryCatch({
        #   eval(parse(text = chain[1]), envir = k)
        # }, error = function(e) FALSE)
        
        if(res){
          if(chain[2] == 'A') {
            return(TRUE)
            accept <- TRUE
            break
          } else if(chain[2] == 'R'){
            return(FALSE)
          } else {
            # if false or true but not accept/reject, change instruction and move on
            inst <- chain[2]
            break
          }
        } 
      } else {
        # instruction has no evaluation, only accept/reject/other criteria
        if(cur_in == 'A'){
          return(TRUE)
        } else if (cur_in == 'R'){
          return(FALSE)
        } else {
          inst <- cur_in
          break
        }
      }
    }
  }
}


p1 <- 0
for(i in seq_along(parts)){
  
  pt <- parts[[i]]
  k <- new.env()
  
  # evaluate and create these variables in given environment
  eval(parse(text = pt), envir = k)
  
  if(eval_part(k)){
    p1 <- p1 + sum(unlist(as.list(k)))
  }
}
p1


all_limit <- c(1, 4000)
orig_limits <- list(x = all_limit, 
                    m = all_limit, 
                    a = all_limit, 
                    s = all_limit)

combinations <- function(limit){
  prod(sapply(limit, \(x) x[2] - x[1] + 1))
}

new_limits <- function(limits, op, var, num){
  if(op == '<') {
    limits[[var]][2] <- num - 1
  } else if (op == '>') {
    limits[[var]][1] <- num + 1
  } else if (op == '<=') {
    limits[[var]][2] <- num
  } else if (op == '>=') {
    limits[[var]][1] <- num
  }
  limits
}


# Part 2
count_parts <- function(inst_nm, limits) {
  
  if(inst_nm == 'A') return(combinations(limits))
  if(inst_nm == 'R') return(0)
  
  instr <- inst_act[[inst_nm]]
  # ans <- list()
  ans <- 0
  
  for(cur_ins in instr){
    
    if(grepl(':', cur_ins)) {
      
      chain <- strsplit(cur_ins, ':')[[1]]
      var <- substr(chain[1], 1, 1)
      op <- substr(chain[1], 2, 2)
      num <- as.integer(substr(chain[1], 3, nchar(chain)))
      
      dif_op <- switch(op, '<' = '>=', '>' = '<=')
      
      # if true, then we follow path 1 and get some answer
      # ans <- c(ans , Recall(chain[2], new_limits(limits, op, var, num)))
      ans <- ans + Recall(chain[2], new_limits(limits, op, var, num))
      
      # for false, we follow the subsequent path if any 
      limits <- new_limits(limits, dif_op, var, num)
      
    } else {
      # ans <- c(ans , Recall(cur_ins, limits))
      ans <- ans + Recall(cur_ins, limits)
    }
  }
  ans
}

count_parts('in', orig_limits)

