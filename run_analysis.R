# the script downloads data from web and  extract the zip content in a working directory. Then it reads data to the current environment

library(RCurl)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=fileUrl, destfile="zip_folder.zip", method="curl")
unzip("zip_folder.zip")

train <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/train/X_train.txt"))
train_activity <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/train/y_train.txt"))
train_subject <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/train/subject_train.txt"))
test <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/test/X_test.txt"))
test_activity <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/test/y_test.txt"))
test_subject <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/test/subject_test.txt"))
features <- read.table(file=paste0(getwd(),"/UCI HAR Dataset/features.txt"))

# union operations (merging vertically) is used to combine train and test data sets
# colnames are given the complete names
# two columns indicating subject and activity are added to the main set

complete_set <- rbind(cbind(test_subject, test_activity,test), cbind(train_subject, train_activity, train))
colnames(complete_set) <- c("subject","activity", as.character(features[,2]))

# names are converted to the format operatable by r
colnames(complete_set) <- make.names(colnames(complete_set))


# columns that do not indicate mean or st.dev are removed
complete_set <- complete_set[,c(1,2,grep("mean()|std()", colnames(complete_set)))]
colnames(complete_set) <- make.names(colnames(complete_set))


# loop structure and apply() function are used to calculate the average of each variable for each activity and subject 
activity_subject <- unique(complete_set[,1:2])
activity_subject <- activity_subject[order(activity_subject$activity, activity_subject$subject),]

second_set <- data.frame()
for(i in 1:nrow(activity_subject)){
    activity <- activity_subject$activity[i]
    subject <- activity_subject$subject[i]
    subset <- complete_set[(complete_set$activity==activity)&(complete_set$subject==subject), 3:81]
    avg_calc <- apply(subset, 2, mean, na.rm=TRUE)
    line <- data.frame(activity, subject, t(avg_calc))
    if(nrow(second_set)==0){second_set <- line}
    else{ second_set <- rbind(second_set, line)}
}
output <- second_set

# the final output is called "second_set"
