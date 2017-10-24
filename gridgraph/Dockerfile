FROM phusion/baseimage:0.9.22
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

RUN apt-get update && apt-get install -y wget unzip build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/thu-pacman/GridGraph/archive/master.zip && unzip master.zip && rm master.zip
RUN cd GridGraph-master && make

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
