setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- read.table("input.txt", sep = " ")
names(input) <- c("direction", "val")



aim <- 0
hor <- 0
dep <- 0
dep2 <- 0

for(i in 1:nrow(input)){
    
    dir <- input$direction[i]
    val <- input$val[i]
    
    if(dir == "up"){
        dep <- dep - val # part 1 
        aim <- aim - val # part 2
    } else if(dir == "down"){
        dep <- dep + val # part 1 
        aim <- aim + val # part 2
    } else if(dir == "forward"){
        hor <- hor + val # both parts
        dep2 <- dep2 + aim * val # part 2 
    }
}

sprintf("Answer Part %d = %d", c(1,2),  hor * c(dep, dep2))
