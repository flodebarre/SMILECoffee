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

pdf("SmileCoffee.pdf", width = 8, height = 6)
par(las = 1, mar=c(7, 3, 0.2, 0.2), lend = 1)
plot(subData$ScaledCoffee*365, type = "h", lwd = 4, frame.plot = FALSE, axes = FALSE, 
     xlab = "", ylab = "Café / temps", ylim = c(0, max(subData$ScaledCoffee*365)))
abline(h = mean(dataCoffee$ScaledCoffee*365, na.rm = TRUE), lty = 2)
axis(1, at = seq_along(subData$Nom), labels = subData$Nom, las = 2, pos = 0)
axis(2)
dev.off()
system("xdg-open SmileCoffee.pdf")
