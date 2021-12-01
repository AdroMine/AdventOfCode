setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(assertthat)
options(digits = 22)

#-------Part 1 & 2 using infix evaluation-------------
input <- readLines("input.txt")
input <- gsub(" ", "", input)
input <- strsplit(input, "", Inf)


evaluate <- function(input, precedence){
    total <- 0
    
    operate <- function(nums, oper){
        if(       oper == '+') { nums[1] + nums[2]
        } else if(oper == '-') { nums[1] - nums[2]
        } else if(oper == '*') { nums[1] * nums[2]
        } else                   nums[1] / nums[2]
    }
    
    # en is environment (values thus pass by reference)
    solve <- function(en){
        cur_num <- en$nums[c(en$inum-1, en$inum)]        # Get two numbers
        op <- en$ops[en$iops]                            # Get operator
        en$nums[en$inum-1] <- operate(cur_num, op)       # Push result to nums
        
        # bookkeeping
        en$nums[en$inum] <- NA                           # Pop
        en$ops[en$iops] <- NA                            # Pop
        en$inum <- en$inum - 1                        
        en$iops <- en$iops -1        
    }
    
    for(expr in input){
        
        # Use environment for easy pass by reference (Explore reference class in future?)
        en <- new.env()
        
        en$nums <- rep(NA, length(expr))                 # stack for operands
        en$ops <- rep(NA, length(expr))                  # stack for operators
        en$inum <- en$iops <- 0
        
        en$push_num <- function(ch){                     # Push number
            en$inum <- en$inum + 1
            en$nums[en$inum] <- as.numeric(ch)           
        }
        
        en$push_op <- function(ch){                      # Push operand
            en$iops <- en$iops + 1
            en$ops[en$iops] <- ch
        }
        
        
        for(ch in expr){
            if(grepl("^\\d+$", ch)){ # is digit
                
                en$push_num(ch)
                
            } else if(ch == '('){
                
                en$push_op('(')
                
            } else if(ch == ")"){
                
                while(en$ops[en$iops] != "(")
                    solve(en)
                
                en$ops[en$iops] <- NA                             # pop left bracket
                en$iops <- en$iops -1
                
            } else {                                              # operator
                
                assert_that(ch %in% c('+', '-', '/', '*'))
                
                while(en$iops > 0 && precedence[en$ops[en$iops]] >= precedence[ch])
                    solve(en)                    
                
                en$push_op(ch)
            }
        }
        
        while(en$iops > 0)
            solve(en)
        
        assert_that(en$inum == 1)
        
        total <- total + en$nums[en$inum]
    }
    total
}

# part 1
precedence        <- c( 1,   1,   1,   1,   0,   0)
names(precedence) <- c("+", "*", "-", "/", '(', ')')

evaluate(input, precedence)

# Part 2
precedence        <- c( 2,   1,   2,   1,   0,   0)
names(precedence) <- c("+", "*", "-", "/", '(', ')')

evaluate(input, precedence)


# Alternative part 1

input <- readLines("input.txt")

# Easy part 1, define infix operators, they all have same precedence and then use eval!!
`%a%` <- function(x,y) x+y
`%s%` <- function(x,y) x-y
`%m%` <- function(x,y) x*y
`%d%` <- function(x,y) x/y

input2 <- input
input <- gsub("\\+", "%a%", input)
input <- gsub("\\-", "%s%", input)
input <- gsub("\\*", "%m%", input)
input <- gsub("\\/", "%d%", input)

sum(sapply(input, function(expr) eval(parse(text = expr))))

# Part 2 based on solution from /u/Standard-Affect (https://www.reddit.com/r/adventofcode/comments/kfeldk/2020_day_18_solutions/gg98owl)
# only works though because problem does not have minus or divide operators

# redefine `/` and `-` to add and multiply resp (refresh session after this!!). This will 
# retain `/`'s higher precedence than `-`

`/` <- function(x,y) x+y    
`-` <- function(x,y) x*y
input2 <- gsub("\\+", "/", input2)
input2 <- gsub("\\*", "\\-", input2)

sum(sapply(input2, function(expr) eval(parse(text = expr))))

