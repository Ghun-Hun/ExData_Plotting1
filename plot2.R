require(data.table)
Sys.setlocale(category = "LC_ALL", locale = "C")
# extract header by nrow=0.
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","household_power_consumption.zip",method="curl")
command<-paste0('unzip -p ',getwd(),"/","household_power_consumption.zip")
colheader<-fread(command,sep=";",header=TRUE,nrows=0)
colheader<-colnames(colheader)

# get data from 1/2/2007 to file end by fread function. 
housetxt<-fread(command,sep=";",header=FALSE,na.strings='?',skip="1/2/2007")
names(housetxt)<-colheader

# extract data from 1/2/2007 to 2/2/2007 for Date column 
 housetxt<-housetxt[Date=="1/2/2007" | Date=="2/2/2007"]
# remove NA
housetxt<-na.omit(housetxt)
#In addition to the Date and Time columns, all of the columns converted to a numeric type.
housetxt_narm<-housetxt[,3:9,with=FALSE]
housetxt_partial<-housetxt_narm[,lapply(.SD,as.numeric)]
# The date and time  columns converted POSIXlt type.
date<-as.POSIXct(as.POSIXlt(paste(housetxt[,Date],housetxt[,Time]),format="%d/%m/%Y %H:%M:%S"))
#combind date and converted numeric data.
house<-cbind(date,housetxt_partial)

#create png device.
png(filename = "plot2.png",width = 480, height = 480, units = "px")
#draw plot.
with( house , {
      plot(date,Global_active_power,ylab="Global Active Power (kilowatts)",xlab=" ",type="l",axes=FALSE,frame.plot=TRUE)  
      axis.POSIXct(1,seq(min(date),max(date),"days"),format="%a")
      axis(2,at=seq(0,6,2))
  })
#axis.POSIXct(1,seq(min(house$date),max(house$date),"days"),format="%a")
#axis(2,at=seq(0,6,2))
#close png device.
dev.off()
