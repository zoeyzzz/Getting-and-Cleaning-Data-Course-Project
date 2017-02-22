library(plyr)
library(knitr)
#read the data#
xtrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/Y_train.txt")
subjectrain<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/train/subject_train.txt")
xtext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/X_test.txt")
ytext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/Y_test.txt")
subjectext<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/test/subject_test.txt")
activity<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/activity_labels.txt")
feature<-read.table("/Users/yizhen/Documents/R/coursera R/coursera course 3/UCI HAR Dataset/features.txt")
str(xtrain)
str(ytrain)
str(feature)
"Merges the training and the test sets to create one data set."
subjects<-rbind(subjectrain,subjectext)
x<-rbind(xtrain,xtext)
y<-rbind(ytrain,ytext)
names(subjects)<-c("subjects")
names(y)<-c("activity")
names(x)<-feature$V2
data<-cbind(x,subjects,y)
head(data)
str(data)
"Extracts only the measurements on the mean and standard deviation for each measurement."
featuresmeanstd <- grep("mean\\(\\)|std\\(\\)",feature$V2,value=TRUE)
extractedname<-c(as.character(featuresmeanstd),"subjects","activity")
subdata1<-subset(data,select = extractedname)
str(subdata1)
"Uses descriptive activity names to name the activities in the data set"
subdata1$activity[subdata1$activity == 1] <- "Walking"
subdata1$activity[subdata1$activity == 2] <- "Walking Upstairs"
subdata1$activity[subdata1$activity == 3] <- "Walking Downstairs"
subdata1$activity[subdata1$activity == 4] <- "Sitting"
subdata1$activity[subdata1$activity == 5] <- "Standing"
subdata1$activity[subdata1$activity == 6] <- "Laying"
names(subdata1)
#Appropriately labels the data set with descriptive variable names.#
names(subdata1)<-gsub("^t", "time", names(subdata1))
names(subdata1)<-gsub("^f", "frequency", names(subdata1))
names(subdata1)<-gsub("Acc", "Accelerometer", names(subdata1))
names(subdata1)<-gsub("Gyro", "Gyroscope", names(subdata1))
names(subdata1)<-gsub("Mag", "Magnitude", names(subdata1))
names(subdata1)
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."
Datafinal<-aggregate(. ~subjects + activity, subdata1, mean)
Datafinal<-Datafinal[order(Datafinal$subjects,Datafinal$activity),]
str(Datafinal)
variable.names(Datafinal)
write.table(Datafinal, file = "tidydata.txt",row.name=FALSE)

