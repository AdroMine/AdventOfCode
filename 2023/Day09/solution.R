setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> strsplit(' ') |> lapply(as.numeric)


p1 <- 0
p2 <- 0

for(line in input){
  
  N <- length(line)
  differences <- vector('list', length = N + 1)
  
  differences[[1]] <- line
  
  for(j in 2:length(line)){
    
    differences[[j]] <- diff(differences[[j-1]])
    if(all(differences[[j]] == 0)) break
    
  }
  num1 <- 0
  num2 <- 0
  j <- j-1
  while(j > 0){
    num1 <- differences[[j]][N - j + 1] + num1
    num2 <- differences[[j]][1] - num2
    j <- j - 1
  }
  
  p1 <- p1 + num1
  p2 <- p2 + num2
  
}

p1
p2


# Second method, vectorised

sapply(input, \(line){
  
  part1 <- line[length(line)]
  part2 <- line[1]
  temp <- line
  while(any(temp != 0)){
    temp <- diff(temp)
    part1 <- c(part1, temp[length(temp)])
    part2 <- c(part2, temp[1])
  }
  part1 <- vapply(part1, tail, FUN.VALUE = 1, 1) |> sum()
  part2 <- vapply(part2, head, FUN.VALUE = 1, 1) |> Reduce(`-`, x = _, right = TRUE)
  
  c(part1, part2)
  
}) |> 
  # because of sapply we get matrix of 2 rows where all part1 are in first row and part2
  # in 2nd row
  rowSums()

