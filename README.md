# FARSpackage

## About

The `FARSpackage` is a simple toy example implemented for the purpose of learning to build an R package using RStudio and the `devtools` package. 

The package is built around a single .R file with a suite of functions for summarizing and geographically plotting data from the Fatality Analysis Reporting System, a database of highway fatalities in the 50 United States and her territories. 

More information about the database as well as the datasets used by the functions in this package can be found in the [FARS Encyclopedia](https://www-fars.nhtsa.dot.gov/Main/index.aspx) at the National Highway Traffic Safety Adminstration website.

## Data

The data used by the functions in this package and included as an internal data source called by the examples in the documentation is organized into files by calendar year. Each file contains a variable number of observations by fifty-two variables, only a few of which are employed by the package functions. Since the package is primarily for summarizing and plotting, geographic variables (latitude, longitude, and state) are selected during data tidying and reshaping. Summarizing functions rely soley on grouped observation counts to produce summary tables. 

## Functions

The two exported functions that are available to users and constitute the workhorses of the package are `fars_map_state` and `fars_summarize_years`. The first produces a simple two-layer plot of the outline of the state and scatter plot of the coordinate points corresponding to each traffic accident included in the dataset.

The exported functions rely on additional unexported helper functions responsible for loading, tidying and formatting the data before feeding it to `fars_map_state` or `fars_summarize_years`.

## travis-ci Badge
[![Build Status](https://travis-ci.org/connermcb/FARSpackage.svg?branch=master)](https://travis-ci.org/connermcb/FARSpackage)
