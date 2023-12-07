setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> strsplit(' ')

cards <- sapply(input, `[[`, 1) |> strsplit('')
bids  <- sapply(input, `[[`, 2) |> as.numeric()

card_order <- c('A', 'K', 'Q', 'J', 'T', as.character(9:2))
card_types <- c('five_kind', 'four_kind', 'full_house',
                'three_kind', 'two_pair', 'one_pair', 'high_card')

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
card_type_with_joker <- function(card){
  
  card_uniq <- table(card)
  
  if('J' %in% names(card_uniq) && length(card_uniq) > 1) {
    
    j_idx <- which('J' == names(card_uniq))
    val <- card_uniq['J']
    card_uniq <- card_uniq[-j_idx]
    idx <- which.max(card_uniq)
    card_uniq[idx] <- card_uniq[idx] + val
    
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

all_card_types <- lapply(cards, card_type_with_joker)

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

