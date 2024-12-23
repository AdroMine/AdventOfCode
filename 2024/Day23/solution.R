setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- strsplit(readLines(file_name), "-")

graph <- collections::dict()
for(con in input){
  graph$set(con[1], c(graph$get(con[1], NULL), con[2]))
  graph$set(con[2], c(graph$get(con[2], NULL), con[1]))
}

computers <- unlist(graph$keys())
p1 <- 0
seen <- collections::dict()
for(comp in computers[startsWith(computers, 't')]){
  
  adj <- graph$get(comp)
  combs <- combn(adj, 2)
  for(i in 1:ncol(combs)){
    c2 <- combs[,i][1]
    c3 <- combs[,i][2]
    key <- sort(c(comp, c2, c3))
    if(seen$has(key)) next
    seen$set(key, TRUE)
    if(c2 %in% graph$get(c3)){
      p1 <- p1 + 1
    }
  }
}
p1

# Part 2
# start from all - 1, and check 

cliques <- collections::dict()
longest <- c()

for(comp in computers){
  
  Q    <- collections::queue()
  seen <- collections::dict()
  for(ad in graph$get(comp)) Q$push(ad)
  
  cur_cliq <- comp
  
  while(Q$size() > 0){
    
    c2 <- Q$pop()
    if(seen$has(c2)) next
    seen$set(c2, TRUE)
    
    new_pos <- graph$get(c2)
    if(all(cur_cliq %in% new_pos)){
      cur_cliq <- c(cur_cliq, c2)
      for(item in new_pos) Q$push(item)
    }
  }
  cur_cliq <- sort(cur_cliq)
  cliques$set(comp, cur_cliq)
  if(length(cur_cliq) > length(longest)){
    longest <- cur_cliq
  }
}

paste0(longest, collapse = ",")

