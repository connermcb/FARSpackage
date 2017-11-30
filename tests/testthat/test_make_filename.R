library(FARSfunctions)
context("Make file name check")

test_that("function make_filename produces correct output", {
  expect_identical(make_filename("2015"),
                   system.file("extdata",
                               "accident_2015.csv.bz2",
                               package="FARSfunctions"))
  expect_is(make_filename("2015"), "character")
})
