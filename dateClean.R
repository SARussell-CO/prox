#----------------------------------------------------------------------------------------------------#
# Clean up the date columns --------
#----------------------------------------------------------------------------------------------------#

dateClean <- function(data){
  # Remove time stamp from date added column
  data$DateAdded <- sub(pattern = ".{11}$", replacement = "", x = data$DateAdded)
  library(lubridate)
  data$DateAdded <- mdy(data$DateAdded)
  data$AppointmentDate <- mdy(data$AppointmentDate)
  data$LatestDate <- pmax(data$DateAdded, data$AppointmentDate, na.rm = TRUE)
  
  data
  # To view a random ten leads for verification
  # View(data[sample(x = 1:nrow(data), size = 10, replace = FALSE),
  #                c("LastName", "DateAdded", "AppointmentDate", "LatestDate")])
}