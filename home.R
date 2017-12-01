# This will be the home screen for doing several different functins using R

# Clean up prox data and assign clean data set to the desktop for import
source("proxClean.R")
proxClean()

# Most demos in a specific month for top n canvassers----
source("mostDemos.R")
# Load the data into an object using the read.csv function
prx <- read.csv(file = "")
# The default behavior is to look up the top ten canvassers for the current month
# in the current year but only to count Demo No Sales and Sales
mDemos(data = prx)

# These are some changes that I can implement later on:----
# Pull data on multiple months
# Pull data on multiple months for specific canvassers
# Plot production data for several canvassers over different time periods
# (Last one may be done best using a new function)

# Pull data for multiple canvassers over multiple months ----
# The first step is to create a list of canvasser names that we are interested in
# and then identify the months that we are interested in.  We can modify the start and 
# end periods for the data range but the default for both will be the current month
# of the year.