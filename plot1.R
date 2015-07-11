require(data.table)

# extract header by nrow=0.
colheader<-fread("household_power_consumption.txt",sep=";",header=TRUE,nrows=0)
colheader<-colnames(colheader)

# get data from 1/2/2007 to file end by fread function. 
housetxt<-fread("household_power_consumption.txt",sep=";",header=FALSE,na.strings='?',skip="1/2/2007")
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
png(filename = "plot1.png",width = 480, height = 480, units = "px")
#draw histgram.
with(house, {
     hist(Global_active_power,freq=TRUE,main="Global Active Power",col="red",xlab="Global Avtive Power (kilowatts)",axes=FALSE)
     })
axis(1,seq(0,6,2),lwd=2)
axis(2,seq(0,1200,200),lwd=2)
#close png device.
dev.off()
