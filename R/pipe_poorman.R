#' Forward-pipe operator
#'
#' Pipe an object forward into a function or call expression,
#' from [poorman](https://nathaneastwood.github.io/poorman/)
#'
#' @param lhs The result you are piping.
#' @param rhs Where you are piping the result to.
#' @name pipe
#'
#' @author
#' Nathan Eastwood and Antoine Fabri \email{antoine.fabri@@gmail.com}.
#'
#' @export
`%>%` <- function(lhs, rhs) {
  rhs_call <- insert_dot(substitute(rhs))
  eval(rhs_call, envir = list(`.` = lhs), enclos = parent.frame())
}

#' @author Antoine Fabri
#' @noRd
insert_dot <- function(expr) {
  if (is.symbol(expr) || expr[[1]] == quote(`(`)) {
    # if a symbol or an expression inside parentheses, make it a call with dot
    # arg
    expr <- as.call(c(expr, quote(`.`)))
  } else if (length(expr) == 1) {
    # if a call without an arg, give it a dot arg
    expr <- as.call(c(expr[[1]], quote(`.`)))
  } else if (
    expr[[1]] != quote(`{`) &&
    !any(vapply(expr[-1], identical, quote(`.`), FUN.VALUE = logical(1))) &&
    !any(vapply(expr[-1], identical, quote(`!!!.`), FUN.VALUE = logical(1)))
  ) {
    # if a call with args but no dot in arg, insert one first
    expr <- as.call(c(expr[[1]], quote(`.`), as.list(expr[-1])))
  }
  expr
}
