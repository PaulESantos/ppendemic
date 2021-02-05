.onAttach <- function(lib, pkg)  {
  packageStartupMessage("This is ppendemic ",
                        utils::packageDescription("ppendemic",
                                                  fields="Version"),
                        appendLF = TRUE)
}
