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


# setup nginx
RUN apt-get update && \
apt-get install -y nginx apache2-utils && \
htpasswd -bc /etc/nginx/.htpasswd test test

ADD ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ADD . /app
WORKDIR /app
    
# copy everything from the current directory into the container
COPY / /

# when the container starts, start the main.R script
CMD service nginx start && R -e "source('main.R')"