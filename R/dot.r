#' Compact mapply()
#' 
#' @description Inspired by the dot syntax from Julia's \code{broadcast}, execute mapply() with a convenient shortand.
#'
#' @param ... Same inputs as \code{\link{mapply}}.
#' 
#' @return List.
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{mapply}},  
#' \code{broadcast} from Julia: \url{https://docs.julialang.org/en/v0.6.1/manual/arrays/#Broadcasting-1}

. <- function(...) mapply(...)