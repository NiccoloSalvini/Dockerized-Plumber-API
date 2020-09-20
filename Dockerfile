# Uses RStudio package 4.0.0 (should be faster)
FROM rocker/r-base

# mantainer information
MAINTAINER "Niccolo Salvini" niccolo.salvini27@gmail.com

# install R packages
RUN install2.r \
plumber \
dplyr \
tibble \
magrittr \
rvest \
tidyr \
httr \
stringi \
lubridate \
jsonlite \
doParallel \
stringr


EXPOSE 8000

# copy everything from the current directory into the container
COPY / /

# when the container starts, start the main.R script
CMD R -e "source('main.R')"