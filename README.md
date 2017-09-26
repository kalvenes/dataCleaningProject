# dataCleaningProject

The purpose of this project is to read, clean, and organize a large dataset split across multiple files and prepare a cleaned data set that is ready for analysis. The project has a single script, run_Analysis.R, that reads activity files (both training and test) from the UCI Machine Learning Repository for wearable computing. The output of the script is a single file that contains a single data table with average values for all mean and standard deviation variables in the original data set, grouped by subject and activity.

The script assumes that the dataset has already been downloaded and unzipped. The data files are assumed to be in the project home directory where this script resides.

The genereal sequence of this script is as follows:

1. Read the project data files
   X_train.txt (motion observations for training session activities)
   y_train.txt (actual subject activity in training sessions)
   subject_train.txt (subject (participant) list for training sessions)
   X_test.txt (motion observations for test session activities)
   y_test.txt (actual subject activity in test sessions)
   subject_test.txt (subject (participant) list for test sessions)
   activity_labels.txt (activity labels)
   features.txt (variable names)
2. Merge training and test data sets
3. Filter observations to retain only mean and standard deviation variables (there are multiple observations per subject/activity/variable combination)
4. Label activities and variables in human-friendly terms (the original variable names from the UCI project will be retained, as will the activity names)
5. Create a separate, tidy dataset with the average of each variable for each activity and each subject (the equivalent of 3NF for databases). The data set will be saved to the project home directory as a text file named avgBySubjectActivity.txt.


A complete data description for the UCI Machine Learning Repository is available at UCI:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The complete data set is available on GitHub:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
