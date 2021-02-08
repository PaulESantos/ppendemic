delayedAssign("species_pep", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(ppendemic:::species_pp)
  } else {
    ppendemic:::species_pp
  }
}))

delayedAssign("regiones_ecologicas", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(ppendemic:::regiones_ecologicas)
  } else {
    ppendemic:::regiones_ecologicas
  }
}))
delayedAssign("registro_departamental", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(ppendemic:::registro_departamental)
  } else {
    ppendemic:::registro_departamental
  }
}))
