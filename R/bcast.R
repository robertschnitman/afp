#' Compact mapply() a la` broadcast() from Julia
#' 
#' @description Inspired by the dot syntax from Julia's \code{broadcast}, execute mapply() with a convenient shortand.
#' 
#' @usage bcast(f, x, ..., simplify = FALSE)
#' .(f, x, ..., simplify = FALSE)
#'
#' @param f Function.
#' @param x First argument to vectorize over.
#' @param ... a list of additional arguments to FUN. See \code{\link{mapply}}.
#' @param simplify Boolean, same as SIMPLIFY in \code{\link{mapply}}.
#' 
#' @return List (if simplify = FALSE) or array (if simplify = TRUE).
#' 
#' @examples
#' set.seed(1)
#' a <- matrix(1:9, 3, 3)
#' b <- 20:22
#' c <- matrix(rnorm(9), 3,)
#' bcast(`/`, a, b, simplify = TRUE) # matrix.
#' bcast(`/`, a, b, c, simplify = TRUE) # If a warning occurs, output may be list.
#' 
#' # Alternate syntax
#' .(`/`, a, b, simplify = TRUE) # matrix.
#' .(`/`, a, b, c, simplify = TRUE) # If a warning occurs, output may be list.
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{mapply}},  
#' \code{broadcast} from Julia: \url{https://docs.julialang.org/en/v0.6.1/manual/arrays/#Broadcasting-1}

#' @name bcast

bcast <- function(f, x, ..., simplify = FALSE) {
  
  dots <- list(...)
  
  output <- mapply(f, x, y = dots, SIMPLIFY = simplify)
  
  output
  
}

. <- bcast # Simplified