setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
file_name <- "sample.txt"
file_name <- "input.txt"

input <- readLines(file_name)

points <- c(")" = 3, "]" = 57, "}" = 1197, ">" = 25137)
mapping <- c("(" = ")", 
             "{" = "}", 
             "[" = "]", 
             "<" = ">")

points2 <- c("(" = 1,
             "[" = 2,
             "{" = 3,
             "<" = 4)


ans1 <- 0
ans2 <- c()
incomple <- 0
for(line in input){
    
    line <- strsplit(line, "")[[1]]
    stack <- vector("list", length = length(line))
    i <- 0
    
    for(char in line){
        if(char %in% c("(", "[", "{", "<")){
            i <- i + 1
            stack[[i]] <- char
        } else if (char %in% c(")", "]", "}", ">")){
            
            popped <- stack[[i]]
            stack[[i]] <- NULL
            i <- i - 1
            
            if(char != mapping[popped]){
                print("reached here")
                ans1 <- ans1 + points[char]
                next
            }
        }
    }
    if(i > 0){
        total <- 0
        while(i > 0){
            popped <- stack[[i]]
            i <- i - 1
            total <- total*5 + points2[popped]
        }
        ans2 <- c(ans2, total)
    }
}
ans1
sort(ans2)[length(ans2)%/%2 + 1]
