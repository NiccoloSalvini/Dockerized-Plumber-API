# Uses RStudio for packages (should be faster)
FROM rocker/r-ver:4.0.0

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  libssl-dev \
  libcurl4-gnutls-dev && install2.r --error \
    --deps TRUE \
    dplyr \
    tibble \
    rvest \
    magrittr \
    httr \
    stringi \
    lubridate \
    jsonlite \
    doParallel \
    plumber


# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "main.R"]