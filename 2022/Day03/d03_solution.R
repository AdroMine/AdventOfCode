setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')

priorities <- 0

list_items <- setNames(1:52, c(letters, LETTERS))

for(item in input){
  
  div <- nchar(item) / 2
  it <- strsplit(item, '')[[1]]
  p1 <- it[1:div]
  p2 <- it[-(1:div)]
  common <- intersect(p1, p2)
  
  priorities <- priorities + list_items[common]
  
}

priorities

priorities_p2 <- 0

# Part 2
for(i in seq.int(1, length(input), by = 3)){
  
  items <- input[i:(i + 2)]
  common <- Reduce(intersect, strsplit(items, ''))
  priorities_p2 <- priorities_p2 + list_items[common]
  
}

priorities_p2
