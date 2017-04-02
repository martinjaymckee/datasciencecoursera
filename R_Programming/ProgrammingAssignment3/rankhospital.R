##
## This function processes the num argument to give a numeric ranking index baesd on
##  the passed in value ("best", "worst" or an integer) and the total number of
##  hospitals.  It is worth noting that, as written, this can return NA if an invalid
##  string is passed in.  This, in turn, can trigger errors later in code.  If such
##  an invalid string is found, however, a warning about "NAs introduced by coersion"
##  *will* be raised.
##
process.ranking <- function(num, limit) {
    if(num == "best")  return(1)
    else if(num == "worst") return(limit)
    as.integer(num)
}

##
## This function processes the dataset to return the hospital with the specified
##  ranking, given a state and outcome.  The state argument must be provided with
##  a two-letter abbreviation of a state name, the outcome argument must be one of
##  "heart attack", "heart failure" or "pheumonia" and the num argument can be either
##  an integer or one of the strings ("best", "worst").
##
## This function will return an error status if the state or outcome is invalid.
##  However, there is no error return for an invalid num argument.  If num would
##  overrun the length of the list of hospitals, the function will return NA.  If,
##  on the other hand, the num argument is not convertable to an integer,
##  rankhospital will simply fail with an error.
##
rankhospital <- function(state, outcome, num = "best") {
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

    # Load the outcome data and down convert it
    colindicies = c(hospitalname_index, state_index, outcome_indicies[outcome])
    outcome_data <- fread(filename, select = colindicies)
    names(outcome_data) <- c("Name", "State", "Outcome" )
    suppressWarnings( outcome_data[,Outcome := as.numeric(Outcome)] )
    
    # Validate the state agains those found in the dataset and return if there's
    #   an error.
    if(!(state %chin% outcome_data$State)) stop("invalid state")
    
    # Strip missing data and data from other states
    outcome_data <- outcome_data[outcome_data$State == state & !is.na(outcome_data$Outcome),]
    
    # Order the data to find the best and extract the ranking number
    #   Note: the ordering is by the outcome value first and by hospital name
    #       second to ensure that hospitals with ties are returned in a consistent
    #       manner (i.e. alphabetical)
    outcome_data <- outcome_data[order(Outcome, Name)]
    num <- process.ranking(num, nrow(outcome_data))
    
    # Return the correctly ranked hospital
    if(nrow(outcome_data) < num) return(NA)
    outcome_data$Name[num]
}

