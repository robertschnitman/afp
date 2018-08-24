#' Tidy aggregate output
#' 
#' @description Maintain a tidy data frame when aggregating results.
#'
#' @param ... Parameters passed to \code{\link{aggregate}}.
#' 
#' @return Data frame.
#' 
#' @details When calling multiple functions in a vector, \code{\link{aggregate}} nests the output into the dependent variable(s). To maintain a tidy data frame, \code{agg} replicates the procedure of \code{\link{aggregate}} and unnests the result.
#' 
#' @examples
#' # Compare
#' ms   <- function(x) c(m = mean(x), s = sd(x))
#' form <- formula(cbind(mpg, disp) ~ am + gear)
#' 
#' A <- aggregate(form, mtcars, ms) # str(A) # Nested mean & sd in mpg and disp.
#' B <- agg(form, mtcars, ms)       # str(B) # Unnested.
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{aggregate}}, \code{\link{do.call}}, \code{\link{data.frame}}

agg <- function(...) do.call(data.frame, aggregate(...))
  
  
  
