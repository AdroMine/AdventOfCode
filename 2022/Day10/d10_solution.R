setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readLines('sample.txt')
input <- readLines('input.txt')

req_cycles <- seq.int(20, 220, 40)


print_grid <- function(x){
  x <- apply(x, 1, paste, collapse = "")
  for(j in x) print(j)
}
draw_letter <- function(cycle, x){
  pos <- c(-1, 0, 1) + x
  cycle <- (cycle) %% 40
  if(any(pos %in% cycle)) '█' else ' '
}

counter <- c('noop' = 1, 'addx' = 2)

i      <- x   <- 1
cycle  <- ans <- 0
screen <- matrix(".", nrow = 6, ncol = 40)

for(line in input){
  
  line <- strsplit(line, " ")[[1]]
  inst <- line[1]
  
  for(j in seq_len(counter[inst])){
    
    # draw first (so we don't need to subtract 1 from cycle)
    screen[(cycle) %/% 40 + 1, (cycle) %% 40 + 1] <- draw_letter(cycle, x)
    
    # increase cycle and check if we need to add
    cycle <- cycle + 1
    if(cycle %in% req_cycles){
      ans <- ans + cycle * x
    }
    
  }
  if(inst == 'addx'){
    # increase X
    x <- x + as.integer(line[2])
  }
  
  
}

# Part1
ans
# Part 2 
print_grid(screen)
