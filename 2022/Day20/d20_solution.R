setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

input <- read.table('input.txt')[[1]]

sample <- c(1, 2, -3, 3, -2, 0, 4)

# positions <- 1:N

get_n <- function(v, n, st) v[(st + n-1) %% length(v) + 1] 
asc <- as.character

res <- input 
names(res) <- asc(1:length(res))
N <- length(res)

for(i in seq_along(res)){

    cur_pos <- which(asc(i) == names(res))
    move <- res[asc(i)]
    if(move == 0) next
    
    new_pos <- (cur_pos - 1L + move) %% (N-1) + 1
    if(new_pos > cur_pos){
        left <- res[setdiff(seq_len(new_pos), cur_pos)] # from start to new_pos except current
        right <- res[new_pos + seq_len(N - new_pos)]    # from new_pos to end
        
    } else if(new_pos < cur_pos) {
        left <- res[seq_len(new_pos - 1L)] # from start to one less than new pos
        right <- res[setdiff(seq.int(new_pos, N), cur_pos)] # from new pos to end
    }
    res <- c(left, move, right)
}

zero_idx <- which(res == 0)

# Part 1 
sum(get_n(res, c(1000, 2000, 3000), zero_idx))

# Part 2
dec_key <- 811589153
res <- input * (dec_key)
N <- length(res)
names(res) <- asc(1:length(res))
for(loop in 1:10){
    print(loop)
    for(i in asc(1:N)){
        cur_pos <- which(i == names(res))
        move <- res[asc(i)]
        
        new_pos <- (cur_pos - 1L + move) %% (N-1) + 1
        if(new_pos == cur_pos || move == 0) next
        if(new_pos > cur_pos){
            left <- res[setdiff(seq_len(new_pos), cur_pos)] # from start to new_pos except current
            right <- res[new_pos + seq_len(N - new_pos)]    # from new_pos to end
            
        } else if(new_pos < cur_pos) {
            left <- res[seq_len(new_pos - 1L)] # from start to one less than new pos
            right <- res[setdiff(seq.int(new_pos, N), cur_pos)] # from new pos to end
        }
        res <- c(left, move, right)
    }   
}

sum(get_n(res, c(1000, 2000, 3000), which(res == 0)))
