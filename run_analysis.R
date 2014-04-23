#
# ------------------------------------------------------------------------------------------
#
# First exercise

# Loading the test dataset
loadTestData <- function(){
    X_Test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
    y_Test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
    subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
}

# Loading the train dataset
loadTrainData <- function(){
    X_Train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
    y_Train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
    subject_train <- read.table("UCI HAR Dataset/train//subject_train.txt", header = FALSE)
}

# Loading activities labels
loadActivityLabels <- function(){
    activities_labels <- read.table("UCI HAR Dataset/activity_labels.txt")    
    colnames(activities_labels) <- c("indices","activity_name")
    
    activities_labels
}

# Loading the features names
readFeatureNames <- function(){
    features_names <- read.table("UCI HAR Dataset/features.txt")    
    
    features_names
}

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
#write.csv(file = "dataset_1.csv", x = X_Merged)

#
# ------------------------------------------------------------------------------------------
#

# Second exercise
# Extract the columns that include only the mean. This can be done filtering the column names
columns <- subset(colnames(X_Merged), grepl("_mean",colnames(X_Merged)))

# Storing then the filtered data in a new dataframe
tmp <- cbind(X_Merged[columns], X_Merged["activity"])

# Renaming the column names of the dataframes of the subjects with something more meaninful
colnames(subject_test) <- c("subject_id")
colnames(subject_train) <- c("subject_id")

subject <- rbind(subject_test, subject_train)

# Merging the subject dataframe with the x dataframe
X_Merged_Mean_And_Subjects <- cbind(tmp, subject)

# Saving the second tidy dataset as csv file
write.csv(file = "dataset_2.csv", x = X_Merged_Mean_And_Subjects)

# Adding an extra column now with id of each subject
