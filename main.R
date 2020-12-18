## entrypoint ----
library(plumber)
r = plumber::plumb(here::here("plumber.R"))
r$run(port=80, host="0.0.0.0")



# 
# ## try with logs ----
# library(plumber)
# 
# # Config
# config <- config::get()
# 
# # logging
# library(logger)
# # Ensure glue is a specific dependency so it's avaible for logger
# library(glue)
# 
# # Specify how logs are written
# if (!fs::dir_exists(config$log_dir)) fs::dir_create(config$log_dir)
# log_appender(appender_tee(tempfile("plumber_", config$log_dir, ".log")))
# 
# convert_empty <- function(string) {
#             if (string == "") {
#                         "-"
#             } else {
#                         string
#             }
# }
# 
# pr <- plumb(here::here("plumber.R"))
# 
# pr$registerHooks(
#             list(
#                         preroute = function() {
#                                     # Start timer for log info
#                                     tictoc::tic()
#                         },
#                         postroute = function(req, res) {
#                                     end <- tictoc::toc(quiet = TRUE)
#                                     # Log details about the request and the response
#                                     # TODO: Sanitize log details - perhaps in convert_empty
#                                     log_info('{convert_empty(req$REMOTE_ADDR)} "{convert_empty(req$HTTP_USER_AGENT)}" {convert_empty(req$HTTP_HOST)} {convert_empty(req$REQUEST_METHOD)} {convert_empty(req$PATH_INFO)} {convert_empty(res$status)} {round(end$toc - end$tic, digits = getOption("digits", 5))}')
#                         }
#             )
# )
# pr
