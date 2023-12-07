setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> strsplit(' ')


# function to generate rank for a card
card_type <- function(card, part2 = FALSE){
  
  card_uniq <- table(card)
  
  if(part2){
    
    if('J' %in% names(card_uniq) && length(card_uniq) > 1) {
      
      j_idx <- which('J' == names(card_uniq))
      val <- card_uniq['J']
      card_uniq <- card_uniq[-j_idx]
      idx <- which.max(card_uniq)
      card_uniq[idx] <- card_uniq[idx] + val
      
    }
  }
  
  # all five same 22222
  if(length(card_uniq) == 1) return(6)
  
  # 2 types of cards
  if(length(card_uniq) == 2) {
    # 4 of a kind
    # 22223
    if (setequal(card_uniq, c(4,1))) {
      return(5)
    } else {
      # full house 23332
      return(4)
    }
  }
  
  # 22345
  if (length(card_uniq) == 3) {
    
    # 33324
    if (setequal(card_uniq, c(3, 1, 1))) {
      return(3)
    } else {
      # 33224
      return(2)
    }
  }
  
  if (length(card_uniq) == 4) return(1)
  
  if(length(card_uniq) == 5) return(0)
  
  stop('Incorrect type')
  
}


# ordered factor levels for each card
card_order <- c('A', 'K', 'Q', 'J', 'T', as.character(9:2))

# Custom class solution

# based on https://stackoverflow.com/a/7516342/15221658

# Create a list of hands, each hand containing hand as a ordered factor, 
# it's bid and card rank. Assign a custom class to this list
hands <- lapply(input, \(x) {
  hand <- strsplit(x[[1]], '')[[1]]
  list(hand = factor(hand, levels = rev(card_order), ordered = TRUE),
       bid = as.numeric(x[[2]]),
       rank = card_type(hand)
  )
})

# assign a  custom class to this list (list not individual objects)
class(hands) <- 'camel_poker'


# Now define 3 functions for this class for extracting element and comparing them

# subset function
`[.camel_poker` <- function(x, i){
  class(x) <- 'list'
  structure(x[i], class = 'camel_poker')
}

# > function
`>.camel_poker` <- function(e1, e2){
  e1 <- e1[[1]]
  e2 <- e2[[1]]
  
  if(e1$rank == e2$rank) {
    return((e1$hand > e2$hand)[e1$hand != e2$hand][1])
  }
  
  return(e1$rank > e2$rank)
}

# == function
`==.camel_poker` <- function(e1, e2){
  
  e1 <- e1[[1]]
  e2 <- e2[[1]]
  (e1$rank == e2$rank) && 
    all(e1$hand == e2$hand)
  
}

# Now sort will work on this custom class object
# and will be much faster
sorted_hands <- sort(hands)

sum(sapply(sorted_hands, `[[`, 'bid') * seq_along(sorted_hands))


# Part 2


# new card order where J is weakest
card_order <- c('A', 'K', 'Q', 'T', as.character(9:2), 'J')

hands2 <- lapply(input, \(x) {
  hand <- strsplit(x[[1]], '')[[1]]
  list(hand = factor(hand, levels = rev(card_order), ordered = TRUE),
       bid = as.numeric(x[[2]]),
       rank = card_type(hand, part2 = TRUE)
  )
       
})

class(hands2) <- 'camel_poker'

sorted_hands2 <- sort(hands2)

sum(sapply(sorted_hands2, `[[`, 'bid') * seq_along(sorted_hands2))






# Old solution with bubble sort
# Normal bubble sort based solution

cards <- sapply(input, `[[`, 1) |> strsplit('')
bids  <- sapply(input, `[[`, 2) |> as.numeric()

# function to give a card its strength
card_type <- function(card){
  
  card_uniq <- table(card)
  
  # all five same 22222
  if(length(card_uniq) == 1) return(6)
  
  # 2 types of cards
  if(length(card_uniq) == 2) {
    # 4 of a kind
    # 22223
    if (setequal(card_uniq, c(4,1))) {
      return(5)
    } else {
      # full house 23332
      return(4)
    }
  }
  
  # 22345
  if (length(card_uniq) == 3) {
    
    # 33324
    if (setequal(card_uniq, c(3, 1, 1))) {
      return(3)
    } else {
      # 33224
      return(2)
    }
  }
  
  if (length(card_uniq) == 4) return(1)
  
  if(length(card_uniq) == 5) return(0)
  
  stop('Incorrect type')
  
}

all_card_types <- lapply(cards, card_type)

factored_cards <- lapply(cards, \(x) factor(x, levels = rev(card_order), ordered = TRUE))


# TRUE if card1 > card2, FALSE otherwise
compare_2_cards <- function(idx1, idx2) {
  
  s1 <- all_card_types[[idx1]]
  s2 <- all_card_types[[idx2]]
  
  if (s1 > s2) return(TRUE)
  if(s1 < s2) return(FALSE)
  
  f1 <- factored_cards[[idx1]]
  f2 <- factored_cards[[idx2]]
  
  if(s1 == s2) return((f1 > f2)[f1 != f2][1]) 
  
  stop('error')
  
}

# sort
# will get order of cards with strengths
new_cards <- seq_along(cards)
N <- length(new_cards)

for(i in 1:(N-1)) {
  swapped <- FALSE
  print(i)
  for (j in 1:(N - i)) {
    
    # if equal compare the digits
    idx1 <- new_cards[j]
    idx2 <- new_cards[j+1]
    if(compare_2_cards(idx1, idx2)) {
      
      new_cards[j] <- idx2
      new_cards[j+1] <- idx1
      swapped <- TRUE
      
    }
    
  }
  if(!swapped) break
}

sum(bids[new_cards] * seq_len(length(bids)))



# Part 2


all_card_types <- lapply(cards, card_type, part2 = TRUE)

card_order <- c('A', 'K', 'Q', 'T', as.character(9:2), 'J')
factored_cards <- lapply(cards, \(x) factor(x, levels = rev(card_order), ordered = TRUE))


# TRUE if card1 > card2, FALSE otherwise
compare_2_cards <- function(idx1, idx2) {
  
  s1 <- all_card_types[[idx1]]
  s2 <- all_card_types[[idx2]]
  
  if (s1 > s2) return(TRUE)
  if(s1 < s2) return(FALSE)
  
  f1 <- factored_cards[[idx1]]
  f2 <- factored_cards[[idx2]]
  
  if(s1 == s2) return((f1 > f2)[f1 != f2][1]) 
  
  stop('error')
  
}

# sort
# will get order of cards with strengths
new_cards <- seq_along(cards)
N <- length(new_cards)

for(i in 1:(N-1)) {
  swapped <- FALSE
  print(i)
  for (j in 1:(N - i)) {
    
    # if equal compare the digits
    idx1 <- new_cards[j]
    idx2 <- new_cards[j+1]
    if(compare_2_cards(idx1, idx2)) {
      
      new_cards[j] <- idx2
      new_cards[j+1] <- idx1
      swapped <- TRUE
      
    }
    
  }
  if(!swapped) break
}

sum(bids[new_cards] * seq_len(length(bids)))




