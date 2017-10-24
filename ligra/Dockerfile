FROM phusion/baseimage:0.9.22
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

RUN apt-get update && apt-get install -y wget unzip build-essential libcilkrts5
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/jshun/ligra/archive/master.zip && unzip master.zip && rm master.zip
ENV CILK 1
RUN cd ligra-master/apps && make

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
