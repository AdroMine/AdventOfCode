setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
file_name <- 'input.txt'
cubes <- strsplit(readLines(file_name), '~') |> 
  lapply(strsplit, ',') |> 
  purrr::map_depth(2, as.numeric) |> 
  
  lapply(\(cube_pt){
    start <- cube_pt[[1]]
    end <- cube_pt[[2]]
    list(
      x = seq(start[1], end[1], by = 1), 
      y = seq(start[2], end[2], by = 1), 
      z = seq(start[3], end[3], by = 1)
    )
})
names(cubes) <- paste0('cube_', seq_len(length(cubes)))

depends <- setNames(vector('list', length(cubes)), names(cubes)) # on what cubes does this cube depend on
supports <- setNames(vector('list', length(cubes)), names(cubes)) # what other cubes does this cube support

# order cubes by z index low to high
cube_order <- order(sapply(cubes, \(x) x$z[1]))

# get range of x, y, z
y_range <- lapply(cubes, `[[`, 'y') |> unlist() |> range()
x_range <- lapply(cubes, `[[`, 'x') |> unlist() |> range()
y_size <- y_range[2] - y_range[1] + 1
x_size <- x_range[2] - x_range[1] + 1

# Matrices approach
plane_xy <- matrix('', nrow = y_size, ncol = x_size)
z_max <- lapply(cubes, `[[`, 'z') |> unlist() |> max()
# create planes for z = 1 to z_max, where each plane is a matrix of x-y points
# and will store the names of cubes present in those x-y coordinates
planes <- replicate(n = z_max, expr = plane_xy, simplify = FALSE)

set_plane <- function(all_x, all_y, all_z, cube_name){
  for(z in all_z){
    planes[[z]][all_x, all_y] <<- cube_name
  }
}

check_z <- function(all_x, all_y, z){
  found <- as.vector(planes[[z]][all_x, all_y]) 
  unique(found[found != ''])
}

# run through cubes from bottom to top
for(idx in cube_order){
  # idx <- cube_order[i]
  
  cube <- cubes[[idx]]
  cube_name <- names(cubes)[idx]
  low_z <- cube$z[1]
  x <- cube$x + 1
  y <- cube$y + 1
  z <- cube$z
  
  if(low_z == 1){
    set_plane(x, y, z, cube_name)
  } else {
    
    # make it fall down
    
    # check z below it for emptiness and while empty, keep moving down
    cur_z <- low_z
    while(cur_z > 1){
      below_cubes <- check_z(x, y, cur_z - 1)
      if(length(below_cubes) == 0 && cur_z > 1) {
        cur_z <- cur_z - 1
        z <- z - 1
      } else {
        break
      }
    }
    # fallen down now, set at plane
    set_plane(x, y, z, cube_name)
    
    # if there are cubes directly below any x,y,z, set support 
    if(length(below_cubes) > 0){
      # current cube depends on those below it
      depends[[cube_name]] <- below_cubes
    }
    
    # add supports
    for(cb in below_cubes){
      # the ones below support this cube
      supports[[cb]] <- c(supports[[cb]], cube_name)
    }
  }
}

disintegrated <- setNames(vector('logical', length(cubes)), names(cubes))
for(cb_name in names(cubes)){
  # which cubes does this cube support
  supts <- supports[[cb_name]]
  if(length(supts) == 0){
    # if none, then can be safely disintegrated
    disintegrated[[cb_name]] <- TRUE
  } else {
    # if supports cubes which are also supported by other cubes, then again it can be 
    # broken
    if(all(sapply(depends[supts], length) > 1)){
      disintegrated[[cb_name]] <- TRUE
    }
  }
}

sum(disintegrated)


# part 2

chain_reaction2 <- function(cube_name){
  # boolean vector of all cubes
  broken <- setNames(vector('logical', length(cubes)), names(cubes))
  Q <- collections::queue(list(cube_name))
  while(Q$size() > 0){
    cname <- Q$pop()
    # set this as broken
    broken[cname] <- TRUE
    
    # get the cubes that this cube supports
    deps <- supports[[cname]]
    for(d in deps){
      # for each dependent, if all supports are broken, break it as well
      st <- depends[[d]]
      if(all(broken[st])){
        Q$push(d)
      }  
    }
  }
  broken[cube_name] <- FALSE # we are counting 'other' broken
  sum(broken) 
}

sapply(names(cubes), chain_reaction2) |> sum()
