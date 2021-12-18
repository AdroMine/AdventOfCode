setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(stringr)
library(collections)

# Read and Transform input ------------------------------------------------
file_name <- "sample4.txt"
input <- readLines(file_name)
N <- length(input)

reduce_number <- function(num){
    
    num <- strsplit(num, "")[[1]]
    add_right <- 0
    right_pos <- 1e7
    while(TRUE){
        
        change <- FALSE
        s <- collections::stack()
        depth <- 0
        
        i <- 1
        while(i <= length(num)){
            
            ch <- num[i]
            i <- i + 1
            
            if(ch == '['){
                depth <- depth + 1
                
            } else if(grepl("^\\d+$", ch)){ # is number
                # browser()
                
                ch <- as.numeric(ch) + if(i > right_pos) add_right else 0 
                add_right <- if(i > right_pos) 0 else add_right
                right_pos <- if(i > right_pos) 1e7 else right_pos
                
                # split if > 9
                if(ch > 9){ 
                    change <- TRUE
                    
                    left <- floor(ch / 2)
                    right <- ceiling(ch / 2)
                    s$push('[')$push(left)$push(',')$push(right)$push(']')
                    next
                }
                
            } else if(ch == ']'){
                depth <- depth - 1
                
                if(depth >= 4){
                    
                    change <- TRUE
                    
                    add_right <- s$pop()
                    right_pos <- i - 4 # [x,y] will be reduced to 0
                    s$pop() # comma
                    left <- s$pop()
                    s$pop() # left bracket
                    
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
                    # browser()
                    break
                    
                }
            }
            s$push(ch)
        }
        
        
        num <- c(rev(unlist(s$as_list())) , if(i > length(num)) NULL else num[i:length(num)])
        # print(paste0(num, collapse = ""))
        
        if(!change)
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
