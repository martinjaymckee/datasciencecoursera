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

rankstate <- function(data, num) {
    # Strip missing data and data from other states
    data <- data[!is.na(data$Outcome),]

    # Order the data by outcome and then by hospital name
    data <- data[order(Outcome, Name)]
    
    # Process the ranking number
    num <- process.ranking(num, nrow(data))
    
    # Extract the ranked hospital
    if(num > nrow(data)) data.table(hospital=NA, state=data$State[1])
    data.table(hospital=data$Name[num], state=data$State[1])
}

rankall <- function(outcome, num = "best") {
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

    # Split the data by state, process and recombine
    split_data <- split(outcome_data, outcome_data$State)
    processed_data <- lapply(split_data, rankstate, num)
    as.data.frame(rbindlist(processed_data))
}