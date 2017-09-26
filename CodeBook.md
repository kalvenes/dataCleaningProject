# dataCleaningProject Code Book

The input to this project is a subest of the large data set from the UCI Machine Learning Repository for wearable computing. A complete data description for the UCI Machine Learning Repository is available at UCI:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The complete data set is available on GitHub:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

We are using only a subset of the data that represent motion measurements for individual test subjects for six different activities. The data set counts 561 motion measurement variables, some measured directly, others calculated from the raw test measurements. The subset of data used in this project consists of the following files:

X_train.txt (motion observations for training session activities)
y_train.txt (actual subject activity in training sessions)
subject_train.txt (subject (participant) list for training sessions)
X_test.txt (motion observations for test session activities)
y_test.txt (actual subject activity in test sessions)
subject_test.txt (subject (participant) list for test sessions)
activity_labels.txt (activity labels) features.txt (variable names)

The total set of measurements has been split into a training set and a test set by the UCI researchers. The files above are named accordingly. The files subject_train.txt and subject_test.txt, are column vectors that identify the individual subject for each observation in the files X_train.txt, y_train.txt, X_test.txt, and y_test.txt, respectively. The files y_train.txt and y_test.txt are column vectors that identify the specific activity performed when the measurements in X_train.txt and X_test.txt were collected. When combined in order, subject_train.txt, y_train.txt, and X_train.txt form a complete data set for the training set observations. Each row in the combined data set consists of a subject ID, an activity ID, and 561 measurements for this observation. There are several measurements per subject ID, activity ID combination. The data set for the test observations is organized in the same manner.

Combined, the training and test data have 30 subject IDs and 6 activity IDs. The activity IDs are matched to activity names in the file activity_labels.txt. The activties are: LAYING, SITTING, STANDING, WALKING, WALKING DOWNSTAIRS, and WALKING UPSTAIRS. The 561 variable names are omitted here, but are readily available from the data repository URL provided above.

The data transformation performed in the script run_analysis.R consists of the following steps:

1. Read the 8 data files listed above into R objects
        subjectTrain <- subject_train.txt
        trainX <- X_train.txt
        trainY <- y_train.txt
        subjectTest <- subject_test.txt
        testX <- X_test.txt
        testY <- y_test.txt
        activityLabels <- activity_labels.txt
        varNames <- features.txt
2. Merge the training and test data:
        ttX <- trainX, testX
        ttY <- trainY, testY
        ttSubject <- subjectTrain, subjectTest
3. Replace ttY activity IDs with the corresponding activity name from activityLabels using an inner_join
4. Create column names for ttSubject ("subjectId") and ttY ("activity")
5. Create variable names in the ttX table based on the varNames object
        Convert the second column of the varNames object to a character vector. The first column (row numbers) is discarded.
        Remove invalid characters for data frame column names --- left parenthesis ( and right parenthesis ) using gsub
        Assign the resulting character vector to the column names of ttX
6. Merge ttSubject, ttY, and ttX
        allData <- ttSubject, ttY, ttX
7. Identify the variable columns that represent mean and standard deviation measurements and discard the other variables
        Columns in allData are identified using grep("subjectId|activity|mean|std"). This will pick up
                subjectId column (first column in allData)
                activity (second column in allData)
                all columns with labels that contain "mean" or "std" (the variable names for mean and standard deviation)
8. Calculate the mean for all <subjectId, activity, variable> combinations.
        The result is a table, msData withh 180 rows: 30 subjects times 6 activities and 55 columns (subjectId, activity, 53 variables)
        Each of the 180 times 53 values represent the mean of the measurements for each <subjectID, actitivy, variable> combination in the original data set. The retained variable names are listed below.
9. The msData table is saved to a file named "avgBySubjectActivity.txt"


Variables in the file "avgBySubjectActivity.txt"

subjectId, activity, tBodyAcc-mean-X, tBodyAcc-mean-Y, tBodyAcc-mean-Z, tBodyAcc-std-X, tBodyAcc-std-Y,
tBodyAcc-std-Z, tGravityAcc-mean-X, tGravityAcc-mean-Y, tGravityAcc-mean-Z, tGravityAcc-std-X, tGravityAcc-std-Y,
tGravityAcc-std-Z, tBodyAccJerk-mean-X, tBodyAccJerk-mean-Y, tBodyAccJerk-mean-Z, tBodyAccJerk-std-X, tBodyAccJerk-std-Y,
tBodyAccJerk-std-Z, tBodyGyro-mean-X, tBodyGyro-mean-Y, tBodyGyro-mean-Z, tBodyGyro-std-X, tBodyGyro-std-Y, tBodyGyro-std-Z,
tBodyGyroJerk-mean-X, tBodyGyroJerk-mean-Y, tBodyGyroJerk-mean-Z, tBodyGyroJerk-std-X, tBodyGyroJerk-std-Y,
tBodyGyroJerk-std-Z, tBodyAccMag-mean, tBodyAccMag-std, tGravityAccMag-mean, tGravityAccMag-std, tBodyAccJerkMag-mean,
tBodyAccJerkMag-std, tBodyGyroMag-mean, tBodyGyroMag-std, tBodyGyroJerkMag-mean, tBodyGyroJerkMag-std, fBodyAcc-mean-X,
fBodyAcc-mean-Y, fBodyAcc-mean-Z, fBodyAcc-std-X, fBodyAcc-std-Y, fBodyAcc-std-Z, fBodyAcc-meanFreq-X, fBodyAcc-meanFreq-Y,
fBodyAcc-meanFreq-Z, fBodyAccJerk-mean-X, fBodyAccJerk-mean-Y, fBodyAccJerk-mean-Z, fBodyAccJerk-std-X, fBodyAccJerk-std-Y,
fBodyAccJerk-std-Z, fBodyAccJerk-meanFreq-X, fBodyAccJerk-meanFreq-Y, fBodyAccJerk-meanFreq-Z, fBodyGyro-mean-X,
fBodyGyro-mean-Y, fBodyGyro-mean-Z, fBodyGyro-std-X, fBodyGyro-std-Y, fBodyGyro-std-Z, fBodyGyro-meanFreq-X,
fBodyGyro-meanFreq-Y, fBodyGyro-meanFreq-Z, fBodyAccMag-mean, fBodyAccMag-std, fBodyAccMag-meanFreq,
fBodyBodyAccJerkMag-mean, fBodyBodyAccJerkMag-std, fBodyBodyAccJerkMag-meanFreq, fBodyBodyGyroMag-mean, fBodyBodyGyroMag-std,
fBodyBodyGyroMag-meanFreq, fBodyBodyGyroJerkMag-mean, fBodyBodyGyroJerkMag-std, fBodyBodyGyroJerkMag-meanFreq
