setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
# file_name <- 'sample2.txt'
file_name <- 'input.txt'
input <- strsplit(readLines(file_name), ' -> ')

mod_nms <- sapply(input, \(line) gsub('%|&', '', line[1]))
mod_typs <- sapply(input, \(line) {
  first_char <- substr(line[1], 1, 1)
  switch(first_char, 
         '&' = 'and', 
         '%' = 'flip', 
         'b' = 'broadcaster') 
})

destinations <- lapply(input, \(line) strsplit(line[2], ', ')[[1]])

modules <- lapply(seq_along(destinations), \(i){
  list(dest = destinations[[i]], 
       type = mod_typs[i], 
       name = mod_nms[i],
       state = if(mod_typs[i] == 'flip') FALSE else logical())
}) |> setNames(mod_nms)

and_modules <- mod_nms[which(mod_typs == 'and')]

for(m in seq_along(modules)){
  mod <- modules[[m]]
  idx <- which(and_modules %in% mod$dest)
  if(length(idx) > 0){
    for(i in idx){
      mod_nm <- and_modules[i]
      modules[[mod_nm]]$state <- c(modules[[mod_nm]]$state, setNames(FALSE, names(modules)[m]))
    }
    
  }
}

pulse_propagation <- function(modules, loops = 4096){
  
  # which is the parent of 'rx'
  rx_parent <- Filter(\(x) all(x$dest =='rx'), modules)[[1]]
  
  # assuming this is a conjunction gate, get counters for its states
  rx_parent$counters <- setNames(vector('list', length(rx_parent$state)),
                                 names(rx_parent$state))
  
  pulse_count <- c(0, 0)
  
  for(loop in 1:loops){
    # Queue instructions
    Q <- collections::queue()
    
    # initial broadcaster sends low pulse to all
    Q$push(list(mod = 'broadcaster', pulse = FALSE, from = 'button'))
    
    # while instructions are left to propagate
    while(Q$size() > 0) {
      
      cur_item <- Q$pop()
      mod <- modules[[cur_item$mod]]
      pulse <- cur_item$pulse
      from <- cur_item[[3]]
      if(loop <= 1000){
        pulse_count[pulse + 1] <- pulse_count[pulse + 1] + 1
      }
      
      # 'rx' mod, skip do nothing
      if(is.null(mod)) next
      
      if(mod$type == 'broadcaster'){
        
        new_signal <- pulse
        
      } else if (mod$type == 'flip') {
        
        # if high pulse, ignore and move on
        if(pulse) next
        
        # low pulse invert signal
        modules[[mod$name]]$state <- !modules[[mod$name]]$state
        
        # send current state 
        new_signal <- modules[[mod$name]]$state
        
      } else if (mod$type == 'and') {
        
        modules[[mod$name]]$state[from] <- pulse
        new_signal <- !all(modules[[mod$name]]$state)
        
        if(mod$name == rx_parent$name){
          if(pulse) { # if turned on
            rx_parent$counters[[from]] <- c(rx_parent$counters[[from]], loop)
          }
        }
      }
      for(d in mod$dest){
        Q$push(list(mod = d, pulse = new_signal, from = mod$name))
      }
    }
  }
  
  list(
    part1 = prod(pulse_count), 
    part2 = Reduce(pracma::Lcm, unlist(rx_parent$counters))
  )
}

pulse_propagation(modules)

