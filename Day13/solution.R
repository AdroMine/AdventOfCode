setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines("input.txt")

target <- as.numeric(input[1])
buses <- unlist(strsplit(input[2], ","))

# Part 1
bus_t <- as.numeric(buses[buses!="x"])
wait_time <- ((target %/% bus_t + 1) * bus_t) - target   # %/% is integer division in R

idx <- which.min(wait_time)
wait_time[idx] * bus_t[idx]


# for higher precision, wasted too much time because of 
# precision error
library(Rmpfr)

# Part 2
part2 <- function(buses){
    dept <- which(buses!="x") - 1
    buses <- as.double(buses[buses!="x"])
    
    .N <- function(.) mpfr(., precBits = 200)    
    N <- .N(prod(buses))
    Y <- N/buses
    rem <- -dept
    inv <- rep(NA, length(buses))
    
    # inverse modulo
    for(i in 1:length(buses)){
        # n *k %% m equivalent to [(n %% m)*(k%%m)] %% m 
        m <- Y[i] %% buses[i]
        k <- 1:(buses[i]-1)
        remainder <- (m*k) %% buses[i]
        inv[i] <- which(remainder == 1)
    }
    sum(Y * rem * inv) %% N
}
part2(buses)


# modInverse using euler extended
# modInverse <- function(a, m){
#   rem <- m
#   y <- 0
#   x <- 1
#   while(a > 1){
#       q <- a %/% rem
#       tmp <- rem
#       rem <- a %% rem
#       a <- tmp
#       tmp <- y
#       y <- x - q*y
#       x <- tmp
#   }
#   if(x < 0)
#       x <- x + m
#   return(x)
# }
# 
# inv <- sapply(1:length(buses), function(i) modInverse(Y[i], buses[i]))    


