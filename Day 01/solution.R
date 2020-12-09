setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- scan("input.txt")

k1 <- combn(input, 2)
prod(k1[,which(colSums(k1)==2020)])

k2 <- combn(input, 3)
prod(k2[, which(colSums(k2)==2020)])

