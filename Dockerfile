FROM rocker/tidyverse:latest

MAINTAINER Niccolo Salvini "niccolo.salvini27@gmail.com"

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev

# install R packages
RUN R -e "install.packages(c('magrittr','lubridate', 'plumber', 'rvest', 'stringi', 'jsonlite', 'here', 'purrr', 'mongolite', 'tictoc', 'future', 'here', 'parallel', 'furrr','glue', 'robotstxt' ), dependencies = TRUE)"

# install 'iterators' dep for DoParallel
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/iterators/iterators_1.0.10.tar.gz', repos=NULL, type='source')"

# install 'foreach' dep for DoParallel
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/foreach/foreach_1.4.8.tar.gz', repos=NULL, type='source')"

# install DoParallel from source since not avail in 4.0.2
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/doParallel/doParallel_1.0.14.tar.gz', repos=NULL, type='source')"


# setup nginx
RUN apt-get update && \
            apt-get install -y nginx apache2-utils && \
            htpasswd -bc /etc/nginx/.htpasswd salvini salvini

# set up SSL certificates
RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/server.key \
        -out /etc/ssl/private/server.crt

# add config file to dedicated folder
ADD ./nginx.conf /etc/nginx/nginx.conf

COPY / /

# expose port
EXPOSE 80 443

CMD service nginx start && R -e "source('main.R')"
