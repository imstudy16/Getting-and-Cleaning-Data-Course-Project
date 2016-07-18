#Download the file and put the file in the data folder
#if the folder does not exist, that create it
install.packages("plyr")
library(plyr)
if(!file.exists("./data")){dir.create("./data")}
if(!file.exists("./result")){dir.create("./result")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read the files
## test data:
XTestData<- read.table("./data/UCI HAR Dataset/test/X_test.txt")
YTestData<- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
SubjectTestData <-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrainData<- read.table("./data/UCI HAR Dataset/train/X_train.txt")
YTrainData<- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
SubjectTrainData <-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

## features and activity
featuresData<-read.table("./data/UCI HAR Dataset/features.txt")
activityData<-read.table("./data/UCI HAR Dataset/activity_labels.txt")

#1. Merges the training and the test sets to create one data set.
XData<-rbind(XTestData, XTrainData)
YData<-rbind(YTestData, YTrainData)
SubjectData<-rbind(SubjectTestData, SubjectTrainData)

#Dimensions of the initial data
dim(XTestData)
dim(XTrainData)

#Dimension of the merge X data
dim(XData)

#Dimensions of the initial data
dim(YTestData)
dim(YTrainData)

#Dimension of the merge Y data
dim(YData)

#Dimensions of the initial subject data
dim(SubjectTestData)
dim(SubjectTrainData)

#Dimensions of the merge subject data
dim(SubjectData)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

meanStd <- grep("-mean\\(\\)|-std\\(\\)", featuresData[, 2])
XmeanStd <- XData[, meanStd]

#3. Uses descriptive activity names to name the activities in the data set

#Merge id of activity names and data set
XYData <- cbind(YData, XData)

#Give new names for ids of merging activity names and data set
names(XYData)[1] <- "id_activity"
names(activityData)[1] <- "id"

#Merge of activity names and data set
ActivityXYData = merge(activityData, XYData, by.x = "id", by.y = "id_activity", all = TRUE)

#Change name of column on "Activity" name
names(ActivityXYData)[2] <- "Activity"

#Write data in the file
View(ActivityXYData)
write.table(ActivityXYData, file = "./result/ActivitiesName.csv",row.name=FALSE)

#4. Appropriately labels the data set with descriptive variable names

#Transform matrix of features
trancformFeaturesData <- t(featuresData)

#Give new names for data set
names(XData) <- trancformFeaturesData[2,]

#Write data in the file
View(XData)
write.table(XData, file = "./result/LabelsDataSet.csv",row.name=FALSE)

#5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject

#Merge id of activity names and data set
SubjectXFeaturesData <- cbind(SubjectData, XData)

#Change name of column on "Subject" name
names(SubjectXFeaturesData)[1] <- "Subject"
View(SubjectXFeaturesData)

#Find means of each variable for each activity and each subject
SplitSubjectXFeaturesData <- split(SubjectXFeaturesData, SubjectXFeaturesData$Subject)
MeansSplitSubjectXFeaturesData <- lapply(SplitSubjectXFeaturesData, function(x) colMeans(x))

#Write data in the file
View(MeansSplitSubjectXFeaturesData)
write.table(MeansSplitSubjectXFeaturesData, file = "./result/tidy_data_set.csv",row.name=FALSE)


