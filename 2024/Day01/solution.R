setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- read.table('input.txt')
line1 <- input$V1
line2 <- input$V2
  
line1 <- sort(line1)
line2 <- sort(line2)

# Part 1
sum(abs(line2 - line1))

# Part 2

sum(sapply(line1, \(x) sum(x == line2)) * line1)


