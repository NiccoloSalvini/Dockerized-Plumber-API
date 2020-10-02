library(plumber)
r <- plumber::plumb("plumber.R")
port <- as.integer(Sys.getenv("PORT", 8000L))
r$run(port=port, host="0.0.0.0")
