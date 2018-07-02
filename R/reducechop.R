#' Reduce a 2D dataset by a given margin
#' 
#' @description Reduce a tabular data column-wise or row-wise.
#'
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param x A matrix or data frame.
#' @param m Margin. 1 = row-wise; 2 = column-wise (default). See \code{\link{apply}}.
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @return Vector.
#' 
#' @details Effectively, this function calls \code{\link{apply}} to determine whether \code{\link{Reduce}} is mapped over columns or rows. 
#' 
#' By default, \code{reducechop} will execute over columns on the basis that row-wise application is equivalent to \code{Reduce}; however, \code{reducechop(..., m = 1)} is explicit about the execution.
#' 
#' @examples
#' reducechop(`+`, mtcars, 2) # Column-wise (default).
#' reducechop(`/`, mtcars, 1) # Row-wise. Equivalent to Reduce(`/`, mtcars).  
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Reduce}}, \code{\link{apply}},
#' \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}},  
#' \code{mapslices} from Julia:\url{https://docs.julialang.org/en/v0.6.2/stdlib/arrays/#Base.mapslices},  
#' Original \code{reducechop}: \url{https://github.com/robertschnitman/afpj/blob/master/src/reducechop.jl}

reducechop <- function(o, x, m = 2, ...) {
  
  # 1. Type-check inputs.
  o <- match.fun(o)
  
  stopifnot(is.matrix(x) | is.data.frame(x)) # Intent is that x is 2D.
  
  if (!any(m == 1:2)) {
    
    stop('The margin must either be 1 (row-wise) or 2 (column-wise).')
    
  }
  
  # 2. Use apply() to set margins.
  output <- apply(x, m, function(z) Reduce(o, z, ...)) # mrchop() is not multivariate.
  
  # 3. Output should be a vector.
  output
  
}
