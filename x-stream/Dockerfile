FROM phusion/baseimage:0.9.22
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

RUN apt-get update && apt-get install -y wget zlib1g-dev unzip \
        build-essential \
        libboost-dev \
        libboost-system-dev \
        libboost-program-options-dev \
        libboost-thread-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/epfl-labos/x-stream/archive/9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && unzip 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && rm 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip
RUN cd x-stream-9cf34b3415219bdcf41c67c0881b28b6fd1beb90 \
        && mkdir object_files && mkdir bin \
        && make && make install

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
