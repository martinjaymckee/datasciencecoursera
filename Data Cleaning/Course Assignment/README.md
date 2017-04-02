# README for "Getting and Cleaning Data" Course Assignment Project

## Theory of Operation
There is a single script file that is used to create the tidy datasets as required by the "Getting and Cleaning Data" course-end assignment.  The file, named *run_analysis.R* contains three functions.  Two are simply utility functions used by the *run_analysis()* function.  The main function, *run_analysis()* combines the extracted dataset, does some transformations on the data, creates the secondary dataset and outputs the files to disk.  One of the utility functions, *select_uci_har_columns*, simply scans the column names (as found in the file *features.txt*) to find the indicies of columns which should be extracted from the dataset.  This function returns a list of column indicies and normalized column names (column name normalization is discussed in the *CodeBook.md* document).  The second utility function, *load_uci_har_dataset()* function simply wraps the functionality to load and combine the data found in each of the two (*train* and *test*) subsets.  Users need only ever call the *run_analysis()*.

## Running the Script
As a prerequisite to running the script, the UCI HAR Dataset must be unzipped in a child directory of the current working directory named, "UCI HAR Dataset".  If this is the case, running the transformation is as simple as doing,

```R
source("run_analysis.R")
run_analysis();
```

It is worth noting that suppressing the output to the console at the *run_analysis()* command is recommended because the function actually returns a list of **data.table** instances which contain the tidy datatables.  The function also outputs the files to disk in a *.csv* format.  Once the command is complete, it will have created two new files named "uci_har_statistics.csv" which contains the mean and standard deviation data of all samples in the original dataset, and file named "uci_har_summary.csv" which contains the average of the mean and standard deviation for each subject/activity pair.  Further information about the output files is available in *CodeBook.md*.

It is also possible to pass information to the *run_analysis()* function to change the output file names or the the source directory.  For example, the following is possible,

```R
source("run_analysis.R")
run_analysis(base_dir='../Foo', statistics_filename='stats.csv', summary_filename='sum.csv');
```

Here, it will search for the UCI HAR Dataset in a directory *Foo*, just below the parent directory.  Moreover, the files created will be named *stats.csv* and *sum.csv*.

To create a space delimeted version of the output (as required by the course submission page) the table return of the *run_analysis()* function can be used as follows.  Given the same prerequisites as the first example, one will simply,

```R
source("run_analysis.R")
dts <- run_analysis();
write.table( dts[2], 'uci_har_summary.txt', row.name=FALSE);
```

and the data will be written to the file *uci_har_summary.txt*. 