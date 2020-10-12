library(plumber)
r = plumber::plumb("plumber.R")
r$run(port=8000, host="0.0.0.0")
