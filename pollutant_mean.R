PollutantMean <- function(directory, pollutant, id=1:332) {
  # Calculates the mean of a pollutant (sulfate or nitrate) across a specified
  # list of monitors. The function 'pollutantmean' takes three arguments:
  # 'directory', 'pollutant', and 'id'. Given a vector of monitor ID numbers,
  # 'pollutantmean' reads that monitors' particulate matter data from the
  # directory specified in the 'directory' argument and returns the mean of the
  # pollutant across all of the monitors, ignoring any missing values coded as
  # NA.
  #
  # Args:
  #   directory: character vector of length 1 indicating
  #     the location of the CSV files
  #   pollutant: character vector of length 1 indicating the name of the
  #     pollutant for which we will calculate the mean; either "sulfate" or
  #     "nitrate"
  #   id: integer vector indicating the monitor ID numbers to be used
  #
  # Returns:
  #   The mean of the pollutant across all monitors list in the 'id' vector
  #   (ignoring NA values)

  source("utils.R")

  # Error handling
  if (pollutant != "sulfate" && pollutant != "nitrate") {
    stop("Argument pollutant must either be sulfate or nitrate: ",
         pollutant, ".")
  }

  listOfDataFrames <- generateDataFramesFromCSV(directory, id)

  # Generate a single dataframe from our list of data frames
  df <- ldply(listOfDataFrames)

  pollutantMean <- mean(df[, pollutant], na.rm=TRUE)
  return(pollutantMean)
}

# Tests
# TODO: Add RUnit or testthat unit test
PollutantMean("specdata", "sulfate", 1:10)
# [1] 4.064
PollutantMean("specdata", "nitrate", 70:72)
# [1] 1.706
PollutantMean("specdata", "nitrate", 23)
# [1] 1.281