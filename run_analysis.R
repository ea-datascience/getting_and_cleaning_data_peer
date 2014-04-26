#
# ------------------------------------------------------------------------------------------
#
# First exercise

# Loading the test dataset
X_Test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_Test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)


# Loading the train dataset
X_Train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_Train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train//subject_train.txt", header = FALSE)


# Loading activities labels
activities_labels <- read.table("UCI HAR Dataset/activity_labels.txt")    
colnames(activities_labels) <- c("indices","activity_name")


# Loading the features names
features_names <- read.table("UCI HAR Dataset/features.txt")    

# Combining the two datasets after being filtered
mergeDataSets <- function(){
    X_Merged <- rbind(Test_merged, Train_merge)   
    
    X_Merged
}

# Renaming the columns of the features_name dataframe
colnames(features_names) <- c("indices", "feature_name")

# Filtering the features that we need
filtered_features <- subset(features_names, grepl("-mean()", feature_name) | grepl("-std()", feature_name))

# Renaming the columns of the filtered features
colnames(filtered_features) <- c("indices","feature_name")

# Extracting from the original test set, the means and the standard deviations
X_Test_filtered <- X_Test[,filtered_features[["indices"]]]

# Add now the y_Test as extra column
colnames(y_Test) <- c("activity")
Test_merged <- cbind(X_Test_filtered, y_Test)

# Extracting from the original train set, the means and the standard deviations
X_Train_filtered <- X_Train[,filtered_features[["indices"]]]

# Add now the y_Train as extra column
colnames(y_Train) <- c("activity")
Train_merge <- cbind(X_Train_filtered, activity = y_Train)

# -- Call mergeDataSets to make sure that the datasets are merged
X_Merged <- mergeDataSets()

# Factorizing the activity column with the appropiate names
X_Merged$activity <- factor(X_Merged$activity, 
                            levels = activities_labels[["indices"]], 
                            labels = activities_labels[["activity_name"]])

# Rename the rest of the columns with the feature names
# 1. The parenthesis () have been removed
# 2. The - sign has been substituted by _ 
# 3. Append at the end the activity column to have a vector of the same length as the number of columns
colnames(X_Merged) <- c(gsub("-","_",gsub("\\(\\)","",filtered_features[["feature_name"]])),"activity")

# Save the tidy dataset as csv file
write.csv(file = "dataset_1.csv", x = X_Merged)

#
# ------------------------------------------------------------------------------------------
#

# Second exercise

# Renaming the column names of the dataframes of the subjects with something more meaninful
colnames(subject_test) <- c("subject_id")
colnames(subject_train) <- c("subject_id")

# Merging in one data frame the X, y and subject data for the test data set
Merged_X_Test <- cbind(X_Test, y_Test, subject_test)

# Merging in one data frame the X, y and subject data for the train data set
Merged_X_Train <- cbind(X_Train, y_Train, subject_train)

# Merging in a single data frame the training and the test data set
Merged_Total <- rbind(Merged_X_Test, Merged_X_Train)

# Aggregating all the variables grouped by activity and subject_id
second_result <- aggregate(Merged_Total[,1:561],by=list(Merged_Total$activity, Merged_Total$subject_id), mean)


# Renaming the rest of the columns
colnames(second_result) <- c("activity","subject_id",as.character(features_names[["feature_name"]]))

write.csv(file = "dataset_2.csv", x = second_result)


