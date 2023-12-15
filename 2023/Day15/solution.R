setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
# input <- strsplit('rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7', ',')[[1]]
input <- strsplit(readLines(file_name), ',')[[1]]

hash <- function(word){
  letrs <- strsplit(word, '')[[1]]
  val <- 0
  for(l in letrs){
    asc <- utf8ToInt(l)
    val <- ((val+asc)*17) %% 256
  }
  val
}

sapply(input, hash) |> sum()


# Part 2
boxes <- vector('list', 256)

for(i in seq_along(input)){
  word <- strsplit(input[i], '\\=|\\-')[[1]]
  label <- word[1]
  box_id <- hash(label) + 1
  
  # add
  if(length(word) == 2){
    
    boxes[[box_id]][label] <- as.numeric(word[2])
    
  } else {
    
    # remove label if present
    idx <- which(label == names(boxes[[box_id]]))
    if(length(idx) > 0) {
      boxes[[box_id]] <- boxes[[box_id]][-idx]
    }
  }
}

score <- 0
for(i in seq_along(boxes)){
  score <- score + sum(i*seq_along(boxes[[i]]) * boxes[[i]])
}

score
