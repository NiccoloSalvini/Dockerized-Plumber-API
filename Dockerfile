FROM rocker/tidyverse:latest

MAINTAINER Niccolo Salvini "niccolo.salvini27@gmail.com"

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev

# install R packages
RUN R -e "install.packages(c('magrittr','lubridate', 'plumber', 'rvest', 'stringi', 'jsonlite'), dependencies = TRUE)"

# install DoParallel from source since not aval in 4.0.2
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/doParallel/doParallel_1.0.14.tar.gz', repos=NULL, type='source')"

COPY / /

# expose port
EXPOSE 8000

CMD ["R", "-e", "r <- plumber::plumb('plumber.R'); r$run(host='0.0.0.0', port=8000)"]