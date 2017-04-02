##
## This function returns the hospital with the lowest 30-day mortality rate given
##  the requested state and type of diagnosis.
##
## The valid values for state are the standard two-letter abbreviation
## The valid values for outcome are: "heart attack", "heart failure" and "pneumonia"
##
best <- function(state, outcome) {
    # Load required libraries
    require(data.table)
    
    # Define Function Local Data
    filename <- "outcome-of-care-measures.csv"
    hospitalname_index <- 2L
    state_index <- 7L
    valid_outcomes = c("heart attack", "heart failure", "pneumonia")
    outcome_indicies <- c(11, 17, 23)
    names(outcome_indicies) <- valid_outcomes
    
    # Validate the outcome and return if there is an error
    if(!(outcome %in% valid_outcomes)) stop("invalid outcome")
    
    # Load the outcome data and down convert outcome data
    colindicies = c(hospitalname_index, state_index, outcome_indicies[outcome])
    outcome_data <- fread(filename, select = colindicies)
    names(outcome_data) <- c("Name", "State", "Outcome" )
    suppressWarnings( outcome_data[,Outcome := as.numeric(Outcome)] )

    # Validate the state agains those found in the dataset and return if there's
    #   an error.
    if(!(state %chin% outcome_data$State)) stop("invalid state")
    
    # Strip missing data and data from other states
    outcome_data <- outcome_data[outcome_data$State == state & !is.na(outcome_data$Outcome),]
    
    # Order the data to find the best
    #   Note: the ordering is by the outcome value first and by hospital name
    #       second to ensure that hospitals with ties are returned in a consistent
    #       manner (i.e. alphabetical)
    outcome_data <- outcome_data[order(Outcome, Name)]
    outcome_data$Name[1]
}