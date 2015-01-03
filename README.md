# airpollution

R scripts that analyze sulfate and nitrate pollution data from sensors monitoring fine particulate matter air pollution at 332 locations in the United States.

## Data

* The data contains 332 comma-separated-value (CSV) files containing pollution monitoring data for fine particulate matter (PM) air pollution at 332 locations in the United States. Each file contains data from a single monitor and the ID number for each monitor is contained in the file name. For example, data for monitor 200 is contained in the file "200.csv". Each file contains three variables:
* Date: the date of the observation in YYYY-MM-DD format (year-month-day)
* sulfate: the level of sulfate PM in the air on that date (measured in micrograms per cubic meter)
* nitrate: the level of nitrate PM in the air on that date (measured in micrograms per cubic meter)
* In each file there are many days where either sulfate or nitrate (or both) are missing (coded as NA). This is common with air pollution monitoring data in the United States.

## GenerateDataFramesFromCSV

Utility function.  Takes a directory and csv file ids and returns a list of data frames containing the contents of each csv per data frame

Called by PollutantMean, CompleteObservations, and GenerateDataFramesFromCSV.

## PollutantMean

Calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA.

```R
PollutantMean("specdata", "sulfate", 1:10)
# [1] 4.064
PollutantMean("specdata", "nitrate", 70:72)
# [1] 1.706
PollutantMean("specdata", "nitrate", 23)
# [1] 1.281
```

## CompleteObservations

Reads a directory full of files and reports the number of completely observed cases in each data file. The function returns a data frame where the first column is the name of the file and the second column is the number of complete cases.

```R
CompleteObservations("specdata", 1)
# id numObs
# 1  1  117
CompleteObservations("specdata", c(2, 4, 8, 10, 12))
# id numObs
# 1  2 1041
# 2  4  474
# 3  8  192
# 4 10  148
# 5 12   96
CompleteObservations("specdata", 30:25)
# id numObs
# 1 30  932
# 2 29  711
# 3 28  475
# 4 27  338
# 5 26  586
# 6 25  463
CompleteObservations("specdata", 3)
# id numObs
# 1  3  243
```

## PollutantCorrelation

Takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function returns a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function returns a numeric vector of length 0.

```R
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
```

##License

    Copyright 2014 Donne Martin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
