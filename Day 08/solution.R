setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(glue)
library(dplyr)

input <- read.table("input.txt")
names(input) <- c("instruction", "offset")

run_prog <- function(input, verbose = TRUE){
    input$exec <- 0 # to count no of executions
    input$step <- 0
    input$id <- 1:nrow(input)
    no_inst <- nrow(input)
    
    acc <- 0
    i <- 1
    step <- 0
    
    while(i<=no_inst){
        if(input[i, 3]){ #if > 0, break
            if(verbose){
                message(
                    glue("Program executes line {i} second time",
                         "\nAccumulator value is: {acc}",
                         "\nStep: {step}")
                )
            }
            break
        }
        
        # First run
        ins <- input[i, 1] 
        input[i, 3] <- 1  # Set inst executed 
        step <- step + 1  # keep count of step
        input[i, 4] <- step # store order execution (debugging)
        
        
        if(ins == "nop"){
            i <- i + 1
            next()
        } else if(ins == "jmp"){
            i <- i + input[i, 2]
            next()
        } else{
            acc <- acc + input[i, 2]
            input[i, 3] <- 1
            i <- i + 1
        }
    }
    list(input = input, acc = acc, step = step, success = i>no_inst)
}

# Answer 1
res = run_prog(input)
res$acc

# Answer 2

# last intruction to run
last_trial <- res$input %>% filter(step != 0) %>% arrange(-step)

id_to_change <- filter(last_trial, instruction != "acc") %>% pull(id)

# try chaning nop to jmp
for(id in id_to_change){
    input2 <- input
    
    input2[id, 1] <- switch(input2[id, 1], 
                           jmp = "nop", 
                           nop = "jmp")
    
    res = run_prog(input2, verbose = FALSE)
    if(res$success){
        message(
            glue("Program succeeds by switching instruction in",
                 " line #:{id} ({input[id, 1]} --> {input2[id, 1]})", 
                 "\nAccumulator value: {res$acc}")
        )
        break
    }
}
res$acc
