#
# The functions contained in this file are used to create tidy data sets from the
#   UCI HAR dataset.  This is designed, specifically, to meet the requirements of the
#   Coursera "Getting and Cleaning Data" culimating course project.  As such, it may
#   not meet the requirements of more general applications.  There are two functions
#   implemented in this file, a load_uci_har_dataset function which loads a complete
#   dataset into a data table, and a run_analysis function which is considered the
#   entry point for the whole run.
#

#
# This is a utility function which reads in the features.txt file and identifies 
#   columns which represent either a mean() or std() value.  The function returns a
#   list of two vectors.  The first vector contains the indicies of the selected
#   columns and the second vector contains the column names.
#
select_uci_har_columns <- function(base_dir, features_filename="features.txt") {
    # Load the features file
    features_dt <- fread(file.path(base_dir, features_filename),
                        col.names=c("index", "column_name"))
    
    # Subset the features and indicies that contain mean() or std()
    select_features <- grepl("mean\\(\\)|std\\(\\)", features_dt$column_name)
    features_dt <-  features_dt[select_features]
    
    # Normalize the column names by removing "(" and ")" and replacing "-" with "_"
    column_names <- features_dt$column_name %>% gsub("\\(\\)", "", .) %>%
                    gsub("-", "_", .)
    
    # Return the selected indicies and column names
    list(as.integer(features_dt$index), column_names)
}

#
# This is a utility function that will create a tidy DataTable from the UCI HAR
#   Dataset.  To create a merged dataset, this will need to be called twice -- on the
#   'training' and 'testing' datasets.  This takes as parameters, the base directory,
#   as well as the source directory.  It will construct the correct paths and files 
#   from those two pieces of information.
#
load_uci_har_dataset <- function(base_dir, dataset_name, 
                                 activity_labels, feature_select) {
    # List of packages required by this function
    require(data.table)
    require(dtplyr)

    # Define Filenames    
    subject_filename <- paste('subject_', dataset_name, '.txt', sep='')
    activities_filename <- paste('y_', dataset_name, '.txt', sep='')
    data_filename <- paste('X_', dataset_name, '.txt', sep='')
    
    # Load Datasets
    #   Get the subject marking dataset
    subject_dt <- fread(file.path(base_dir, dataset_name, subject_filename), 
                        col.names=c("subject"))
    
    #   Get the activity labeling dataset
    activities_dt <- fread(file.path(base_dir, dataset_name, activities_filename), 
                        col.names=c("activity"))
    activities_dt$activity <- sapply(activities_dt$activity, function(idx) activity_labels[[idx]])
    
    #   Get the feature vector dataset -- extract only mean() and std()
    data_dt <- fread(file.path(base_dir, dataset_name, data_filename),
                        select=feature_select[[1]], 
                        col.names=feature_select[[2]])
    
    # Construct full datatable
    dt <- cbind(subject_dt, activities_dt, data_dt)
    
    # Label Discriptive Variable Names
    dt
}

#
# This function is the entry point function and should be called (with or without
#   parameters) to complete the Coursera "Getting and Cleaning Data" data tidying
#   project.  All of the parameters are optional to provide for some flexibility
#   without requiring a complicated run in other cases
#
#   If this function is run with the unzipped UCI HAR Dataset in the working
#   directory, it will process the files and create two tidy datasets in the current
#   working directory.  The first dataset will contain only the mean and standard
#   deviation of each measurement and will be output as a CSV with the name,
#   'uci_har_statistics.csv'.  The second tidy dataset will contain an average of 
#   each variable grouped by activity and subject.
#
run_analysis <- function(
        base_dir='./UCI HAR Dataset', # This is the location of the dataset
        statistics_filename='uci_har_statistics.csv',
        summary_filename='uci_har_summary.csv'
    ) {
    
    # List of packages required by this function
    require(data.table)
    require(dtplyr)
    require(magrittr)
    
    #
    # Process the primary data set
    #
    by_columns <- c("subject", "activity")
    activity_labels <- c(
        "walking", "walking upstairs", "walking downstairs", 
        "sitting", "standing", "laying"
    )
    
    #   Get the features selection information
    feature_select <- select_uci_har_columns(base_dir)
    
    #   Get the 'test' data set
    test_dataset <- load_uci_har_dataset(base_dir, 'test', activity_labels, feature_select)
    
    #   Get the 'training' data set
    train_dataset <- load_uci_har_dataset(base_dir, 'train', activity_labels, feature_select)
    
    #   Merge the two data sets to create a master data set of statistics
    statistics_dataset <-   rbind(test_dataset, train_dataset) %>%
                            mutate(activity=as.factor(activity))
    statistics_dataset <- statistics_dataset[order(subject, activity)]
    
    #   Output the statistics dataset
    fwrite(statistics_dataset, file=statistics_filename)
    
    #
    # Process the summary dataset
    #
    #   Extract the means of each subject/activity pair
    summary_dataset <- statistics_dataset[, lapply(.SD, mean), by=by_columns]
    
    #   Rename the columns by prefixing "avg"
    colnames(summary_dataset) <- c(by_columns, 
                                   paste0("avg_", colnames(summary_dataset)[-(1:2)]))
    
    #   Order the dataset by subject and then activity
    summary_dataset <- summary_dataset[order(subject, activity)]
    
    #   Output the summary dataset
    fwrite(summary_dataset, file=summary_filename)
    
    #
    # Return the resultant datasets
    #
    list(statistics_dataset, summary_dataset)
}