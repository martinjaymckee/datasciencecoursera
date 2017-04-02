#Codebook for Tidy UCI HAR Dataset

##General Tidying Operations:
The UCI HAR Dataset for the Coursera "Getting and Cleaning Data" course in the data science specialization consists of a number of files.  These were combined into a single dataset.  Moreover, only a specified subset of fields was required, and the one column of data needed to be modified to contain discriptive data (in place of simple integer data).  There were also minor modifications to the column names.  Finally, the data consisted of two full sets of files: *test* and *train*, so that these needed to be combined.  Therefore, the tidying operations required were:
* Combine subject_test.txt, X_test.txt and y_test.txt to create a *test* dataset.
* Combine subject_train.txt, X_train.txt and y_train.txt to create a *train* dataset.
* Merge the *test* and *train* datasets.
* Extract the desired columns.
* Modify the **activity** column to contain descriptive values.
* Order the rows by subject and then activity

At the end of these operations, a tidy dataset was obtained which could then be used to create the second tidy dataset required to complete the assignment.

##Tidy Dataset Description:
There are two datasets that have been derived from the UCI HAR Dataset by this project. The first dataset contains the mean and standard deviation of the measurements ordered by subject and activity while the second dataset contains the average of those values grouped by for each subject/activity pair, and ordered in the same way as the first dataset.

###Activity Labels:
The activities, originally labeled 1:6, were changed to descriptive text.  Activity labels were changed as follows:
* 1 -> "walking"
* 2 -> "walking upstairs"
* 3 -> "walking downstairs"
* 4 -> "sitting"
* 5 -> "standing"
* 6 -> "laying"

###Dataset Measurement Values:
All measurement values in this version of the UCI HAR Dataset are normalized to a window of [-1, 1].  This leads to the somewhat confusing situation that there are actually negative standard deviations in the dataset.  However, this has not been changed as: a) it was not a requirement of the assignment, and b) the dataset does not appear to contain enough information to actually get back to the original inertial values in any case.  This windowed form of the measurement does not impact the tidyness of the dataset.

###Mean and Standard Deviation (Statistics) Dataset:
The **statistics** dataset is created with the name *uci_har_statistics.csv*.  This file contains as many rows as were found in the original UCI HAR dataset, but it only contains a subset of the columns.  To make the columns more easily usable in R as column names, the imported column names were imported with two modifications.  Firstly, parenthesis were removed from the original column names and, secondly, '-' characters were replaced with '_' characters.  As the original files used camel case to seperate words, the column names were **not** normalized to being all lower case.  The first two columns were derived from the subject (i.e. subject_test.txt and subject_train.txt) and activity (X_test.txt and X_test.txt) files and are named *subject* and *activity* respectively.

For those who are interested in *all* of the column names, they may be derived from the original *features.txt* document as included with the UCI HAR Dataset, searching for those that apply either mean() or std(), and finally making the aforementioned normalizing modifications.  There are a total of 68 columns in the dataset, the first four being:
1. subject (the **number** of the subject doing the activity)
2. activity (the activity being done during the measurement)
3. tBodyAcc_mean_X (a mean of the sample X-axis component of body acceleration )
3. tBodyAcc_mean_Y (a mean of the sample Y-axis component of body acceleration )
5. *etc.*

###Statistics Summary Dataset:
This dataset is created as *uci_har_summary.csv*.  Much of the information specified for the above dataset is valid for this dataset.  Once change is that the measurement columns are prefixed with *avg_*.  The other change is that the data columns contain the **average** of all samples of an activity for each subject.  As such, the number of rows is greatly reduced (from >10,000 to 180, in fact).  As mentioned before, the column labels can be derived from the original dataset codebook and will look something like the following:
1. subject
2. activity
3. avg_tBodyAcc_mean_X
4. avg_tBodyAcc_mean_Y
5. *etc.*

