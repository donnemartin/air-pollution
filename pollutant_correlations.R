PollutantCorrelation <- function(directory, threshold=0) {
  # Takes a directory of data files and a threshold for complete cases and
  # calculates the correlation between sulfate and nitrate for monitor
  # locations where the number of completely observed cases (on all variables)
  # is greater than the threshold. Returns a vector of correlations for the
  # monitors that meet the threshold requirement. If no monitors meet the
  # threshold requirement, then the returns a numeric vector of length 0.
  #
  # Args:
  #   directory: character vector of length 1 indicating
  #     the location of the CSV files
  #   threshold: numeric vector of length 1 indicating the
  #     number of completely observed observations (on all
  #     variables) required to compute the correlation between
  #     nitrate and sulfate; the default is 0
  #
  # Returns:
  #   A numeric vector of correlations

  source("utils.R")
  source("complete_observations.R")

  # Get a list of files with completed observations within our threshold
  kMaxMonitors <- 332
  dfCompleteObs <- CompleteObservations("specdata", 1:kMaxMonitors)
  dfCompleteObsInThreshold <- subset(dfCompleteObs, numObs > threshold)

  # If no monitors meet the threshold requirements, return a numeric
  # vector of length 0
  if (nrow(dfCompleteObsInThreshold) == 0) {
    return(c(0))
  }

  # Load the data for files that match our threshold
  # TODO: CompleteObservations already loads the data, address this
  # double file data load performance hit
  obsInThreshold <- dfCompleteObsInThreshold[, "id"]
  listOfDataFrames <- GenerateDataFramesFromCSV(directory, obsInThreshold)

  # Determine the correlation
  # Uses casewise deletion for missing values
  # If there are no complete cases, return NA
  dfCorrelation <- ldply(listOfDataFrames,
                         function(list) {
                           correlation <- cor(list[, "sulfate"],
                                              list[, "nitrate"],
                                              use="na.or.complete")
                           return(correlation)
                         })

  # Change the column names to something more manageable
  colnames(dfCorrelation) <- c("corr")

  # Build the vector of correlations
  correlations <- dfCorrelation[, "corr"]

  return(correlations)
}

# Tests
cr <- PollutantCorrelation("specdata", 150)
head(cr)
# [1] -0.01896 -0.14051 -0.04390 -0.06816 -0.12351 -0.07589
summary(cr)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# -0.2110 -0.0500  0.0946  0.1250  0.2680  0.7630
cr <- PollutantCorrelation("specdata", 400)
head(cr)
# [1] -0.01896 -0.04390 -0.06816 -0.07589  0.76313 -0.15783
summary(cr)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# -0.1760 -0.0311  0.1000  0.1400  0.2680  0.7630
cr <- PollutantCorrelation("specdata", 5000)
summary(cr)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#    0       0       0       0       0       0
length(cr)
# [1] 0
cr <- PollutantCorrelation("specdata")
summary(cr)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# -1.0000 -0.0528  0.1070  0.1370  0.2780  1.0000
length(cr)
# [1] 323