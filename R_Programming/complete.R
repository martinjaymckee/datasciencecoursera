complete <- function(directory, id=1:332) {
  filenames <- file.path(directory, sprintf("%03d.csv", id))
  frames = lapply(filenames, function(x){read.csv(x)})
  num_complete = unlist(lapply(frames, function(x){sum(complete.cases(x))}))
  data.frame(id=id, nobs=num_complete)
}