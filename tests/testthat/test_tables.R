library(FARSfunctions)
context("Data Table class and dimensions")

test_that("loaded dataframe is the correct class and dimensions",{
  expect_is(fars_read(
    system.file("extdata",
                "accident_2015.csv.bz2",
                package="FARSfunctions")), "data.frame")
  expect_equal(ncol(fars_read(
    system.file("extdata",
                "accident_2015.csv.bz2",
                package="FARSfunctions"))), 52)
  expect_gt(nrow(fars_read(
    system.file("extdata",
                "accident_2015.csv.bz2",
                package="FARSfunctions"))), 0)
})




