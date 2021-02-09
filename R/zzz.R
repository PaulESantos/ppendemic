
.onAttach <- function(lib, pkg)  {
  packageStartupMessage("This is ppendemic ",
                        utils::packageDescription("ppendemic",
                                                  fields="Version"),
                        appendLF = TRUE)
}


# -------------------------------------------------------------------------

show_progress <- function() {
  isTRUE(getOption("ppendemic.show_progress")) && # user disables progress bar
    interactive()  # Not actively knitting a document
}



.onLoad <- function(libname, pkgname) {
  opt <- options()
  opt_ppendemic <- list(
    ppendemic.show_progress = TRUE
  )
  to_set <- !(names(opt_ppendemic) %in% names(opt))
  if(any(to_set)) options(opt_ppendemic[to_set])
  invisible()
}


# -------------------------------------------------------------------------


