##
## Getting & Cleaning Data
##
## Assignment Week 4 - February 2nd 2016
##
## File: get_smartphone_data.R
## 
## Purpose: download the "Human Activity Recognition Using Smartphones Dataset"
##

# If there is no directory named "UCI HAR Dataset" in "data", we download the dataset and unzip it there
if (!dir.exists("./UCI HAR Dataset")) {
  dataset <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(dataset, "./UCI-HAR-dataset.zip", method="curl")
  unzip("./UCI-HAR-dataset.zip", exdir = ".")
}

# The extracted dataset will be cleaned and analysed in the run_analysis.R script.
