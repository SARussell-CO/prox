# Which canvasser had the most demos for a chosen month
mDemos <- function(x, Year = "Current", Month = "Current", n = 10){
  require(lubridate)
  if (Year == "Current") { Year <- year(now()) }
  if (Month == "Current") { Month <- month(now()) }
  # I may want to source the file from the local and updated repo
  # if it is updated and matches the master repo on GitHub. I will have
  # to figure a way to check if it is the most recent version and then load
  # it if it is to avoid going online for the source code each time
  # source("dateclean.R")
  require(devtools)
  source_url("https://raw.githubusercontent.com/proxDenver/prox/master/dateClean.R")
  x <- dateClean(x)
  # The date logic can later be updated to include multiple months over
  # multiple years using the %in% operator
  x <- x[year(x$AppointmentDate) == Year & month(x$AppointmentDate) == Month, ]
  x <- x[x$ResultDesc %in% c("Demo No Sale", "Sale"), ]
  sort( table( x$LatestEventAgent ), decreasing = TRUE )[1:n]
}

# x <- read.csv("C:/Users/Spensa/Desktop/prx.csv", stringsAsFactors = FALSE)
# mDemos(x, Year = 2016, Month = 1)
