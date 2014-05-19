## CodeBook for run_Analysis.R

### Requirements from Assignment
The assignment requires us to take the data from the UIC source and perform 5 steps towards getting clean data

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Description of the script
1. The script walks through all the above steps 
2. Includes downloading the data from site specified
3. Reading the data into local variables using read.table()
4. Using rbind, combine the test and train data into a single data
5. For step 4, change the names of the X columns using gsub to make them more meaningful
6. Adding README.txt from the original data set for reference
7. Extract only specified columns which reduces the column count from 561 to 66
8. use the aggregate function to find the mean of all the data in the reduced set for per person, per activity

### Assumptions made
1. For Step2, 33 columns were chosen for Mean measurement and 33 columns for Standard Deviation measurement
2. MeanFrequency and Angle measurements we not included in the above set. Only mean() and std() for all measurements were considered
3. For Step 4, I assumed that this meant cleaning up the column names of the features. In order to make these column names more readable, "()" and "-" were replaced with "." and camel case notation (Ex. tBodyAcc.Mean.X)
4. Since the format of the tidy data set was not specified, I've used a .txt format similar to the original data


