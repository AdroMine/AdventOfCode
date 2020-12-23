input <- as.integer(c(3, 8, 9, 1, 2, 5, 4, 6, 7))

input <- as.integer(strsplit("562893147", "")[[1]])

input <- c(input, setdiff(1:1000000L, input))

nxt <- c(input[-1], input[1])
n <- length(input)

nxt <- as.character(nxt)
names(nxt) <- input
nxt <- as.environment(as.list(nxt))


print_list <- function(x, from = '1'){
    output <- rep(NA, length(x))
    output[1] <- as.integer(from)
    for(i in 2:length(x)){
        output[i] <- get(as.character(output[i-1]), envir = x)
    }
    output
}

cur <- as.character(input[1])
rm(input)
for(i in 1:1e7){
    if(i %% 10000 == 0L)
        print(i)
    
    # Pick out next three
    pick <- rep(NA,3)
    pick[1] <- get(cur, envir = nxt)
    pick[2] <- get(pick[1], envir = nxt)
    pick[3] <- get(pick[2], envir = nxt)
    
    # pick <- pick3(nxt, cur)
    
    target <- (as.integer(cur) - 1L) %% n 
    target <- ifelse(target == 0L, n, target)
    while( target %in% pick ){
        target <- (target - 1L) %% n
        if(target == 0L)
            target <- n
    }
    target <- as.character(target)
    
    tmp <- get(pick[3L], envir = nxt)
    assign(cur, value = tmp, envir = nxt)
    assign(pick[3L], envir = nxt, value = get(target, envir = nxt))
    assign(target, value = pick[1L], envir = nxt)
    
    cur <- tmp
    
}

paste(print_list(nxt, '1')[-1], collapse = "")

val1 <- get('1', envir = nxt)
val2 <- get(val1, envir = nxt)

print(prod(as.integer(c(val1, val2))), 22)
