
#' @title Read data file
#'
#' @description
#' Reads file with '.csv/.bz2' extensions into R workspace using readr library
#' and converts it to a data.frame using the \code{dplyr} \code{tbl_df} function.
#' If \code{file_name} not found function is stopped and "file does not exist"
#' warning is returned.
#'
#' @details
#' This is a helper function used with other FARS family functions in this
#' package. Specifically it is called in \code{\link{fars_read_years}},
#' \code{\link{fars_summarize_years}} and \code{\link{fars_map_state}}.
#'
#' @param filename File is .csv or .bz2 compressed file
#'
#' @importFrom readr read_csv
#' @import dplyr
#'
#' @seealso \code{\link{fars_read_years}} for reading and subsetting multiple FARS files into
#' a single data.frame
#'
#' @return If file name exists in current working directory, returns data.frame
#' class object. If file name not found, function stopped and "file does not exist"
#' warning returned.
#'
#' @examples
#' \dontrun{
#' df <- fars_read("data_file.csv")
#' df <- fars_read("data_file.csv.bz2")
#'}
#'

fars_read <- function(filename) {
        if(!file.exists(filename)){
          stop("file '", filename, "' does not exist")
          }
        d <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        return(d)
}


#'@title Create file name
#'
#'@description
#'Formats string file name to facilitate loading FARS files.
#'
#'
#'@details
#'Helper function used with other functions in this package, specifically
#'\code{\link{fars_read_years}}, \code{\link{fars_map_state}}.
#'
#'@param year An four-digit year to be assigned to
#'file name. Function accepts both integers and strings as it converts the
#'latter to an integer before assembling file name.
#'
#'@seealso
#'\code{fars_read} is called as a helper function in
#'\code{\link{fars_read_years}}, \code{\link{fars_map_state}}
#'
#'@return Returns a string in FARS format with \code{year} embedded. The file
#'name has .csv.bz2 file extensions.
#'
#'@examples
#'\dontrun{
#'make_filename("2015")
#'make_filename("2016")
#'}

make_filename <- function(year) {
        year <- as.integer(year)
        f <- sprintf("accident_%d.csv.bz2", year)
        system.file("extdata", f, package="FARSfunctions")
}

#'@title Read multiple data files
#'
#'@description
#'Reads and binds into single data.frame all data files corresponding to values
#'in \code{years}. Dataframe reduced to variables \code{MONTH} and\code{year} before
#'being returned. Serves as pre-processing helper function for
#'\code{\link{fars_summarize_years}}.
#'
#'@details
#'If there is not a data file for any given year, "invalid year" warning will
#'be raised.
#'
#'@param years vector of four-digit years as integer or strings.
#'
#'@import dplyr
#'
#'@return
#'data.frame
#'

fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dat <- dplyr::mutate(dat, year = year)
                        dat <- dplyr::select_(dat, MONTH, year)
                        return(dat)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#'@title Summarize fatality counts by year
#'
#'@description
#'Reads and binds data files for each year in \code{years} into single data.frame
#'before summarizing fatality counts in a table with columns as years and rows
#'as months represented by integers using \code{link{fars_read_years}}
#'
#'@param years vector of four-digit years as integer or strings.
#'
#'@import dplyr
#'@import tidyr
#'@import magrittr
#'
#'@return
#'Data.frame of fatalities by month for all years in \code{years}
#'
#'@examples
#'\dontrun{
#'fars_summarize_years(2013)
#'fars_summarize_years(c(2013, 2014, 2015))
#'}
#'@export
#'

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dt <- dplyr::bind_rows(dat_list)
        grpd <- dplyr::group_by_(dt, year, MONTH)
        sum_stats <- dplyr::summarize(grpd, n = n())
        results <- tidyr::spread(sum_stats, year, n)
        knitr::kable(results, align = 'c', caption = "Fatalities by Month")
}


#'@title Map FARS data by state
#'
#'@description
#'Geographically plots highway fatalities from FARS data, subset by \code{state.nm}
#'and \code{year} arguments.
#'
#'@details
#'If \code{state.num} not found in data, function stopped and "invalid STATE
#'number" error will be returned. If no data file exists for \code{year},
#'call to \code{fars_read} will return "file does not exist" error.
#'
#'If there are no fatalities for described subset, returns message "no accidents
#'to plot"
#'
#'If the given value for state.num is not a state in the dataset, a "invalid STATE"
#'error is raised.
#'
#'@param state.num Number encoding of state in FARS data. Argument can be input
#'as integer or string. More information including codebook can be found at
#'NHTSA website \url{https://www.nhtsa.gov/research-data}.
#'
#'@param year Four-digit year as integer or string of the data to be plotted.
#'
#'@importFrom dplyr filter
#'@importFrom maps map
#'@importFrom graphics points
#'
#'@return
#'NULL value
#'
#'@examples
#'\dontrun{
#'fars_map_state(1, 2013)
#'}
#'@export
#'

fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter_(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}

