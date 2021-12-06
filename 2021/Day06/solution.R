setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- as.integer(strsplit(readLines("input.txt", n = 1), ",")[[1]])

# sample
# input <- c(3,4,3,1,2)

fishes <- vector("numeric", 9)
fishes[1:9] <- sapply(1:9, function(x) sum(input == x-1))

for(day in 1:256){
    
    new_fish <- fishes[1]
    for(i in 2:9){
        fishes[i-1] <- fishes[i]
    }
    fishes[7] <- fishes[7] + new_fish
    fishes[9] <- new_fish
    
    if(day %in% c(80, 256))
        print(sum(fishes), digits = 22)
}
