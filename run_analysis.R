#Step 1 (point 1)
  ##Merging the training and the test sets to create one data set.
    ##uploading files
setwd("D:/Coursera/3. Getting and Cleaning Data/Final_assignment/UCI HAR Dataset/")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
    ## joining training and test databases
JoinedDataSet <- rbind(X_train, X_test)
JoinedLabels <- rbind(y_train, y_test)
JoinedSubjects <- rbind(subject_train, subject_test)

#Step 2 (point 4)
  ## Appropriately labeling the data set
  ##with descriptive variable names. 
features <- read.table("./features.txt")
View(features)

colnames(JoinedDataSet) <- features[,2]
View(JoinedDataSet)

#Step 3 (point 3)
  ## Uses descriptive activity names
  ## to name the activities in the data set
activity_labels <- read.table("./activity_labels.txt")
View(activity_labels)
View(JoinedLabels)

library(sqldf)
LabelsDataSet <- sqldf("select activity_labels.V2 from JoinedLabels
                       left join activity_labels on JoinedLabels.V1=activity_labels.V1")
View(LabelsDataSet)

DataSetWithLabels <- cbind(LabelsDataSet, JoinedDataSet)
View(DataSetWithLabels)

#Step 4 (point 2)
  ## Extracting only the measurements on the mean
  ## and standard deviation for each measurement
        ## 'mean' & 'std'

indices <- grep("mean\\(\\)|std\\(\\))", features[,2])
OK <- indices + 1
OK

SelectedVariables <- DataSetWithLabels[, OK]
View(SelectedVariables)

CleanedData <- cbind(JoinedSubjects, LabelsDataSet, SelectedVariables)
write.table(CleanedData, "CleanedData.txt")

#Step 5 (point 5)
  ## From the data set in step 4, creates a second,
  ## independent tidy data set with the average
  ## of each variable for each activity and each subject.

View(CleanedData)
colnames(CleanedData)

means_data <- sqldf("select V1, V2, avg([tBodyAcc-mean()-X]), avg([tBodyAcc-mean()-Y]),
                    avg([tBodyAcc-mean()-Z]), avg([tGravityAcc-mean()-X]), avg([tGravityAcc-mean()-Y]), avg([tGravityAcc-mean()-Z]),
                    avg([tBodyAccJerk-mean()-X]), avg([tBodyAccJerk-mean()-Y]), avg([tBodyAccJerk-mean()-Z]), avg([tBodyGyro-mean()-X]),
                    avg([tBodyGyro-mean()-Y]), avg([tBodyGyro-mean()-Z]), avg([tBodyGyroJerk-mean()-X]), avg([tBodyGyroJerk-mean()-Y]),
                    avg([tBodyGyroJerk-mean()-Z]), avg([tBodyAccMag-mean()]), avg([tGravityAccMag-mean()]), avg([tBodyAccJerkMag-mean()]),
                    avg([tBodyGyroMag-mean()]), avg([tBodyGyroJerkMag-mean()]), avg([fBodyAcc-mean()-X]), avg([fBodyAcc-mean()-Y]),
                    avg([fBodyAcc-mean()-Z]), avg([fBodyAccJerk-mean()-X]), avg([fBodyAccJerk-mean()-Y]), avg([fBodyAccJerk-mean()-Z]),
                    avg([fBodyGyro-mean()-X]), avg([fBodyGyro-mean()-Y]), avg([fBodyGyro-mean()-Z]), avg([fBodyAccMag-mean()]),
                    avg([fBodyBodyAccJerkMag-mean()]), avg([fBodyBodyGyroMag-mean()]), avg([fBodyBodyGyroJerkMag-mean()])
                    from CleanedData
                    group by V1, V2")
View(means_data)
write.table(means_data, "means_data.txt", row.name=FALSE)
