FROM phusion/baseimage:0.9.22
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

# graphviz for snap, cilk for ligra, boost for x-stream,
# libaio for gstore, zlib for x-stream and graphchi,
# cilk, libnuma, libblas, liblapack for EverythingGraph,
# openmp (gcc >= 4.6 available in ubuntu xenial) for gridgraph and gstore.
RUN apt-get update && apt-get install -yq \
        wget unzip build-essential \
        zlib1g-dev \
        libaio1 libaio-dev \
        libboost-dev libboost-system-dev libboost-program-options-dev libboost-thread-dev \
        libnuma-dev libblas-dev liblapack-dev \
        libcilkrts5 \
        graphviz
RUN apt-get clean && rm -Rf /var/lib/apt/lists/*

# use the lastest commit without HDFS support
RUN cd / && wget https://github.com/epfl-labos/x-stream/archive/9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && unzip 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && rm 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip
RUN mv x-stream-9cf34b3415219bdcf41c67c0881b28b6fd1beb90 x-stream \
        && cd x-stream && mkdir object_files && mkdir bin && make

RUN cd / && wget https://github.com/epfl-labos/EverythingGraph/archive/master.zip && unzip master.zip && rm master.zip
RUN mv EverythingGraph-master EverythingGraph && cd EverythingGraph && make

RUN cd / && wget https://github.com/GraphChi/graphchi-cpp/archive/master.zip && unzip master.zip && rm master.zip
RUN mv graphchi-cpp-master graphchi && cd graphchi && make

RUN cd / && wget https://github.com/thu-pacman/GridGraph/archive/master.zip && unzip master.zip && rm master.zip
RUN mv GridGraph-master gridgraph && cd gridgraph && make

RUN cd / && wget https://github.com/iHeartGraph/gstore/archive/master.zip && unzip master.zip && rm master.zip
RUN mv gstore-master gstore && cd gstore && make

RUN cd / && wget https://github.com/jshun/ligra/archive/master.zip && unzip master.zip && rm master.zip
ENV CILK 1
RUN mv ligra-master ligra && cd ligra/apps && make

RUN cd / && wget https://github.com/snap-stanford/snap/archive/master.zip && unzip master.zip && rm master.zip
RUN mv snap-master snap && cd snap && make all

RUN cd / && wget https://github.com/Zhan2012/generator/archive/master.zip && unzip master.zip && rm master.zip
RUN mv generator-master generator && cd generator/src && make && make test

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
