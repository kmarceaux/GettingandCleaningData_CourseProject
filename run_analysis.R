##Assignment is to demonstreate ability to collect, work with, and clean a 
##data set.  Week 4 of Getting and Cleaning Data


##Download files for project
if(!file.exists("./datasets")){dir.create("./datasets")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./datasets/Dataset.zip")

##Unzip dataSet and make directory
unzip(zipfile="./datasets/Dataset.zip",exdir="./datasets")



##Load test datasets, training datasets, features and activity labels.  
##All datasets needed 

test <- read.table("./datasets/UCI HAR Dataset/test/X_test.txt")

test_labels <- read.table("./datasets/UCI HAR Dataset/test/y_test.txt")

sub_test <- read.table("./datasets/UCI HAR Dataset/test/subject_test.txt")

train <- read.table("./datasets/UCI HAR Dataset/train/X_train.txt")

train_labels <- read.table("./datasets/UCI HAR Dataset/train/y_train.txt")

sub_train <- read.table("./datasets/UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./datasets/UCI HAR Dataset/features.txt")

activity_labels <- read.table("./datasets/UCI HAR Dataset/activity_labels.txt")



## Assign Column Names to datasets (descriptive variable names)

colnames(test) <- features[,2]
colnames(test_labels) <-"ActivityId"
colnames(sub_test) <- "SubjectId"

colnames(train) <- features[,2]
colnames(train_labels) <-"ActivityId"
colnames(sub_train) <- "SubjectId"

colnames (activity_labels) <- c('ActivityID', 'ActivityType') 



##This section merges the test and training datasets.
test_merged <- cbind(test_labels, sub_test, test)

train_merged <- cbind(train_labels, sub_train, train)

training_test_merged <- rbind(test_merged, train_merged)

##This section extracts only the measurements on the mean and standard deviation.
##Then creates subset of data

ColNames <- colnames(training_test_merged)

mean_and_std_measurements <- (grepl("ActivityId", ColNames) | 
                                grepl("SubjectId", ColNames) | 
                                      grepl("mean..", ColNames) | 
                                      grepl("std..", ColNames))

MeanandStd_dataset <- training_test_merged[ , mean_and_std_measurements == TRUE]


##This section adds Activity Names to the dataset
AllData_withActivities <- merge(MeanandStd_dataset, activity_labels,
                                by.x='ActivityId', by.y = 'ActivityID')


##This section creates the tidy data set with the average of each variable
##for each activity and each subject.  Also writes out the dataset per 
##submission instructions. 

Tidy_dataset <- aggregate(. ~SubjectId + ActivityType, AllData_withActivities, mean)
Tidy_dataset <- Tidy_dataset[order(Tidy_dataset$SubjectId, Tidy_dataset$ActivityId),]

write.table(Tidy_dataset, "Tidy_dataset.txt", row.names = FALSE)
                           
                          





