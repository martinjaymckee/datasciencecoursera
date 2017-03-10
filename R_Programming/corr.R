corr <- function(directory, threshold=0) {
  num_complete <- complete(directory)
  valid_datasets <- num_complete[num_complete$nobs>threshold,]
  correlations <- vector("numeric", nrow(valid_datasets))
  if( nrow(valid_datasets) == 0) return(correlations)
  id <- valid_datasets[,"id"]
  filenames <- file.path(directory, sprintf("%03d.csv", id))
  frames = lapply(filenames, function(x){read.csv(x)})
  for(index in seq_along(frames)){
    correlations[index] <- cor(frames[[index]][,"nitrate"], frames[[index]][,"sulfate"], use='complete.obs')
  }
  return(correlations)
}