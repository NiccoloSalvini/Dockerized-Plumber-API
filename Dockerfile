FROM rocker/tidyverse:latest

MAINTAINER Niccolo Salvini "niccolo.salvini27@gmail.com"

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev

# install R packages
RUN R -e "install.packages(c('magrittr', 'lubridate', 'plumber', 'rvest', 'stringi', 'jsonlite','DoParallel'), dependencies = TRUE)"

COPY / /

# make all app files readable, gives rwe permission (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /src

# expose port
EXPOSE 8000

CMD ["R", "-e", "r <- plumber::plumb('plumber.R'); r$run(host='0.0.0.0', port=8000)"]