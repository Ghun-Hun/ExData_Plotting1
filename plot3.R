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
png(filename = "plot3.png",width = 480, height = 480, units = "px")
#draw plot.
with ( house , {
        plot(date,Sub_metering_1,ylab="Energy sub metering",type="n",xlab=" ",axes=FALSE,frame.plot=TRUE)
        #Add line for for Sub_metering_1 ,2 ,and 3 column.
        lines(date,house$Sub_metering_1,col="black")
        lines(date,house$Sub_metering_2,col="red")
        lines(date,house$Sub_metering_3,col="blue") 
        #Add x and y axis.
        axis.POSIXct(1,seq(min(date),max(date),"days"),format="%a")
        axis(2,at=seq(0,30,10))
        #Add legend
        legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),col=c("black","red","blue"))
       })
#close png device.
dev.off()
