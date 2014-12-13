GenerateDataFramesFromCSV <- function(directory, id) {
  # Takes a directory and csv file ids and returns a list of data frames
  # containing the contents of each csv per data frame
  #
  # Args:
  #   directory: character vector of length 1 indicating
  #     the location of the CSV files
  #   id: integer vector indicating the monitor ID numbers to be used
  #
  # Returns:
  #   A list of data frames containing the contents of each csv per data frame

  fileNames <- sprintf("%03d.csv", id)
  filePaths <- paste(directory, fileNames, sep="/")

  # Generate a list of dataframes, one for each csv
  dfList <- lapply(filePaths, read.csv)
  return(dfList)
}