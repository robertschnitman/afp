#' Apply common function over multiple objects independent of each other
#' 
#' @description Apply common function over multiple objects independent of each other.
#'
#' @param f A function to apply to the collection(s).
#' @param l List of data objects.
#' @param ... Parameters passed to \code{\link{mapply}}.
#' 
#' @return List.
#' 
#' @details Inspired by \code{broadcast} from Julia. Essentially, \code{telecast} wraps \code{\link{mapply}} (via \code{\link{dot}}) within \code{\link{lapply}}.
#' 
#' \code{\link{Map}}/\code{\link{mapply}} executes functions pairwise when given multiple data objects. \code{telecast} fills the need to apply a common function against data objects exclusive to each other. 
#' 
#' Useful for storing disparate information into a single list.
#' 
#' @examples
#' l <- list(mc = mtcars, aq = airquality, lcs = LifeCycleSavings) # Store to reference easily for the two examples below.
#' 
#' ## 1. Extract means for each variable from 3 datasets.
#' mean.nr <- function(x) mean(x, na.rm = TRUE) # airquality has NA values.
#' output1 <- telecast(mean.nr, l) 
#' output1 # Compare: lapply(l, function(x) mapply(mean.nr, x))
#' 
#' ## 2. Derive distinct iterative reductions along with Reduce().
#' red.div <- function(y) Reduce(`/`, y)
#' output2 <- telecast(red.div, l) 
#' output2 # Compare: lapply(l, function(x) mapply(red.div, x))
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{dot}}, \code{\link{mapply}}, \code{\link{lapply}}, 
#' \code{broadcast} from Julia: \url{https://docs.julialang.org/en/v0.6.1/manual/arrays/#Broadcasting-1}

telecast <- function(f, l, ...) {
  
  # 1. Type-check inputs.
  f <- match.fun(f)
  
  if (!is.list(l)) {l <- as.list(l)}
  
  # 2. The function f must be applied to each of the input lists INDEPENDENTLY.
  output <- lapply(l, function(x) mapply(f, x, ...))
  
  # 3. Output must be a list to keep each list element separate from each other.
  output
  
}
