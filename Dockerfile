FROM phusion/baseimage:0.9.22
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

# graphviz for snap, cilk for ligra and EverythingGraph,
# boost for x-stream, libaio for gstore, zlib for x-stream and graphchi,
# libnuma, libblas, liblapack for EverythingGraph, libarpack2 for motifcluster in snap
# openmp (gcc >= 4.6 available in ubuntu xenial) for gridgraph and gstore.
RUN apt-get update && apt-get install -yq \
        wget unzip build-essential graphviz zlib1g-dev \
        libaio1 libaio-dev libcilkrts5 libnuma-dev \
        libboost-dev libboost-system-dev libboost-program-options-dev libboost-thread-dev \
        libblas-dev liblapack-dev libarpack2-dev
RUN apt-get clean && rm -Rf /var/lib/apt/lists/*

RUN mkdir -p /graph

# use the lastest commit without HDFS support
RUN cd /graph && \
    wget https://github.com/epfl-labos/x-stream/archive/9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip && \
    unzip 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip && \
    rm 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip && \
    mv x-stream-9cf34b3415219bdcf41c67c0881b28b6fd1beb90 x-stream && \
    cd x-stream && mkdir object_files && mkdir bin && make

RUN cd /graph && \
    wget https://github.com/epfl-labos/EverythingGraph/archive/master.zip && \
    unzip master.zip && rm master.zip && mv EverythingGraph-master everything-graph && \
    cd everything-graph && make

RUN cd /graph && \
    wget https://github.com/GraphChi/graphchi-cpp/archive/master.zip && \
    unzip master.zip && rm master.zip && mv graphchi-cpp-master graphchi && \
    cd graphchi && make

RUN cd /graph && \
    wget https://github.com/thu-pacman/GridGraph/archive/master.zip && \
    unzip master.zip && rm master.zip && mv GridGraph-master gridgraph && \
    cd gridgraph && make

RUN cd /graph && \
    wget https://github.com/iHeartGraph/gstore/archive/master.zip && \
    unzip master.zip && rm master.zip && mv gstore-master gstore && \
    cd gstore && make

RUN cd /graph && \
    wget https://github.com/iHeartGraph/Graphene/archive/master.zip && \
    unzip master.zip && rm master.zip && mv Graphene-master graphene && \
    cd graphene/graphene/test && \
        for d in *; do \
            [ -d $d ] && (cd $d; sed -i 's/^flags = .*/ & -L..\/..\/lib\//g' Makefile; make); \
        done && \
    cd ../../converter && \
        for d in *; do \
            [ -d $d ] && (cd $d; make); \
        done

ENV CILK 1
RUN cd /graph && \
    wget https://github.com/jshun/ligra/archive/master.zip && \
    unzip master.zip && rm master.zip && mv ligra-master ligra && \
    cd ligra/apps && make && cd ../utils && make

# snap commit on 2 Aug 2018
RUN cd /graph && \
    wget https://github.com/snap-stanford/snap/archive/86ac647a011a8de43e8b1af6a9a45a737a69d886.zip && \
    unzip 86ac647a011a8de43e8b1af6a9a45a737a69d886.zip && \
    rm 86ac647a011a8de43e8b1af6a9a45a737a69d886.zip && \
    mv snap-86ac647a011a8de43e8b1af6a9a45a737a69d886 snap && \
    cd snap && make all && cd examples/motifcluster && make

RUN cd /graph && \
    wget https://github.com/Zhan2012/generator/archive/master.zip && \
    unzip master.zip && rm master.zip && mv generator-master generator && \
    cd generator/src && make && make test

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
