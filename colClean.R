# This will be called several times by other scripts.
names(lProx)
# Remove some unneccessary columns
colClean <- function(data, default = TRUE, cols = cols){
  if (default == TRUE) {
    cols <- c("LeadID", "Address", "City", "County", "Zip", "LastName", "FirstName",
              "YearBuilt", "DateAdded", "SourceName", "AppointmentDate", "ResultDesc",
              "LatestSourceName", "LatestBreakdown", "EstimatedInstallation",
              "LatestEventAgent", "SalePrice", "WindowsSeries1", "PatioDoors")
  } else {
      cols <- cols
      }
  data[, cols]
}
