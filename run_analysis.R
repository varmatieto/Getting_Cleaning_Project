# Clean up workspace
rm(list=ls())

library(plyr)
#set worrking dir


# Directories and files
uci_hard_dir <- "data/UCI HAR Dataset"
feature_file <- paste(uci_hard_dir, "/features.txt", sep = "")
activity_labels_file <- paste(uci_hard_dir, "/activity_labels.txt", sep = "")
x_train_file <- paste(uci_hard_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(uci_hard_dir, "/train/y_train.txt", sep = "")
subject_train_file <- paste(uci_hard_dir, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(uci_hard_dir, "/test/X_test.txt", sep = "")
y_test_file  <- paste(uci_hard_dir, "/test/y_test.txt", sep = "")
subject_test_file <- paste(uci_hard_dir, "/test/subject_test.txt", sep = "")

ls()

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")


unzip(zipfile="./data/Dataset.zip",exdir="./data")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

# "activity_labels_file" "feature_file"        
#3] "subject_test_file"    "subject_train_file"  
#5] "uci_hard_dir"         "x_test_file"         
#7] "x_train_file"         "y_test_file"         
#9] "y_train_file" 



# Load raw data

# X files contains for each obs measures on 561 different features 
# Y files contains for each obs one of the 6 different activities
# subject files contains for each obs one of the 30 different subjects


x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
str(x_train) # data.frame':    7352 obs. of  561 variables
str(y_train) # data.frame':    7352 obs. of  1 variable:
str(subject_train) #'data.frame':    7352 obs. of  1 variable:

table (y_train$V1) # there are six different activities
length (table (subject_train$V1)) # there are 21 different subjects

x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)

str(x_test, vec.len=3, list.len=10) #'data.frame':    2947 obs. of  561 variables

length (table (subject_test$V1)) # there are 9 different subjects
table (y_test$V1) # there are six different activities

##################################################################
# 2. Merges the training and the test sets to create one data set.
##################################################################

# create 'x' data set
x_data <- rbind(x_train, x_test)
# create 'y' data set
y_data <- rbind(y_train, y_test)
# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

str(x_data, vec.len=3, list.len=10) # 'data.frame':    10299 obs. of  561 variables:
str(y_data, vec.len=3, list.len=10) # data.frame':    10299 obs. of  1 variable:
str(subject_data, vec.len=3, list.len=10) #'data.frame':    10299 obs. of  1 variable:


features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, 
                              col.names = c("ActivityId", "Activity"))
str(features)
features[1:30,]
str(activity_labels)

##################################################################
# 3. Extract only the measurements on the mean and standard deviation for each measurement.
##################################################################

# get only columns with mean() or std() in their names

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
length(mean_and_std_features) # 66 variables
features [mean_and_std_features,]

# subset the desired columns
x_data_sub <- x_data[, mean_and_std_features]
# correct the column names
names(x_data_sub) <- features[mean_and_std_features, 2]

str(x_data_sub, vec.len=3, list.len=10)

# Use descriptive activity names to name the activities in the data set
###############################################################################

# update values with correct activity names
y_data[, 1] <- activity_labels[y_data[, 1], 2]
# correct column name
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names
###############################################################################
# correct column name
names(subject_data) <- "subject"


#################################################################
# 4. Make a single features dataset 
##################################################################

all_data <- cbind(x_data_sub, y_data, subject_data)

str(all_data) # 'data.frame':    10299 obs. of  68 variables

#################################################################
# 4. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
##################################################################

# 66 <- 68 columns but last two (activity & subject)

averages_data_raw <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
namevariables<- as.vector (colnames(averages_data_raw)[3:68])
str(namevariables)

str (averages_data_raw, vec.len=3, list.len=10) # 'data.frame':    180 obs. of  68 variables
averages_data_raw[1:5, 1:6]

averages_data <- melt(averages_data_raw,id=c( "subject","activity"),
                           measure.vars=namevariables)

# 180*66
str (averages_data) # 'data.frame':    180 obs. of  66 variables
averages_data[order(averages_data$subject, averages_data$variable),][1:8,]
averages_data[1:8, 1:4]


write.table(averages_data, 'data/averages_data.txt', row.name=FALSE, ,sep='\t')
