% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read}
\alias{fars_read}
\title{Read data file}
\usage{
fars_read(filename)
}
\arguments{
\item{filename}{File is .csv or .bz2 compressed file}
}
\value{
If file name exists in current working directory, returns data.frame
class object. If file name not found, function stopped and "file does not exist"
warning returned.
}
\description{
Reads file with '.csv/.bz2' extensions into R workspace using readr library
and converts it to a data.frame using the \code{dplyr} \code{tbl_df} function.
If \code{file_name} not found function is stopped and "file does not exist"
warning is returned.
}
\details{
This is a helper function used with other FARS family functions in this
package. Specifically it is called in \code{\link{fars_read_years}},
\code{\link{fars_summarize_years}} and \code{\link{fars_map_state}}.
}
\examples{
\dontrun{
df <- fars_read("data_file.csv")
df <- fars_read("data_file.csv.bz2")
}

}
\seealso{
\code{\link{fars_read_years}} for reading and subsetting multiple FARS files into
a single data.frame
}
