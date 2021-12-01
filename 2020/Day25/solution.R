setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readLines("sample.txt")
input <- readLines("input.txt")

card_key <- as.numeric(input[1])
door_key <- as.numeric(input[2])


loop_keys <- vector("numeric", 2e7)
loop_keys[1] <- 7
idx <- 1

find_loop <- function(num){
    if(num %in% loop_keys)
        return(which(loop_keys == num))
    ans <- loop_keys[idx]
    while(ans!=num){
        idx <<- idx + 1
        ans <- (ans * 7) %% 20201227
        loop_keys[idx] <<- ans
    }
    idx
}

encrypt <- function(num, loop){
    ans <- 1
    for(i in 1:loop){
        ans <- (ans * num) %% 20201227
    }
    ans
}


card_loop <- find_loop(card_key)
door_loop <- find_loop(door_key)

enc_key <- encrypt(card_key, door_loop)
enc_key
