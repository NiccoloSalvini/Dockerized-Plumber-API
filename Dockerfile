# Uses RStudio for packages (should be faster)
FROM rocker/r-ver:4.0.0

# mantainer information
MAINTAINER "Niccolo Salvini" niccolo.salvini27@gmail.com

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get -y \
  libxml2-dev \
  libcairo2-dev \
  libsqlite-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libopenmpi-dev \
  libzmq3-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev && install2.r --error \
    --deps TRUE \
    plumber \
    tidyverse \
    dplyr \
    devtools \
    formatR \
    remotes \
    selectr \
    caTools \
    BiocManager \
    magrittr \
    rvest \
    httr \
    stringi \
    lubridate \
    jsonlite \
    doParallel \
    
    
    
# copy everything from the current directory into the container
COPY / /

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "main.R"]