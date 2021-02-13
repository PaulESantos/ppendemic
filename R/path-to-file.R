#' Get file path to `ppendemic` files
#'
#' ppendemic comes bundled with csv files in its `inst/extdata`
#' directory. This function make them easy to access.
#'
#'

#'
#' @param path `NULL`, the source files will be listed.
#' @export
#' @examples
#' path_to_file()
#'
#' @source This function is adapted from `readxl::readxl_example()`.
path_to_file <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "ppendemic"))
  } else {
    system.file("extdata", path, package = "ppendemic", mustWork = TRUE)
  }
}
