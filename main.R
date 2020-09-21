library(plumber)
r = plumb("plumber.R")
r$run(port = 8000,debug = TRUE ,host = "0.0.0.0")
