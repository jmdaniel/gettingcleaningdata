### CodeBook.md
####
### <span style="color:blue">Getting & Cleaning Data</span>
#### *Assigment Week 4 - February 2nd 2016*
###
> Human Activity Recognition Using Smartphones Dataset
- This code book describes the variables, the data, and any transformations / work that has been performed to clean up the data and obtain the required tidy data set for submission.
 
####1. Main variables in use in the R scripts

   - featurestab: table of the features of the Dataset
   - traindata: training data
   - testdata: testing data
   - alldata: resultset of training + testing data
   
   - vectmeanstd: index vector of mean & standard deviation measurements features
   - meanstd_data: whole dataset with only mean & standard deviation measurements features
   - traincodes: code of activity for each observation in training dataset
   - testcodes: code of activity for each observation in testing dataset
   - allactivity_data: whole dataset with the name of the activity for each observation
   
   - meanstd_data: data resultset obtained with only the mean and standard deviation for each measurement. This is the raw data use to generate the final tidy dataset
   - agg_mean_act_subj: final tidy dataset
   

####2. Script ``` get_smartphone_data.R ```: getting the dataset before analysis

- The following code download the dataset from the https://d396qusza40orc.cloudfront.net/ web site, extract the data into the current directory, as specified by the assignment, before being analysed by the run_analysis.R script.

```{r}
# If there is no directory named "UCI HAR Dataset" in "data", we download the dataset and unzip it inside "data" directory.

if (!dir.exists("./UCI HAR Dataset")) {
  dataset <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(dataset, "./UCI-HAR-dataset.zip", method="curl")
  unzip("./UCI-HAR-dataset.zip", exdir = ".")
}
```


####3. Script ``` run_analysis.R ```: analysis steps performed on the dataset

- This script performs the data analysis through the following 5 steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Each step is hereafter further detailed.

##### 3.1. Merges the training and the test sets to create one data set.

- We read the training and testing dataset from the respected files: X_train.txt & X_test.txt

```{r}
# Read the training dataset
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
# traindata: # 7352 records / 561 features

# Reads the test dataset
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
# testdata: # 2947 records / 561 features
```

- We merge the training and testing datasets

```{r}
# Training data first, then test data
alldata <- rbind(traindata, testdata)
```

- The resultset "alldata" is a dataframe of 10299 records and 561 features


##### 3.2. Extracts only the measurements on the mean and standard deviation for each measurement.

- We retrieve the column names (features) of the data set from feature.txt

```{r}
featurestab <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, 
                          col.names = c("index","features"))
```

- We look for labels with "mean()" and "std()" only
- Note about meanFreq(): Weighted average of the frequency components to obtain a mean frequency. This measure will be excluded from the measurements since it's a frequency and not a mean.
- We apply the resulting vector of columns indexes to the previous dataset (alldata) to filter out all unnecessary columns

```{r}
vectfeatures <- featurestab$features
# Retrieve the index of the mean() & std() features
indexfeatures <-  grep("mean\\()|std\\()", vectfeatures)

# Apply to alldata
meanstd_data <- alldata[ , indexfeatures]
# Assign relevant column names
colnames(meanstd_data) <- vectfeatures[indexfeatures] # 66 columns
```

- The resultset "meanstd_data"" is a dataframe of 10299 records with 66 features

##### 3.3. Uses descriptive activity names to name the activities in the data set
- Activity names are read from "activity_labels.txt"
- We replace the activity codes by the name of each corresponding activity and store the result in "allactivity_data"

```{r} 
activitydesc <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                           header = FALSE, stringsAsFactors = FALSE) # 6 records
                           
# Retrieve activity codes from train & test data
traincodes <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                         header = FALSE, col.names = "activity") # 7352 records

testcodes <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                        header = FALSE, col.names = "activity") # 2947 records
                        
# Merge data
allactivity_data <- rbind(traincodes, testcodes)

# Replace activity numbers by activity labels
for (i in 1:nrow(activitydesc)) {
  allactivity_data[allactivity_data == i] <- activitydesc[i, 2]
}

```

- The resulset "allactivity_data" is a dataframe of 10299 records with the activity name for each record

##### 3.4. Appropriately labels the data set with descriptive variable names.
We clean up the data by renaming the column names to comply with standard naming conventions: no parenthesis, no "-" and lower cases in the names.  

```{r}
# Remove ()" and "-" from the column names, use lower case
# Replace "BodyBody" by "body" in some column names
names(meanstd_data) <- gsub("\\()", "", names(meanstd_data))
names(meanstd_data) <- gsub("-", ".", names(meanstd_data))
names(meanstd_data) <- gsub("BodyBody", "Body", names(meanstd_data))
names(meanstd_data) <- tolower(names(meanstd_data))

# Add the activity labels to the dataset 
meanstd_data$activity <- alldatacodes

```

- The resultset "meanstd_data" is a dataframe of 10299 with 67 features

##### 3.5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- We retrieve the subject dataset, result of merging the training subject and testing subject dataset

```{r}
# Reads the training dataset
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header = FALSE, col.names = "subject")

# Reads the testing dataset
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           header = FALSE, col.names = "subject")

# Concatenate training & testing subject data
# Attach "subject" column to the existing dataframe
meanstd_data$subject <- rbind(trainsubjects, testsubjects) # dataframe
```

- The resultset "meanstd_data" is a dataframe of 10299 with 68 features
- Features 67 & 68 are respectively "activity" and "subject"

- We aggregate data per activity (meanstd_data$activity[,1]), per subject (meanstd_data$subject[,1]) and name the first two columns of the resultset as "activity" & "subject"
- We don't take the "activity" and "subject" columns in the resultset to avoid NA (columns 67 & 68)
- We write the result in "activity_subject_tidy.txt" file, in CSV format, with the names of each column (features)

```{r}
agg_mean_act_subj <- aggregate(meanstd_data[, -(67:68)], 
                               list(activity = meanstd_data$activity[,1],
                                    subject = meanstd_data$subject[,1]), mean)

# Write the file with column names but no name for the rows.
write.csv(agg_mean_act_subj, file = "activity_subject_tidy.txt",
          row.names = FALSE)
```

- The resultset "agg_mean_act_subj" is a dataframe of 180 records (6 activities per 30 subjects) with 68 features
- This dataset is stored in the current directory as "activity_subject_tidy.txt".

####4. Steps to reproduce this analysis and generate the tidy dataset

```{r}
source("get_smartphone_data.R")
source("run_analysis.R")
```

End of the CodeBook

