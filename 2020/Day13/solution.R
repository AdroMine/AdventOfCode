setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines("input.txt")

target <- as.numeric(input[1])
buses <- unlist(strsplit(input[2], ","))

# Part 1
bus_t <- as.numeric(buses[buses!="x"])
wait_time <- ((target %/% bus_t + 1) * bus_t) - target   # %/% is integer division in R

idx <- which.min(wait_time)
wait_time[idx] * bus_t[idx] # ans1


# for higher precision, wasted too much time because of 
# precision error
library(Rmpfr)
# modInverse using euler prime number 
modInverse <- function(a, m){
  return(numbers::modpower(a%%m, m-2, m))
}

# Part 2
part2 <- function(buses){
    dept <- which(buses!="x") - 1
    buses <- as.double(buses[buses!="x"])
    
    .N <- function(.) mpfr(., precBits = 100) # fails below precBits = 58    
    N <- prod(buses)
    Y <- N/buses
    rem <- -dept %% buses
    inv <- sapply(1:length(buses), function(i) modInverse(Y[i], buses[i]))    
    
    Y <- .N(Y) # increase precision
    sum(Y * rem * inv) %% N
}
part2(buses)


# inv <- rep(NA, length(buses))
# # inverse modulo
# for(i in 1:length(buses)){
#     # n *k %% m equivalent to [(n %% m)*(k%%m)] %% m 
#     m <- Y[i] %% buses[i]
#     k <- 1:(buses[i]-1)
#     remainder <- (m*k) %% buses[i]
#     inv[i] <- which(remainder == 1)
# }


