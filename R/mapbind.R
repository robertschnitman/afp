mapbind <- function(x, y) {
  
  do.bind(function(i) rbind(x[i, ], y[i, ]), 1:NROW(x))
  
}



mapbind_df <- function(x, y) {
  
  split <- lapply(1:NROW(x), function(i) rbind.data.frame(x[i, ], y[i, ]))
  
  output <- do.call(rbind.data.frame, split)
  
  output
  
}

