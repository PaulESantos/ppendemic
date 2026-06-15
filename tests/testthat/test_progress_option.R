test_that("show_progress requires both the option and an interactive session", {
  old <- options(ppendemic.show_progress = FALSE)
  on.exit(options(old), add = TRUE)
  expect_false(ppendemic:::show_progress())

  options(ppendemic.show_progress = TRUE)
  expect_identical(
    ppendemic:::show_progress(),
    interactive()
  )
})

test_that("map_dfr_progress works when progress display is disabled", {
  old <- options(ppendemic.show_progress = FALSE)
  on.exit(options(old), add = TRUE)

  out <- ppendemic:::map_dfr_progress(
    list(1L, 2L),
    function(x) tibble::tibble(value = x)
  )

  expect_equal(out$value, c(1L, 2L))
})
