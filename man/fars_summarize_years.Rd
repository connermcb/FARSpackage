% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_summarize_years}
\alias{fars_summarize_years}
\title{Summarize fatality counts by year}
\usage{
fars_summarize_years(years)
}
\arguments{
\item{years}{vector of four-digit years as integer or strings.}
}
\value{
Data.frame of fatalities by month for all years in \code{years}
}
\description{
Reads and binds data files for each year in \code{years} into single data.frame
before summarizing fatality counts in a table with columns as years and rows
as months represented by integers using \code{link{fars_read_years}}
}
\examples{
fars_summarize_years(2015)

}
