
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://www.rstudio.com/shiny/
#

library(shiny)
library(httr)
library(stringr)
library(jsonlite)


rooms <- function() {
    rooms <- jsonlite::fromJSON("http://density.adicu.com/docs/building_info")$data
    final <- setNames(rooms[,'group_id'], rooms[,'group_name'])
    return(final)
}


shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Relative Density"),

  # Sidebar with a slider input for number of bins
  sidebarPanel(
      selectInput("group", label = h3("Location"),
                  rooms()),
      dateInput("date", label = h3("Date")),
      sliderInput("start", label = h3("Start Time"),
                  min = 0, max = 24, value = 0),
      sliderInput("duration", label = h3("Duration (hrs)"),
                  min = 0, max = 25, value = 6),
      sliderInput("comparisons", label = h3("Number of Comparisons"),
                  min = 0, max = 7, value = 0),

      conditionalPanel(condition = "input.comparisons >= 1", dateInput("date1", label = "Date (Comparison 1)")),
      conditionalPanel(condition = "input.comparisons >= 2", dateInput("date2", label = "Date (Comparison 2)")),
      conditionalPanel(condition = "input.comparisons >= 3", dateInput("date3", label = "Date (Comparison 3)")),
      conditionalPanel(condition = "input.comparisons >= 4", dateInput("date4", label = "Date (Comparison 4)")),
      conditionalPanel(condition = "input.comparisons >= 5", dateInput("date5", label = "Date (Comparison 5)")),
      conditionalPanel(condition = "input.comparisons >= 6", dateInput("date6", label = "Date (Comparison 6)")),
      conditionalPanel(condition = "input.comparisons >= 7", dateInput("date7", label = "Date (Comparison 7)")),
      p(),
      p("Relative Density is by",  a("Chris Mulligan", href="http://chmullig.com"), "and is powered by", a("ADI's", href="http://adicu.com"), a("Density", href="http://density.adicu.com/"), a("API.", href="http://density.adicu.com/docs"), "Density is a collaboration with", a("ESC", href="http://columbiaesc.com/"), "and", a("CUIT.", href="https://cuit.columbia.edu/") ),
      p("Relative Density is", a("released", href="https://github.com/chmullig/relative_density"), "under an MIT License.")
  ),

  # Show a plot of the generated distribution
  mainPanel(
    #textOutput("debug"),
    plotOutput("densityPlot")
  )
))
