
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')
  

sum_nums <- function(input){
  
  nums <- stringr::str_extract_all(input, '\\d')
  
  sapply(nums, \(x) as.numeric(paste0(x[1],  x[length(x)]))) |> 
    sum()
  
}
sum_nums(input)


# Part 2

numbers <- c('one' = 'o1e', 'two' = 't2o', 'three' = 't3e', 
             'four' = 'f4r', 'five' = 'f5e', 'six' = 's6x', 
             'seven' = 's7n', 'eight' = 'e8t', 'nine' = 'n9e')

ans <- 0

lapply(input, \(x){
  for(i in 1:9){
    x <- gsub(names(numbers[i]), numbers[i], x)
  }
  x
}) |> sum_nums()



# Part 2 alt
p2 <- 0
num_str <- as.character(1:9)
num_words <- c('one', 'two', 'three', 'four', 'five', 
               'six', 'seven', 'eight', 'nine')
for(line in input){
  
  string <- strsplit(line, "")[[1]]
  N <- length(string)
  nums <- c()
  for(i in 1:N){
    
    if (string[i] %in% num_str) {
      nums <- c(nums, string[i])
    } else {
      
      for(j in 1:9){
        
        if(startsWith(substr(line, i, N), 
                      num_words[j])){
          nums <- c(nums, j)
        }
      }
    }
  }
  line_num <- as.numeric(paste0(nums[1], nums[length(nums)]))
  p2 <- p2 + line_num
  
}
p2
