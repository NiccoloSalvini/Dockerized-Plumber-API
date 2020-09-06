# start from the rocker/r-ver:4.0.0 image
# now with RStudio pack manager it takes less time to build an image
FROM rocker/r-ver:4.0.0

# install packages
RUN R -e "install.packages(c('plumber','tibble','magrittr','rvest','tidyr','httr','stringi','lubridate','jsonlite','doParallel','stringr'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# copy everything from the current directory into the container
COPY / /

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "main.R"]