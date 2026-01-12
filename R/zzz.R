# ---- helpers ------------------------------------------------------------

ppendemic_version <- function(pkg = "ppendemic") {
  as.character(utils::packageVersion(pkg))
}

highlight_version <- function(x) {
  x <- as.character(x)

  is_dev_piece <- function(piece) {
    n <- suppressWarnings(as.numeric(piece))
    !is.na(n) && n >= 9000
  }

  pieces <- strsplit(x, ".", fixed = TRUE)[[1]]

  if (requireNamespace("cli", quietly = TRUE)) {
    pieces <- vapply(
      pieces,
      function(p) if (is_dev_piece(p)) cli::col_red(p) else p,
      FUN.VALUE = character(1)
    )
  }

  paste(pieces, collapse = ".")
}

ppendemic_startup_header <- function(pkgname) {
  ver <- highlight_version(ppendemic_version(pkgname))

  # Mensaje simple si cli no está disponible
  if (!requireNamespace("cli", quietly = TRUE)) {
    return(sprintf("Access Peruvian plant endemic data - %s %s", pkgname, ver))
  }

  cli::rule(
    left  = cli::style_bold("Access Peruvian plant endemic data"),
    right = paste0(pkgname, " ", ver)
  )
}

show_progress <- function() {
  isTRUE(getOption("ppendemic.show_progress")) && interactive()
}

# ---- hooks --------------------------------------------------------------

.onLoad <- function(libname, pkgname) {
  # Solo seteamos default si el usuario NO lo definió
  op <- getOption("ppendemic.show_progress")
  if (is.null(op)) {
    options(ppendemic.show_progress = TRUE)
  }
  invisible(TRUE)
}

.onAttach <- function(libname, pkgname) {
  msg <- ppendemic_startup_header("ppendemic")

  # packageStartupMessage siempre; appendLF para que quede limpio
  packageStartupMessage(msg, appendLF = TRUE)
}


# -------------------------------------------------------------------------
