get.the.data <- function()
{
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    datapath <- file.path("./data/StormData.csv.bz2")
    data.filepath = "StormData.csv"

    if (!dir.exists(dirname(datapath)))
        dir.create(dirname(datapath))

    if (!file.exists(datapath))
        download.file(fileUrl,destfile=datapath,method="curl")
    else
        print(paste("file already exists:",datapath))

    my.data <- read.csv(bzfile(datapath))

    return(my.data)
}

get.processed.data <- function()
    {
        saved.pruned.dat <- file.path("saved.pruned.dat")
        if(file.exists(saved.pruned.dat))
            {
                print(paste("Working from previously saved data:",saved.pruned.dat))
                load(saved.pruned.dat)
            }
        else
            {
                weather.data <- get.the.data()
                pruned.data <- data.frame(weather.data$EVTYPE,
                                          weather.data$FATALITIES,
                                          weather.data$INJURIES,
                                          weather.data$PROPDMG,
                                          weather.data$CROPDMG)
                names(pruned.data) = c("evtype","fatal","injury","prop.dmg","crop.dmg")
                save(pruned.data,file=saved.pruned.dat)
            }
        return(pruned.data)
    }

get.top.causes <- function(the.values,the.type,the.num)
    {
        the.sums <- tapply(the.values,the.type,sum)
        top.sums <- head(sort(the.sums,decreasing=T,na.last=T),n=the.num)
        names(top.sums) = tolower(names(top.sums))
        return(top.sums)
    }


##str(weather.data)
##health.related <- data.frame()
##names(health.related) = c("evtype","fatal","injury")
##str(health.related)
##fatality.sums <- tapply(health.related$fatal,health.related$evtype,sum)
##top.fatality.causes = head(sort(fatality.sums,decreasing=T,na.last=T),n=10)
the.data <- get.processed.data()
top.fatality.causes=get.top.causes(the.data$fatal,the.data$evtype,5)
str(top.fatality.causes)
top.injury.causes=get.top.causes(the.data$injury,the.data$evtype,5)
str(top.injury.causes)
##names(top.fatality.causes) = tolower(names(top.fatality.causes))
par(mfrow=c(2,1))
barplot(top.fatality.causes,ylab="number of fatalities",
        xlab="event types",main="top five fatality causes")
barplot(top.injury.causes,ylab="number of injuries",
        xlab="event types",main="top five injury causes")

##damage.related <- data.frame(weather.data$EVTYPE,
##names(damage.related) = c("evtype",)
top.prop.dmg=get.top.causes(the.data$prop.dmg,the.data$evtype,5)
top.crop.dmg=get.top.causes(the.data$crop.dmg,the.data$evtype,5)
par(mfrow=c(2,1))
barplot(top.prop.dmg,ylab="thousands of dollars",
        xlab="event types",main="top five property damage causes")
barplot(top.crop.dmg,ylab="thousands of dollars",
        xlab="event types",main="top five crop damage causes")

library(dplyr)
?plot
?axis

install.packages("pander")
library(pander)
