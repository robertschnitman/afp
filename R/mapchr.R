#' Apply functions to character vectors
#' 
#' @description Apply functions that manipulate character/string vectors.
#'
#' @usage mapchr(f, x)
#' reverse(x)
#' jumble(x)
#' 
#' @param f Function to apply to the character vector `x`.
#' @param x Character vector.
#' 
#' @return Vector.
#' 
#' @details `mapchr()` is a general functional for altering character vectors: apply any function to each of its elements. The function `reverse()` reverses the order of characters for each element. `jumble(x)` randomly changes the order of the characters in every element. Similar to `map_chr()` from the `purrr` library with the exception that the former only accepts character vectors as the data input. These functions are useful when manipulating the arrangement of the characters is desired.
#' 
#' @examples
#' rn_mc <- rownames(mtcars)
#' mapchr(function(x) paste0(x, collapse = '|'), rn_mc)
#' reverse(rn_mc)
#' jumble(rn_mc)
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{lapply}}, 
#' \code{reverse} from Julia: \url{https://docs.julialang.org/en/v1/base/strings/#Base.reverse-Tuple{Union{SubString{String},%20String}}}

#' @rdname mapchr
mapchr <- function(f, x) {
  
  ### GOAL: Split --> Apply Function --> Combine
  ## The "Split-Apply-Combine" strategy by Hadley Wickham.
  # https://www.jstatsoft.org/article/view/v040i01/v40i01.pdf
  
  # 0. Type check.
  stopifnot(class(x) == 'character')
  
  # 1. Split.
  splits <- sapply(x, strsplit, split = NULL)
  
  # 2. Apply.
  apps <- lapply(splits, f)
  
  names(apps) <- NULL # Juxtaposition of original attributes and applied vector is confusing.
  
  # 3. Combine.
  output <- sapply(apps, paste0, sep = '', collapse = '')
  
  output
  
}

#' @rdname reverse
reverse <- function(x) mapchr(rev, x)

#' @rdname jumble
jumble <- function(x) mapchr(sample, x)
