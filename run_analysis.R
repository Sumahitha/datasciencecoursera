################################################################################
#   Description     : R script to clean data in course Project 2 of course
#   Goal            : Clean the data and produce a data set as specified
#   Source & Steps  : Data sources and steps to complete are listed below
################################################################################



################################################################################
#   Steps 1 & 4:
#   Merges the training and the test sets to create one data set.
#   Appropriately labels the data set with descriptive activity names. 
################################################################################

##  Get the data set and unzip to working directory
if(!file.exists("./data"))
{
    dir.create("./data")    
}
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/FUCIDataset.zip")
unzip("./data/FUCIDataset.zip",exdir="./data")

## Read common descriptor data such as feature names and activity labels
## into data frames
features <- read.table("./data/UCI HAR Dataset/features.txt")
xnames <- features[,2]

## Appropriately label the data set with cleaner names
xnames <- gsub("-mean()", ".Mean",xnames,fixed=TRUE)
xnames <- gsub("-std()",".StandardDeviation",xnames,fixed=TRUE)
xnames <- gsub("-mad()",".MedianAbsoluteDeviation",xnames,fixed=TRUE)
xnames <- gsub("-max()", ".Maximum",xnames,fixed=TRUE)
xnames <- gsub("-min()",".Minimum",xnames,fixed=TRUE)
xnames <- gsub("-sma()",".SignalMagnitudeArea",xnames,fixed=TRUE)
xnames <- gsub("-energy()",".Energy",xnames,fixed=TRUE)
xnames <- gsub("-iqr()",".InterquartileRange",xnames,fixed=TRUE)
xnames <- gsub("-entropy()",".SignalEntropy",xnames,fixed=TRUE)
xnames <- gsub("-arCoeff()",".AutorregresionCoefficients",xnames,fixed=TRUE)
xnames <- gsub("-correlation()",".CorrelationCoefficient",xnames,fixed=TRUE)
xnames <- gsub("-maxInds()",".LargestMagnitudeIndex",xnames,fixed=TRUE)
xnames <- gsub("-meanFreq()",".MeanFrequency",xnames,fixed=TRUE)
xnames <- gsub("-skewness()",".Skewness",xnames,fixed=TRUE)
xnames <- gsub("-kurtosis()",".Kurtosis",xnames,fixed=TRUE)
xnames <- gsub("-bandsEnergy()",".BandsEnergy",xnames,fixed=TRUE)
xnames <- gsub("angle","Angle",xnames,fixed=TRUE)
xnames <- gsub(",",".",xnames,fixed=TRUE)
xnames <- gsub("-",".",xnames,fixed=TRUE)
xnames <- gsub("Angle(","Angle.",xnames,fixed=TRUE)
xnames <- gsub("Mean)","Mean",xnames,fixed=TRUE)
xnames <- gsub("gravity)","gravity",xnames,fixed=TRUE)

## Read the test and train data for 
##      X (measurements/features)
##      Y (Activity)
##      Subject (Subject codes)

# Read all training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
sub_train<- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read all test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## Combine the test and train data

# Combine all feature data into one data frame and assign column names
x_data <- rbind(x_train, x_test)
colnames(x_data) <- xnames

# Combine all activity data into one data frame and assign column names
y_data <- rbind(y_train, y_test)
colnames(y_data) <- c("Activity")

# Combine all subjects into one data frame and assign column names
subjects <- rbind(sub_train,sub_test)
colnames(subjects) <- c("Subject")


################################################################################
#   Step 2:
#   Extracts only the measurements on the mean and 
#   standard deviation for each measurement. 
################################################################################

## Extract only Mean and Standard Deviation columns from features

meanVec <- grepl(".Mean",as.character(names(x_data)),fixed=TRUE)
meanFVec<- grepl(".MeanFrequency",as.character(names(x_data)),fixed=TRUE)
meanVec <- xor(meanVec,meanFVec)
stdVec <- grepl(".StandardDeviation",as.character(names(x_data)),fixed=TRUE)

vec <- meanVec | stdVec

x_mean_std_data <- subset(x_data,select=vec)


## Create the data set with only the specific columns
complete_data <- cbind(subjects,y_data,x_mean_std_data)


## Find the averages per activity, per subject
aggdata <-aggregate(complete_data, 
                    by=list(complete_data$Subject,complete_data$Activity),
                    FUN=mean, na.rm=TRUE)



################################################################################
#   Step 3:
#   Uses descriptive activity names to name the activities in the data set
################################################################################

## Convert the activity ID into the matchin Activitiy Label

activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("ID","Activity.Name")

y_labels <- as.character(activity[match(aggdata$Activity,activity$ID),
                                  'Activity.Name'])
y_labels <- as.data.frame(y_labels,stringsAsFactors=FALSE)
colnames(y_labels) <- c("Activity.Label")


################################################################################
#   Step 5:
#   Creates a second, independent tidy data set with the average of 
#   each variable for each activity and each subject. 
################################################################################

tidyData <- cbind(aggdata[,3],y_labels,aggdata[,5:70])

write.table(tidyData,file="CourseProjectTidyData.txt")



