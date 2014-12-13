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

  listOfDataFrames <- generateDataFramesFromCSV(directory, id)

  # Generate a data frame of observations per file
  dfObservations <- ldply(listOfDataFrames,
                          function(x) {
                            numObs <- nrow(na.omit(x))
                            return(numObs)
                          })

  # Generate a data frame of file ids
  dfFiles <- ldply(id,
                   function(x) {
                     return(x)
                   })

  # Determine the correlation
  # Uses casewise deletion for missing values
  # If there are no complete cases, return NA
  dfCorrelation <- ldply(listOfDataFrames,
                        function(x) {
                          correlation <- cor(x[, "sulfate"],
                                               x[, "nitrate"],
                                               use="na.or.complete")
                          return(correlation)
                        })

  dfCompleteObservations <- data.frame(dfFiles, dfObservations, dfCorrelation)

  # Rename the default columns to be more descriptive
  dfCompleteObservations <- rename(dfCompleteObservations,
                                   c("V1"="id", "V1.1"="nobs", "V1.2"="cor"))
  return(dfCompleteObservations)
}

# Tests
# TODO: Add RUnit or testthat unit test
CompleteObservations("specdata", 1)
# id nobs        cor
# 1  1  117 -0.2225526
CompleteObservations("specdata", c(2, 4, 8, 10, 12))
# id nobs         cor
# 1  2 1041 -0.01895754
# 2  4  474 -0.04389737
# 3  8  192 -0.15967365
# 4 10  148  0.16137933
# 5 12   96 -0.07881378
CompleteObservations("specdata", 30:25)
# id nobs        cor
# 1 30  932 0.05774168
# 2 29  711 0.72669389
# 3 28  475 0.00686393
# 4 27  338 0.58075126
# 5 26  586 0.36620108
# 6 25  463 0.13327461
CompleteObservations("specdata", 3)
# id nobs        cor
# 1  3  243 -0.1405125