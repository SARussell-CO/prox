#----------------------------------------------------------------------------------------------------#
# Load data, remove columns, clean date columns ---------
#----------------------------------------------------------------------------------------------------#
# Create a user function that can be use for cleaning prox data
proxClean <- function() {
  
  # Verify that CCrowe is the user
  stopifnot( Sys.info()[["user"]] == "CCrowe")

  if ( Sys.info()[["user"]] == "Cameron") {
    path <- "//rba-col-dc01/RedirectedFolders/CCrowe/Desktop"
    } else {
    path <- "C:/rba"
    }
  
  user <- Sys.info()[["user"]]
  inputPath <- paste0("C:/Users/", user, "/Downloads/")

  # Search files in the download folder for the search string
  proxDatas <- list.files(path = inputPath, 
                          pattern = "^proximitymarketingnames", 
                          full.names = TRUE)
  
  # Find the latest created file matching the search string
  latest <- which( file.info(proxDatas)$mtime == max( file.info(proxDatas)$mtime ) )

  # Load the latest data as lProx
  lProx <<- read.csv(proxDatas[latest], stringsAsFactors = FALSE)

  # Remove all prox data sets that are no longer relevant
  unlink(proxDatas[-latest])

  # Load functions used for cleaning the data
  # (Make sure to open the project or the file itself so that the correct
  # working directory is chosen.)
  source("colClean.R")
  source("dateClean.R")
  
  # Clean up the data
  lProx <- colClean(lProx)
  lProx <- dateClean(lProx)
  
  # If you want to view some of the summary data on the dates uncomment these lines
  # and run them outside of the function
  # summary(lProx$DateAdded)
  # summary(lProx$AppointmentDate)
  # summary(lProx$LatestDate)
  
  # To view a random ten leads for verification of latestDate column run the 
  # following lines
  # View(lProx[sample(x = 1:nrow(lProx), size = 10, replace = FALSE),
  #                c("LastName", "DateAdded", "AppointmentDate", "LatestDate")])
  
  # Include only results that have a latest date in 2017
  # (This may need to be amended to the latest N many months as the year changes over)
  lProx <- lProx[which(year(lProx$LatestDate) >= 2017), ]
  
  # Uncomment and run the next line for verification of latest date
  # summary(lProx$LatestDate)
  
  #----------------------------------------------------------------------------------------------------#
  # Add tag column and month name column ---------
  #----------------------------------------------------------------------------------------------------#
  # In order to color code the data we need the tag and month columns
  # Find the last month we have data for and whatever month was 7 before
  # since we can only load 8 colors into MapPoint
  lMonth <- max(unique(month(lProx$LatestDate)))
  fMonth <- lMonth - 7
  lProx$Month <- month(lProx$LatestDate)
  # Run following line to see a table of months
  # table(lProx$Month)
  
  # If the month for the lead is less than or equal to fMonth then it becomes fMonth
  lProx$Tag <- ifelse(lProx$Month <= fMonth, fMonth, lProx$Month)
  # Run following line to see a table of tags
  # table(lProx$Tag)
  
  #----------------------------------------------------------------------------------------------------#
  # Remove records that have no relation to prox ---------
  #----------------------------------------------------------------------------------------------------#
  # There should be several records that never went through with a demo.
  # To view those records that did not demo:
  # View(lProx[which(lProx$LatestSourceName == ""), ])
  
  # For each record if the SourceName or the LatestSourceName is related to prox then
  # we will label it as such
  lProx$prox <- ifelse(lProx$SourceName == "Proximity Marketing" | 
                         lProx$LatestSourceName == "Proximity Marketing",
                       TRUE, FALSE)
  # table(lProx$prox)
  # To view the records that have nothing to do with prox:
  # View(lProx[which(lProx$prox == FALSE), ])
  # View(lProx[which(lProx$prox == TRUE), ])
  
  # Remove records that are not related to prox
  lProx <- lProx[lProx$prox, ]
  
  cols <- c("LastName", "FirstName", 
            "Address", "City", "County", "Zip", 
            "AppointmentDate", "ResultDesc", "EstimatedInstallation",
            "LatestEventAgent")
  
  # This global assignment may need to be amended if this project substantially grows
  lProx <<- lProx[, cols]
  
  # This line was added on 12/1 and not tested yet
  lProx$County <- lProx$LatestEventAgent
  
  # Create the final table for export
  write.csv(x = lProx, file = paste0(path, "/latestProx.csv"))
}
