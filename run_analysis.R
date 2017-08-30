
setwd("C:/Users/Ravi Patel/Desktop/Data Science/Obtaining and cleaning data/Project")
#load necessary libraries
library(dplyr)
library(stringr) 
library(utils)
#download and unzip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","project1.zip")
unzip("project1.zip")

#load the data into R by moving between the directories
setwd("C:/Users/Ravi Patel/Desktop/Data Science/Obtaining and cleaning data/Project/UCI HAR Dataset/train")
subject_train<-read.table("subject_train.txt")
x_train<-read.table("x_train.txt")
y_train<-read.table("y_train.txt")
setwd("C:/Users/Ravi Patel/Desktop/Data Science/Obtaining and cleaning data/Project/UCI HAR Dataset/train/Inertial Signals")
trainList= list.files(pattern = ".*.txt")
trainData= lapply(trainList, function(x) read.table(x))
setwd("C:/Users/Ravi Patel/Desktop/Data Science/Obtaining and cleaning data/Project/UCI HAR Dataset/test")
subject_test<-read.table("subject_test.txt")
x_test<-read.table("x_test.txt")
y_test<-read.table("y_test.txt")
setwd("C:/Users/Ravi Patel/Desktop/Data Science/Obtaining and cleaning data/Project/UCI HAR Dataset/test/Inertial Signals")
testList= list.files(pattern = ".*.txt")
testData= lapply(testList, function(x) read.table(x))
setwd("..")
setwd("..")

#binding columns and rows
test_all<-cbind(subject_test,y_test,x_test)
train_all<-cbind(subject_train,y_train,x_train)
all<-rbind(test_all,train_all)
features<-read.table("features.txt")
colnames(all)[1]<-"subject"
colnames(all)[2]<-"activity"
colnames(all)[3:563]<-as.character(features[,2])

#pulling out means and std
#had trouble coercing all into a tbl so did this using base package, was actually easier than anticipated
simple_all<-cbind(all[,1:8],all[,43:48],all[83:88])

#changing all the activity names
activities<-read.table("activity_labels.txt")
simple_all$activity<-factor(simple_all$activity,levels=activities[,1],labels = activities[,2])

#Appropriately labels the data set with descriptive variable names. AKA changing the column names
colnames(simple_all)[3]<-"time_body_acceleration_mean_X"
colnames(simple_all)[4]<-"time_body_acceleration_mean_Y"
colnames(simple_all)[5]<-"time_body_acceleration_mean_Z"
colnames(simple_all)[6]<-"time_body_acceleration_standard_deviation_X"
colnames(simple_all)[7]<-"time_body_acceleration_standard_deviation_Y"
colnames(simple_all)[8]<-"time_body_acceleration_standard_deviation_Z"
colnames(simple_all)[9]<-"time_gravity_acceleration_mean_X"
colnames(simple_all)[10]<-"time_gravity_acceleration_mean_Y"
colnames(simple_all)[11]<-"time_gravity_acceleration_mean_Z"
colnames(simple_all)[12]<-"time_gravity_acceleration_standard_deviation_X"
colnames(simple_all)[13]<-"time_gravity_acceleration_standard_deviation_Y"
colnames(simple_all)[14]<-"time_gravity_acceleration_standard_deviation_Z"
colnames(simple_all)[15]<-"time_jerk_acceleration_mean_X"
colnames(simple_all)[16]<-"time_jerk_acceleration_mean_Y"
colnames(simple_all)[17]<-"time_jerk_acceleration_mean_Z"
colnames(simple_all)[18]<-"time_jerk_acceleration_standard_deviation_X"
colnames(simple_all)[19]<-"time_jerk_acceleration_standard_deviation_Y"
colnames(simple_all)[20]<-"time_jerk_acceleration_standard_deviation_Z"

#From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.
#This involves some melt/cast steps
library(reshape2)
library(tidyr)
#united_all<-unite(simple_all, col = "sub-act",subject:activity)
melt_all<-melt(simple_all, id.vars = c("subject","activity"))
tidy_all<-dcast(melt_all, fun.aggregate = mean, subject+activity~variable)

#write the data to a .txt file
write.table(tidy_all, file="tidy.txt")
