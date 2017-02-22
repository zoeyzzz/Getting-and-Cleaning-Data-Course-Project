# Getting-and-Cleaning-Data-Course-Project
Introduction

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

Data

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Assignment

You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
First, read data using read.table

library(plyr)
library(knitr)
xtrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/Y_train.txt")
subjectrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/subject_train.txt")
xtext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/X_test.txt")
ytext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/Y_test.txt")
subjectext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/subject_test.txt")
activity<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/activity_labels.txt")
feature<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/features.txt")
Combine the train data and text data together by row for every category (subjects, activities and features). Name the subjects dataset, activities dataset and features dataset. then combine the 3 dataset together by column, the new data set will have 563 variables.

subjects<-rbind(subjectrain,subjectext)
x<-rbind(xtrain,xtext)
y<-rbind(ytrain,ytext)
names(subjects)<-c("subjects")
names(y)<-c("activity")
names(x)<-feature$V2
data<-cbind(x,subjects,y)
Extracts only the measurements on the mean and standard deviation for each measurement.

Extract the mean and standard by the feature name dataset first, then subset the original dataset we get from Q1 by the name sebset

featuresmeanstd <- grep("mean\\(\\)|std\\(\\)",feature$V2,value=TRUE)
extractedname<-c(as.character(featuresmeanstd),"subjects","activity")
subdata1<-subset(data,select = extractedname)
Uses descriptive activity names to name the activities in the data set

change the activity code to activity name based on the description in “activity_lable.txt”

subdata1$activity[subdata1$activity == 1] <- "Walking"
subdata1$activity[subdata1$activity == 2] <- "Walking Upstairs"
subdata1$activity[subdata1$activity == 3] <- "Walking Downstairs"
subdata1$activity[subdata1$activity == 4] <- "Sitting"
subdata1$activity[subdata1$activity == 5] <- "Standing"
subdata1$activity[subdata1$activity == 6] <- "Laying"
Appropriately labels the data set with descriptive variable names.

change thevariable names based on the description in feature_info to make it more easy to read

names(subdata1)<-gsub("^t", "time", names(subdata1))
names(subdata1)<-gsub("^f", "frequency", names(subdata1))
names(subdata1)<-gsub("Acc", "Accelerometer", names(subdata1))
names(subdata1)<-gsub("Gyro", "Gyroscope", names(subdata1))
names(subdata1)<-gsub("Mag", "Magnitude", names(subdata1))
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

first take average of each variable for each activity and each subject, then use write.table to output the “tidydata.txt”

Datafinal<-aggregate(. ~subjects + activity, subdata1, mean)
Datafinal<-Datafinal[order(Datafinal$subjects,Datafinal$activity),]
variable.names(Datafinal)
##  [1] "subjects"                                          
##  [2] "activity"                                          
##  [3] "timeBodyAccelerometer-mean()-X"                    
##  [4] "timeBodyAccelerometer-mean()-Y"                    
##  [5] "timeBodyAccelerometer-mean()-Z"                    
##  [6] "timeBodyAccelerometer-std()-X"                     
##  [7] "timeBodyAccelerometer-std()-Y"                     
##  [8] "timeBodyAccelerometer-std()-Z"                     
##  [9] "timeGravityAccelerometer-mean()-X"                 
## [10] "timeGravityAccelerometer-mean()-Y"                 
## [11] "timeGravityAccelerometer-mean()-Z"                 
## [12] "timeGravityAccelerometer-std()-X"                  
## [13] "timeGravityAccelerometer-std()-Y"                  
## [14] "timeGravityAccelerometer-std()-Z"                  
## [15] "timeBodyAccelerometerJerk-mean()-X"                
## [16] "timeBodyAccelerometerJerk-mean()-Y"                
## [17] "timeBodyAccelerometerJerk-mean()-Z"                
## [18] "timeBodyAccelerometerJerk-std()-X"                 
## [19] "timeBodyAccelerometerJerk-std()-Y"                 
## [20] "timeBodyAccelerometerJerk-std()-Z"                 
## [21] "timeBodyGyroscope-mean()-X"                        
## [22] "timeBodyGyroscope-mean()-Y"                        
## [23] "timeBodyGyroscope-mean()-Z"                        
## [24] "timeBodyGyroscope-std()-X"                         
## [25] "timeBodyGyroscope-std()-Y"                         
## [26] "timeBodyGyroscope-std()-Z"                         
## [27] "timeBodyGyroscopeJerk-mean()-X"                    
## [28] "timeBodyGyroscopeJerk-mean()-Y"                    
## [29] "timeBodyGyroscopeJerk-mean()-Z"                    
## [30] "timeBodyGyroscopeJerk-std()-X"                     
## [31] "timeBodyGyroscopeJerk-std()-Y"                     
## [32] "timeBodyGyroscopeJerk-std()-Z"                     
## [33] "timeBodyAccelerometerMagnitude-mean()"             
## [34] "timeBodyAccelerometerMagnitude-std()"              
## [35] "timeGravityAccelerometerMagnitude-mean()"          
## [36] "timeGravityAccelerometerMagnitude-std()"           
## [37] "timeBodyAccelerometerJerkMagnitude-mean()"         
## [38] "timeBodyAccelerometerJerkMagnitude-std()"          
## [39] "timeBodyGyroscopeMagnitude-mean()"                 
## [40] "timeBodyGyroscopeMagnitude-std()"                  
## [41] "timeBodyGyroscopeJerkMagnitude-mean()"             
## [42] "timeBodyGyroscopeJerkMagnitude-std()"              
## [43] "frequencyBodyAccelerometer-mean()-X"               
## [44] "frequencyBodyAccelerometer-mean()-Y"               
## [45] "frequencyBodyAccelerometer-mean()-Z"               
## [46] "frequencyBodyAccelerometer-std()-X"                
## [47] "frequencyBodyAccelerometer-std()-Y"                
## [48] "frequencyBodyAccelerometer-std()-Z"                
## [49] "frequencyBodyAccelerometerJerk-mean()-X"           
## [50] "frequencyBodyAccelerometerJerk-mean()-Y"           
## [51] "frequencyBodyAccelerometerJerk-mean()-Z"           
## [52] "frequencyBodyAccelerometerJerk-std()-X"            
## [53] "frequencyBodyAccelerometerJerk-std()-Y"            
## [54] "frequencyBodyAccelerometerJerk-std()-Z"            
## [55] "frequencyBodyGyroscope-mean()-X"                   
## [56] "frequencyBodyGyroscope-mean()-Y"                   
## [57] "frequencyBodyGyroscope-mean()-Z"                   
## [58] "frequencyBodyGyroscope-std()-X"                    
## [59] "frequencyBodyGyroscope-std()-Y"                    
## [60] "frequencyBodyGyroscope-std()-Z"                    
## [61] "frequencyBodyAccelerometerMagnitude-mean()"        
## [62] "frequencyBodyAccelerometerMagnitude-std()"         
## [63] "frequencyBodyBodyAccelerometerJerkMagnitude-mean()"
## [64] "frequencyBodyBodyAccelerometerJerkMagnitude-std()" 
## [65] "frequencyBodyBodyGyroscopeMagnitude-mean()"        
## [66] "frequencyBodyBodyGyroscopeMagnitude-std()"         
## [67] "frequencyBodyBodyGyroscopeJerkMagnitude-mean()"    
## [68] "frequencyBodyBodyGyroscopeJerkMagnitude-std()"
write.table(Datafinal, file = "tidydata.txt",row.name=FALSE)
