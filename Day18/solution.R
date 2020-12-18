setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(assertthat)
input <- readLines("input.txt")

# Easy part 1, define infix operators, they all have same precedence and then use eval!!
`%a%` <- function(x,y) x+y
`%s%` <- function(x,y) x-y
`%m%` <- function(x,y) x*y
`%d%` <- function(x,y) x/y

input <- gsub("\\+", "%a%", input)
input <- gsub("\\-", "%s%", input)
input <- gsub("\\*", "%m%", input)
input <- gsub("\\/", "%d%", input)

print(sum(sapply(input, function(expr) eval(parse(text = expr)))), digits = 22)

#-------Part 1 & 2-------------
input <- readLines("input.txt")
input <- gsub(" ", "", input)
input <- strsplit(input, "", Inf)


operate <- function(nums, oper){
    if(       oper == '+') { nums[1] + nums[2]
    } else if(oper == '-') { nums[1] - nums[2]
    } else if(oper == '*') { nums[1] * nums[2]
    } else                   nums[1] / nums[2]
}

evaluate <- function(input, precedence){
    total <- 0
    
    solve(nums, ops, i, j){
        
    }
    
    for(expr in input){
        nums <- rep(NA, length(expr))
        ops <- rep(NA, length(expr))
        inum <- iops <- 0
        
        
        for(ch in expr){
            if(grepl("^\\d+$", ch)){ # is digit
                
                inum <- inum + 1
                nums[inum] <- as.numeric(ch)                # Push
                
            } else if(ch == '('){
                
                iops <- iops + 1
                ops[iops] <- "("                            # Push
                
            } else if(ch == ")"){
                
                while(ops[iops] != "("){
                    cur_num <- nums[c(inum-1, inum)]        # Get two numbers
                    op <- ops[iops]                         # Get operator
                    nums[inum-1] <- operate(cur_num, op)    # Push result to nums
                    
                    # bookkeeping
                    nums[inum] <- NA                        # Pop
                    ops[iops] <- NA                         # Pop
                    inum <- inum - 1                        
                    iops <- iops -1                         
                }
                
                ops[iops] <- NA                             # left bracket
                iops <- iops -1
                
            } else {                                        # operator
                
                assert_that(ch %in% c('+', '-', '/', '*'), 
                            msg = "invalid operator")
                
                while(iops > 0 && precedence[ops[iops]] >= precedence[ch]){
                    cur_num <- nums[c(inum-1, inum)]        # Get two numbers
                    op <- ops[iops]                         # Get operator
                    nums[inum-1] <- operate(cur_num, op)    # Push result to nums
                    
                    # bookkeeping
                    nums[inum] <- NA                        # Pop
                    ops[iops] <- NA                         # Pop
                    inum <- inum - 1                        
                    iops <- iops -1                         
                }
                
                iops <- iops + 1
                ops[iops] <- ch                             # Push
                
            }
        }
        
        while(iops > 0){
            cur_num <- nums[c(inum-1, inum)]        # Get two numbers
            op <- ops[iops]                         # Get operator
            nums[inum-1] <- operate(cur_num, op)    # Push result to nums
            
            # bookkeeping
            nums[inum] <- NA                        # Pop
            ops[iops] <- NA                         # Pop
            inum <- inum - 1                        
            iops <- iops -1                         
        }
        
        assert_that(inum == 1)
        
        total <- total + nums[inum]
    }
    total
}

# part 1
precedence <-        c( 1,   1,   1,   1,   0,   0)
names(precedence) <- c("+", "*", "-", "/", '(', ')')

print(evaluate(input, precedence), 22)

# Part 2
precedence <-        c( 2,   1,   2,   1,   0,   0)
names(precedence) <- c("+", "*", "-", "/", '(', ')')
print(evaluate(input, precedence), 22)
