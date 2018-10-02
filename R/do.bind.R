#' List-apply a function and then bind the results
#' 
#' @description List-apply a function and then bind the results. Effectively, this function calls \code{\link{lapply}}, \code{\link{do.call}}, and either\code{\link{rbind}} or \code{\link{cbind}} depending on the given specifications.
#'
#' @usage do.bind(f, x, m = 1, ...)
#'
#' @param f A function to apply to the collection.
#' @param x A collection, such as a list, matrix, or dataframe.
#' @param m Margin. 1 to call \code{\link{rbind}} (default) and 2 for \code{\link{cbind}}.
#' @param ... Arguments passed to \code{\link{do.call}}.
#' @return Matrix or dataframe.
#' @details After applying functions such as \code{\link{lapply}} or \code{\link{Map}} to a dataset, \code{\link{do.call}} is often a solution to combine the list elements to obtain the original tabular format. 
#' 
#' To simplify this process, \code{\link{lapply}} and\code{\link{do.call}} are wrapped into \code{do.bind}: it calls a function on a dataset and binds the elements into a matrix or dataframe (depending on the original collection type). One may achieve similar results with \code{\link{purrr::map_dfr}} or \code{\link{purrr::map_dfc}}.
#' 
#' The type of bind is defined in a binary fashion (1 for row-wise, 2 for column-wise).
#' 
#' @examples
#' # 1. Store lm() coefficients in matrix.
#' split1  <- split(mtcars, mtcars$gear)
#' adhoc1  <- function(s) {coef(lm(mpg ~ disp + wt + am, s))}
#' output1 <- do.bind(adhoc1, split1)
#' output1 # matrix. Rownames indicate subset.
#' 
#' # 2. What is the median Ozone-Temperature ratio for each given month?
#' airquality2 <- na.omit(airquality)
#' split2      <- split(airquality2, airquality2$Month)
#' adhoc2      <- function(x, y) {median(x/y)}
#' output2     <- do.bind(function(s) with(s, adhoc2(Ozone, Temp)), split2, 2)
#' output2 # matrix
#'
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{lapply}}, \code{\link{do.call}}, \code{\link{rbind}}, \code{\link{cbind}}, \url{https://purrr.tidyverse.org/}

do.bind <- function(f, x, m = 1, ...) { 
  
  # 1. Type-check function input.
  f <- match.fun(f)
  
  # 2. Map f to x.
  l <- lapply(x, f)
  
  # 3. Combine list back into a tabular format based on whether m == 1 or 2.
  if (m == 1) {
    
    output <- do.call(rbind, l, ...)
    
  } else if (m == 2) {
    
    output <- do.call(cbind, l, ...)
    
  } else {
    
    stop('Invalid m (margin) input. Please specifiy a bind-type of 1 (row-wise) or 2 (column-wise).')
    
  }
  
  output
  
}