# SMILE Coffee - Achats

# Load data
dataCoffee <- read.csv(file = "2017-11-23_Cafe_SMILE.csv", stringsAsFactors = FALSE)

# Put today's date in end date for calculations
dataCoffee[is.na(dataCoffee$DateSortie),"DateSortie"] <- "2017-11-23"
dataCoffee

# Compute duration in days
DurationDays <- as.numeric(as.Date(dataCoffee$DateSortie) - as.Date(dataCoffee$DateEntree))
dataCoffee <- cbind(dataCoffee, Duration1 = DurationDays)
# Scale by Presence&Consumption
dataCoffee <- cbind(dataCoffee, ScaledDuration1 = dataCoffee$TauxPresenceConsoPeriode1*DurationDays)

# Scale Coffee: Bought coffee divided by scaled duration
dataCoffee <- cbind(dataCoffee, ScaledCoffee = dataCoffee$CafeAchete1 / dataCoffee$ScaledDuration1)

dataCoffee[is.nan(dataCoffee$ScaledCoffee), "ScaledCoffee"] <- 0
sortindex <- sort(dataCoffee$ScaledCoffee, index.return = TRUE, decreasing = TRUE)
subData <- dataCoffee[sortindex$ix, c("Nom", "ScaledCoffee")]
subData
