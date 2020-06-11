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

## draw a line chart
with(householdSubData, plot(Time, Global_active_power, type = "l",
                            xlab = "", ylab = "Global Active Power (kilowatts)"))

## copy my plot to a PNG file
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
