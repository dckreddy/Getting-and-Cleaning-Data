## Loading Libraries 

library(plyr) 
library(reshape2)

## Import the test data 

X_test<-read.table("./UCI HAR Dataset/test/X_test.txt") 
Y_test<-read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt") 
    
## Import the training data 
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt") 
Y_train<-read.table("./UCI HAR Dataset/train/y_train.txt") 
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt") 
    
## 1. Merge the training and test sets to create one data set. 
 
## Combine the X data, Y data, and subject row identification into full versions of each 
X_full<-rbind(X_test, X_train) 
Y_full<-rbind(Y_test, Y_train) 
subject_full<-rbind(subject_test, subject_train) 
 
## Now the data frames are joined, it's worth naming the columns in x_full from features.txt 
features <- read.table("./UCI HAR Dataset/features.txt") 
colnames(X_full)<-features[,2] 
 

## 2. Extract only the measurements on the mean and standard deviation for each measurement 
    
rightcols<- grepl("mean()",colnames(X_full)) | grepl("std()",colnames(X_full)) 
 
X_mean_std <- X_full[,rightcols] 

## 3. Uses descriptive activity names to name the activities in the data set 
    
activities<-read.table("./UCI HAR Dataset/activity_labels.txt") 

Y_factor <- as.factor(Y_full[,1]) 
Y_factor <- mapvalues(Y_factor,from = as.character(activities[,1]), to = as.character(activities[,2])) 
    

## 4. Appropriately labels the data set with descriptive activity names.  

X_mean_std <- cbind(Y_factor, X_mean_std)   
colnames(X_mean_std)[1] <- "activity" 

X_mean_std <- cbind(subject_full, X_mean_std) 
colnames(X_mean_std)[1] <- "subject" 
 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

X_melt<- melt(X_mean_std,id.vars=c("subject","activity"))
Xav_tidy <- dcast(X_melt, subject + activity ~ ..., mean)
write.table(Xav_tidy, "averages_data.txt", row.name=FALSE)