Relative Density
================
By Chris Mulligan <clm2186@columbia.edu>

Shiny app interactively graphs the number of connected wifi devices over time, using [ADI](http://adicu.com)'s [Density API](http://density.adicu.com/docs).

It enables up to 7 comparisons for the same location and time, on different
days. For example, comparing a hackathon to the week before.

Note that it expects a token.R file with a single line declaring the variable
TOKEN as an API key generated by the server.

   TOKEN <- "XYZ123"