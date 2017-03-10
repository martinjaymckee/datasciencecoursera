pollutantmean <- function(directory, pollutant, id=1:332) {
  filenames <- file.path(directory, sprintf("%03d.csv", id))
  frames = lapply(filenames, function(x){read.csv(x)})
  dataset <- do.call(rbind, frames)
  mean(dataset[[pollutant]], na.rm=TRUE)
}