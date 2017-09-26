## This script reads activity files (both training and test) from the UCI Maching Learning
## Repository for wearable computing. A complete data description is available at UCI:
##
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
##
## The complete data set is available on GitHub:
##
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## This script assumes that the dataset has already been downloaded and unzipped.The data
## files are assumed to be in the project home directory where this script resides.
##
## The genereal sequence of this script is as follows:
##
## 1. Read the project data files
##    X_train.txt (motion observations for training session activities)
##    y_train.txt (actual subject activity in training sessions)
##    subject_train.txt (subject (participant) list for training sessions)
##    X_test.txt (motion observations for test session activities)
##    y_test.txt (actual subject activity in test sessions)
##    subject_test.txt (subject (participant) list for test sessions)
## 2. Merge training and test data sets
## 3. Filter observations to retain only mean and standard deviation variables
## 4. Label activities and variables in human-friendly terms
## 5. Create a separate, tidy dataset with the average of each variable for each
##    activity and each subject (the equivalent of 3NF for databases)
##

run_analysis <- function () # no arguments are passed
      
      ## First, add the packages that facilitate data handling and cleaning

      library (dplyr)
      library (tidyr)
      library (stringr)

      ## subjectTrain/subjectTest identifies the subject for each observation ->
      ##          good first column
      ## trainY/testY identifies the actual activity for each observation ->
      ##          good second column
      ## trainX/testX holds the 561 (partially) independent variables for each observation ->
      ##          we will extract only the columns that contain mean and stdev results

      subjectTrain <- read.delim("subject_train.txt", sep = "", header = FALSE)
      trainX <- read.csv("X_train.txt", sep = "", header = FALSE)
      trainY <- read.csv("y_train.txt", sep = "", header = FALSE)
      
      subjectTest <- read.delim("subject_test.txt", sep = "", header = FALSE)
      testX <- read.csv("X_test.txt", sep = "", header = FALSE)
      testY <- read.csv("y_test.txt", sep = "", header = FALSE)
      
      activityLabels <- read.csv("activity_labels.txt", sep= "", header = FALSE)
      varNames <- read.csv("features.txt", sep = "", header = FALSE)
      
      ## Next, merge the training and testing data sets using rbind()
      ## Make sure to keep train and test data sets in the same order for all tables
      
      ttX <- rbind(trainX, testX) # single table with X variables
      ttY <- rbind(trainY, testY) # single table with activity IDs
      ttSubject <- rbind(subjectTrain, subjectTest) # single table with subject IDs
      
      ## Replace activity IDs in ttY with activity names from activityLabels
      
      ttY <- inner_join(ttY, activityLabels) # match up activity labels with IDs in new column
      ttY <- ttY[-1] # drop the column with IDs to keep only the activity labels
      
      ## Add headers to the data frames
      
      colnames(ttSubject) <- "subjectId"
      colnames(ttY) <- "activity"
      
      ## Clean up varNames so that invalid characters for data frame headers are removed
      ## gsub for string substitution works on character strings --- data frames are a
      ## problem so drop the first column of varNames and convert the second column to a
      ## character vector
      
      varNames <- as.vector(varNames$V2) # convert second column to a character vector
      varNames <- gsub("\\(", "", varNames) # remove left open parenthesis
      varNames <- gsub("\\)", "", varNames) # remove right close parenthesis
      
      colnames(ttX) <- varNames # assign variable names to the independent variables
      
      ## Gather all data in a single table (data frame)
      
      allData <- cbind.data.frame(ttSubject, ttY, ttX)
      
      ## Next, get rid of all columns that do not have mean or stdev data while retaining
      ## the subject ID and activity
      
      msData <- allData[, grep("subjectId|activity|mean|std", names(allData) )]
      
      ## Finally, create an independent table that averages the observations for each
      ## variable by subject ID and activity. The resulting table should have as many
      ## columns as msData, but only six rows (one per activity) for each subject ID.
      ## Each cell in the table is an average of the observations for any given
      ## <subjectID, activity, variable>
      
      mData <- msData %>% group_by(subjectId, activity) %>% summarise_all(mean)
      
      ## Write the resulting table to a file in the project home directory
      
      write.table(mData,"avgBySubjectActivity.txt", row.names = FALSE)
      