
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://www.rstudio.com/shiny/
#

library(shiny)
library(httr)
library(stringr)
library(jsonlite)
library(ggplot2)

source("token.R")

Sys.setenv(TZ='America/New_York')
Sys.setlocale("LC_ALL", "en_US.utf-8")  # OS X, in UTF-8

grabData <- function(start, duration, group, relative_start=NA) {
#expects start and relative_start to be posixct type objects
#expects duration to be in seconds (or a time delta)

    Sys.setenv(TZ='America/New_York')
    Sys.setlocale("LC_ALL", "en_US.utf-8")  # OS X, in UTF-8

    start_str <- strftime(start, "%Y-%m-%dT%H:%M")
    end_str <- strftime(start+duration, "%Y-%m-%dT%H:%M")
    url <- sprintf("http://density.adicu.com/window/%s/%s/group/%s?auth_token=%s", start_str, end_str, group, TOKEN)
    print(url)
    print(Sys.getlocale())
    req <- jsonlite::fromJSON(url)


    df <- req$data
    df$dump_time <- gsub("Jan", "1", df$dump_time)
    df$dump_time <- gsub("Feb", "2", df$dump_time)
    df$dump_time <- gsub("Mar", "3", df$dump_time)
    df$dump_time <- gsub("Apr", "4", df$dump_time)
    df$dump_time <- gsub("May", "5", df$dump_time)
    df$dump_time <- gsub("Jun", "6", df$dump_time)
    df$dump_time <- gsub("Jul", "7", df$dump_time)
    df$dump_time <- gsub("Aug", "8", df$dump_time)
    df$dump_time <- gsub("Sep", "9", df$dump_time)
    df$dump_time <- gsub("Oct", "10", df$dump_time)
    df$dump_time <- gsub("Nov", "11", df$dump_time)
    df$dump_time <- gsub("Dec", "12", df$dump_time)
    df$dump_time <- gsub("(Mon|Tue|Wed|Thu|Fri|Sat|Sun), ", "", df$dump_time)

    print(df$dump_time)

    df$time <- as.POSIXct(df$dump_time, format="%d %m %Y %H:%M")
    print(df$time)

    if (!is.na(relative_start)) {
        df$shifted_time <- df$time + (relative_start - min(df$time))
    } else {
        df$shifted_time <- df$time
    }

    return(df)
}

shinyServer(function(input, output) {
#     output$debug <- renderText({
#         start <- strptime(strftime(input$date, "%Y-%m-%d"), "%Y-%m-%d") + input$start * 60 * 60
#         print(as.character(start))
#     })


  output$densityPlot <- renderPlot({

    start <- strptime(strftime(input$date, "%Y-%m-%d"), "%Y-%m-%d") + input$start * 60 * 60
    data <- grabData(start, input$duration*60*60, input$group)
    data$label <- strftime(min(data$time), "%Y-%m-%d")
    relative_start <- min(data$time)

    print(input[["date"]])
    comparisons <- c()
    if (input$comparisons) {
        for (i in 1:input$comparisons) {
            comp.date <- paste("date", i, sep="")
            comp.start <- strptime(strftime(input[[comp.date]], "%Y-%m-%d"), "%Y-%m-%d") + input$start * 60 * 60
            comp.data <- grabData(comp.start, input$duration*60*60, input$group, relative_start)
            comp.data$label <- strftime(min(comp.data$time), "%Y-%m-%d")
            comparisons <- rbind(comparisons, comp.data)
        }
    }

    ggplot(data, aes(x=shifted_time, y=client_count, group=label, color=label)) +
        geom_line(data=comparisons) +
        geom_line(size=1) +
        ylab("Connected Clients") + xlab("Time of Day")
  })

})
