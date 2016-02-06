##
## Getting & Cleaning Data
##
## Assignment Week 4 - February 2nd 2016
##
## File: run_analysis.R
## 
## Purpose: analyse the "Human Activity Recognition Using Smartphones Dataset"
##

### 1.Merges the training and the test sets to create one data set.
# Read the training dataset
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
# traindata: # 7352 records / 561 features 

# Reads the test dataset
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
# testdata: # 2947 records / 561 features

# Merge the 2 datasets
# Training data first, then test data
alldata <- rbind(traindata, testdata)
# alldata: 10299 records / 561 features

### 2. Extracts only the measurements on the mean and standard deviation for each 
#      measurement

# Retrieve the column names (features) of the data set
featurestab <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, 
                          col.names = c("index","features"))

# We look for labels with "mean()" and "std()"
# Retrieve the index of the mean() & std() features
vectfeatures <- featurestab$features
indexfeatures <-  grep("mean\\()|std\\()", vectfeatures)

# Apply to alldata
meanstd_data <- alldata[ , indexfeatures]
# Assign relevant column names
colnames(meanstd_data) <- vectfeatures[indexfeatures]


### 3. Uses descriptive activity names to name the activities in the data set
# Activity names are read from "activity_labels.txt"
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

### 4. Appropriately labels the data set with descriptive variable names.
# Remove ()" and "-" from the column names, use lower case
# Replace "BodyBody" by "body" in some column names
names(meanstd_data) <- gsub("\\()", "", names(meanstd_data))
names(meanstd_data) <- gsub("-", ".", names(meanstd_data))
names(meanstd_data) <- gsub("BodyBody", "Body", names(meanstd_data))
names(meanstd_data) <- tolower(names(meanstd_data))

# Add the activity labels to the dataset 
meanstd_data$activity <- allactivity_data

### 5. From the data set in step 4, creates a second, independent tidy dataset 
#      with the average of each variable for each activity and each subject.

# Reads the training dataset
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header = FALSE, col.names = "subject")

# Reads the testing dataset
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           header = FALSE, col.names = "subject")

# Concatenate training & testing subject data
# Attach "subject" column to the existing dataframe
meanstd_data$subject <- rbind(trainsubjects, testsubjects) # dataframe

# Aggregate data per activity, per subject and name the first two columns of the
# resultset as "activity" & "subject"
# We don't take the "activity" and "subject" columns in the resultset to avoid NA
agg_mean_act_subj <- aggregate(meanstd_data[, -(67:68)], 
                               list(activity = meanstd_data$activity[,1],
                                    subject = meanstd_data$subject[,1]), mean)

# Write the file with column names but no name for the rows.
write.table(agg_mean_act_subj, file = "activity_subject_tidy.txt",
          row.names = FALSE)

##################### End of run_analysis.R ##################### 
