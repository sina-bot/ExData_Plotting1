## change local settings
Sys.setlocale("LC_TIME", "English")

## checking and creating a "data" directory
if (!file.exists("data")){
        dir.create("data")
}

## checking and download data
if (!file.exists("./data/household_power_consumption.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./data/household_power_consumption.zip")
        dateDownloaded <- date()
}

## reading txt-file
householdTxt <- unz("./data/household_power_consumption.zip", "household_power_consumption.txt")
householdData <- read.table(householdTxt, header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)

## subset data from the dates 2007-02-01 and 2007-02-02
householdSubData <- subset(householdData, Date == "1/2/2007" | Date == "2/2/2007")

## convert the Date and Time variables
householdSubData$Date <- as.Date(householdSubData$Date, format = "%d/%m/%Y")
householdSubData$Time <- paste(householdSubData$Date, householdSubData$Time, sep = " ")
householdSubData$Time <- strptime(householdSubData$Time, format = "%Y-%m-%d %H:%M:%S")

## setting for multiple base plots
par(mfrow = c(2,2))

## add the four plots
with(householdSubData, {
        ## draw the first plot
        plot(Time, Global_active_power, type = "l",
             xlab = "", ylab = "Global Active Power")
        ## draw the second plot
        plot(Time, Voltage, type = "l",
             xlab = "datetime", ylab = "Voltage")
        ## draw the third plot
        plot(Time, Sub_metering_1, type = "l",
             xlab = "", ylab = "Energy sub metering")
                ## add second curve to the same plot
                with(householdSubData, lines(Time, Sub_metering_2, col = "red"))
                ## add third curve to the same plot
                with(householdSubData, lines(Time, Sub_metering_3, col = "blue"))
                ## add a legend
                legend("topright", lty = 1, cex = 0.4, col = c("black", "red", "blue"),
                legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
        ## draw the fourth plot
        plot(Time, Global_reactive_power, type = "l",
             xlab = "datetime")
})

## copy my plot to a PNG file
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()
