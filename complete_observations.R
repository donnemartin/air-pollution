CompleteObservations <- function(directory, id=1:332) {
  # Reads a directory full of files and reports the number of completely
  # observed cases in each data file. The function returns a data frame where
  # the first column is the name of the file and the second column is the
  # number of complete cases.
  #
  # Args:
  #   directory: character vector of length 1 indicating
  #     the location of the CSV files
  #   id: integer vector indicating the monitor ID numbers to be used
  #
  # Returns:
  #   A data frame of the form:
  #   id nobs
  #   1  117
  #   2  1041
  #   ...
  #   where 'id' is the monitor ID number and 'nobs' is the
  #   number of complete cases

  source("utils.R")

  listOfDataFrames <- GenerateDataFramesFromCSV(directory, id)

  # Generate a data frame of observations per file
  dfObservations <- ldply(listOfDataFrames,
                          function(x) {
                            return(nrow(na.omit(x)))
                          })

  # Generate a data frame of file ids
  dfFiles <- ldply(id,
                   function(x) {
                     return(x)
                   })

  dfCompleteObservations <- data.frame(dfFiles, dfObservations)

  # Rename the default columns to be more descriptive
  dfCompleteObservations <- rename(dfCompleteObservations,
                                   c("V1"="id", "V1.1"="nobs"))
  return(dfCompleteObservations)
}

# Tests
# TODO: Add RUnit or testthat unit test
CompleteObservations("specdata", 1)
# id nobs
# 1  1  117
CompleteObservations("specdata", c(2, 4, 8, 10, 12))
# id nobs
# 1  2 1041
# 2  4  474
# 3  8  192
# 4 10  148
# 5 12   96
CompleteObservations("specdata", 30:25)
# id nobs
# 1 30  932
# 2 29  711
# 3 28  475
# 4 27  338
# 5 26  586
# 6 25  463
CompleteObservations("specdata", 3)
# id nobs
# 1  3  243