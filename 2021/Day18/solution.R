setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(stringr)
library(collections)

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
input <- readLines(file_name)
N <- length(input)

explode <- function(num){
    
    change <- FALSE
    s <- collections::stack()
    depth <- 0
    i <- 1
    while(i < length(num)){
        ch <- num[i]
        i <-  i + 1
        if(ch == '['){
            depth <- depth + 1
        } else if(grepl("^\\d+$", ch)){ # is number
            ch <- as.numeric(ch)
        } else if(ch == ']'){
            depth <- depth - 1
            if(depth >= 4){
                
                change <- TRUE
                right <- s$pop()
                s$pop()
                left <- s$pop()
                s$pop() # left bracket
                
                pos_right <- Position(function(x) grepl("^\\d+$", x), num[i:length(num)], nomatch = FALSE)
                if(pos_right){
                    pos <- i + pos_right - 1
                    num[pos] <- as.numeric(num[pos]) + right
                }
                
                pos_left <- Position(is.numeric, s$as_list(), nomatch = FALSE)
                if(pos_left){ # need to add to left number
                    
                    s2 <- stack()
                    for(j in 1:pos_left){
                        s2$push(s$pop())
                    }
                    s$push(s2$pop() + left) # push the number after adding left num to it
                    
                    # push all the other chars back to the orig stack
                    while(s2$size() > 0){
                        s$push(s2$pop())
                    }
                }
                s$push(0) # push 0 in place of explode
                break
            }
        }
        s$push(ch)
    }
    
    num <- c(rev(unlist(s$as_list())) , if(i > length(num)) NULL else num[i:length(num)])
    return(list(change = change, 
                num = num))
        
}

split <- function(num){
    
    change <- FALSE
    s <- collections::stack()
    depth <- 0
    i <- 1
    while(i < length(num)){
        ch <- num[i]
        i <-  i + 1
        if(ch == '['){
            depth <- depth + 1
        } else if(grepl("^\\d+$", ch)){ # is number
            ch <- as.numeric(ch)
            # split if > 9
            if(ch > 9){ 
                change <- TRUE
                
                left <- floor(ch / 2)
                right <- ceiling(ch / 2)
                s$push('[')$push(left)$push(',')$push(right)$push(']')
                break
            }
        } 
        s$push(ch)
    }
    
    num <- c(rev(unlist(s$as_list())) , if(i > length(num)) NULL else num[i:length(num)])
    
    return(list(change = change, 
                num = num))
}

reduce_number <- function(num){
    
    num <- strsplit(num, "")[[1]]
    while(TRUE){
        
        res <- explode(num)
        if(res$change){
            num <- res$num
            next
        }
        
        res <- split(num)
        if(res$change){
            num <- res$num
            next
        }
        
        break
    }
    paste0(num, collapse = "")
}


# Solution
res <- input[1]

for(i in 2:N){
    res <- sprintf("[%s,%s]", res, input[i])
    res <- reduce_number(res)
}

magnitude <- function(num){
    
    num <- strsplit(num, "")[[1]]
    i <- 1
    s <- collections::stack()
    while(i <= length(num)){
        ch <- num[i]
        i <- i + 1
        
        if(ch == ']'){
            
            right <- as.numeric(s$pop())
            s$pop()
            left <- as.numeric(s$pop())
            s$pop()
            mg <- 3*left + 2*right
            s$push(mg)
            
        } else {
            s$push(ch)
        }
        
    }
    s$pop()
}

magnitude <- function(num){
    
}


magnitude(res)



# Part 2 

all_combos <- expand.grid(x = 1:N, 
                          y = 1:N) %>% 
    dplyr::filter(x != y)

best <- 0

for(i in 1:nrow(all_combos)){
    
    print(i)
    x <- all_combos$x[i]
    y <- all_combos$y[i]
    
    combo1 <- input[x]
    combo2 <- input[y]
    res <- sprintf("[%s,%s]", combo1, combo2)
    res <- reduce_number(res)
    mg <- magnitude(res)
    if(mg > best){
        best <- mg
    }
}
best
