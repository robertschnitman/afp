#' Manipulate individual elements in a character vector
#' 
#' @description Apply functions that manipulate character/string vectors. Useful for reordering the characters in each vector element, for example.
#'
#' @usage mapchr(f, x)
#' jumble(x)
#' is.upper(x)
#' is.lower(x)
#' 
#' @param f Function to apply to the character vector `x`.
#' @param x Character vector.
#' 
#' @return Vector.
#' 
#' @details `mapchr()` is a general functional for altering character vectors: apply any function to each of its elements. `jumble(x)` randomly changes the order of the characters in every element. Similar to `map_chr()` from the `purrr` library with the exception that the former only accepts character vectors as the data input. These functions are useful when manipulating the arrangement of the characters is desired. Finally, `is.upper()` and `is.lower()` test whether each element in a string vector is all uppercase or lowercase.
#' 
#' @examples
#' # 1. Manipulating the letter ordering in each vector elemetn.
#' rn_mc <- rownames(mtcars)
#' mapchr(function(x) paste0(x, collapse = '|'), rn_mc)
#' jumble(rn_mc)
#' 
#' # 2. Testing for uppercase or lowercase.
#' chr <- c('TEST', 'test', 'tEsT')
#' is.upper(chr) # TRUE FALSE FALSE
#' is.lower(chr) # FALSE  TRUE FALSE
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{lapply}}

#' @rdname mapchr
split_apply <- function(f, x, apply_type) {
  
  ### GOAL: Split --> Apply Function --> Combine
  ## The "Split-Apply-Combine" strategy by Hadley Wickham.
  # https://www.jstatsoft.org/article/view/v040i01/v40i01.pdf
  
  # 0. Type check.
  stopifnot(class(x) == 'character')
  
  # 1. Split.
  splits <- sapply(x, strsplit, split = NULL)
  
  # 2. Apply & Combine.
  
  if (apply_type == 'lapply') {
    
    apps <- lapply(splits, f)
    
    names(apps) <- NULL # Juxtaposition of original attributes and applied vector is confusing.
    
    output <- sapply(apps, paste0, sep = '', collapse = '')
    
  } else if (apply_type == 'mapply') { # if sub-block above converts boolean vectors to string.
    
    output <- mapply(f, splits)
    
    names(output) <- NULL # Juxtaposition of original attributes and applied vector is confusing.
    
    
  } else {
    
    stop('Invalid apply function: use either lapply or mapply')
    
  }
  
  output
  
  
}


mapchr <- function(f, x) split_apply(f, x, apply_type = 'lapply')

#' @rdname jumble
jumble <- function(x) mapchr(sample, x)
