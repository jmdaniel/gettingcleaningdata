
### README.md
####  
### <span style="color:blue">Getting & Cleaning Data</span>
#### *Assigment Week 4 - February 2nd 2016*
###
> This README.md file includes the description of the various files and scripts used for this assignment.

####Subject of the study: Human Activity Recognition Using Smartphones Dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. 

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

***

####1. **Data source used for analysis:**

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

####2. **Main content of the dataset**
Descriptions:

- activity_labels.txt: names of the 6 registered activities
- features.txt: list of 561 features of the dataset

Dataset:

- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': training data. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- '/test/subject_test.txt': testing data. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

Notes:

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

####2. List of files and scripts used for this assignment
#####2.1 **Readme file: this file**
```{r}
README.md
```

#####2.2 **Script used to get the data**
```{r}
get_smartphone_data.R
```

This script download the "Human Activity Recognition Using Smartphones Dataset" and stores and extract it into a subdirectory "./data/".
The data to analyse read from "./data/UCI HAR Dataset/" directory.

#####2.3 **Script used to process & analyse the data**
```{r}
run_analysis.R
```

- This script performs the data analysis on the dataset through the following 5 steps:

   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each measurement.
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names.
   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#####2.4 **Explanation of each data transformation step in the analysis**

```{r}
CodeBook.md
```

This file describes each step performed on the dataset to analyse it, and how we produce the final tidy dataset in the current directory.

End of README.md

