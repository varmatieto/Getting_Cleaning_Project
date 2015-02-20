
## A Cookbook for the "Getting and Cleaning Data Project"


### Description
This text provides additional information about the variables, data and transformations used in the project  related with the "Getting and Cleaning Data" Coursera course, by Johns Hopkins.

### Source Data

A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


### Data Set Information

The data are related with an experiment carried out with a group of `30 volunteers`  within an age bracket of 19-48 years.   

Each person performed `6 activities` (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on the waist. 

Using its embedded accelerometer and gyroscope, the experiment captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.

Unzipping the source data, that can be [found here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), I got 28 datasets mentioned below in alphabetic order:


[1] "activity_labels.txt"                         
[2] "features.txt"                                
[3] "features_info.txt"                           
[4] "README.txt"                                  
[5] "test/Inertial Signals/body_acc_x_test.txt"   
[6] "test/Inertial Signals/body_acc_y_test.txt"   
[7] "test/Inertial Signals/body_acc_z_test.txt"   
[8] "test/Inertial Signals/body_gyro_x_test.txt"  
[9] "test/Inertial Signals/body_gyro_y_test.txt"  
[10] "test/Inertial Signals/body_gyro_z_test.txt"  
[11] "test/Inertial Signals/total_acc_x_test.txt"  
[12] "test/Inertial Signals/total_acc_y_test.txt"  
[13] "test/Inertial Signals/total_acc_z_test.txt"  
[14] "test/subject_test.txt"                       
[15] "test/X_test.txt"                             
[16] "test/y_test.txt"                             
[17] "train/Inertial Signals/body_acc_x_train.txt"    
[18] "train/Inertial Signals/body_acc_y_train.txt"     
[19] "train/Inertial Signals/body_acc_z_train.txt"    
[20] "train/Inertial Signals/body_gyro_x_train.txt"      
[21] "train/Inertial Signals/body_gyro_y_train.txt"  
[22] "train/Inertial Signals/body_gyro_z_train.txt"  
[23] "train/Inertial Signals/total_acc_x_train.txt"  
[24] "train/Inertial Signals/total_acc_y_train.txt"  
[25] "train/Inertial Signals/total_acc_z_train.txt"  
[26] "train/subject_train.txt"                       
[27] "train/X_train.txt"                           
[28] "train/y_train.txt"    


### Datasets Information

Lets have a look at the different datasets already unzipped.

[1] "activity_labels.txt"  contains labels for the `6 activities` performed;


[2] "features.txt"  contains the complete list of variables of each feature vector, it consists of `561 features` ;


[3] "features_info.txt"   contains how the 561 different features come from the accelerometer and gyroscope 3-axial raw signals;


[4] "README.txt" contains the reference to authors and basic guidelines to intepret all the staff;                         

Then follows 24 datasets referring to `training` and  `test` data. Data has been randomly partitioned into the two mentioned sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

All `Inertial Signals`,  both in training and test sets, `has NOT been considered`.

[14] "test/subject_test.txt"  contains 2947 obs. of  1 variable: the subject, expressed as a number, involved in the single measure = observation;


[15] "test/X_test.txt"  contains 2947 obs. of  561 variables  measured: the feature vector with time and frequency domain variables;


[16] "test/y_test.txt"  contains 2947 obs. of  1 variable: the activity label;


[26] "train/subject_train.txt"  contains 7352 obs. of  1 variable: the subject, expressed as a number, involved in the single measure;


[27] "train/X_train.txt"   contains 7352 obs. of  561 variables  measured: the feature vector with time and frequency domain variables;


[28] "train/y_train.txt" contains 7352 obs. of  1 variable: the activity label;



### Script description

Here are outlined the steps performed in the R script included in the repo.


#### 1. Loading data

After some commands, used to set files and directory names (everything is under a the /data directory), X, Y and subjects datasets are loaded both for the training and test set.
Some basic commands (such as table and str) are run in order to check if my understanding is OK. 

#### 2. Merging data

For each of the three dataset (X, Y and subjects ) a merge of the training and the test sets creates three datasets (called x_data, y_data, subject_data). Each dataset contains 10299 obs.

#### 3. Extract proper features

In order to extract only the measurements on the mean and standard deviation for each measurement:

- first I got labels with mean() or std() in the activity_labels file; it consists of 66 variables;

- second I subsetted the x_data with only the identified labels and correct the column names, calling the resulting file as x_data_sub;

- third I added a column in the y_data with the correct activity names, taken from the activity_labels file.


#### 4. Make a single features dataset 


Putting together the  x_data_sub with y_data and subject_data now I have a single dataset (called all_data) with all features concerning mean() or std() only plus the activity label and subject involved . A dataset of 10299 obs. in 68 variables. 

#### 5. Create a tidy data set with the average of each variable

Using the all_data dataset, I applied the `plyr` package to calculate the average of all the variables for each activity label and subject involved. The result is a dataset with 6 for 30 =180 observations and 66 variables.

Then, as last step, I melt down this data by subject and activity reporting for each variable the its name and the its value.

The result is a dataset, which I consider a tidy dataset,  with '6 for 30 for 66' = 11880 observations and 4 basic variables.

The result has been saved in the `averages_data.txt` text file.
