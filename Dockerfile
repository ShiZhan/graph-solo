FROM phusion/baseimage:0.9.19
MAINTAINER Zhan.Shi <g.shizhan.g@gmail.com>

# graphviz for snap, cilk for ligra, boost for x-stream,
# zlib for x-stream and graphchi, openmp (gcc >= 4.6 buildin) for gridgraph.
RUN apt-get update && apt-get install -y wget unzip build-essential \
        zlib1g-dev \
        libboost-dev \
        libboost-system-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libcilkrts5 \
        graphviz
RUN apt-get clean && rm -Rf /var/lib/apt/lists/*

RUN cd / && wget https://github.com/epfl-labos/x-stream/archive/9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && unzip 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip \
        && rm 9cf34b3415219bdcf41c67c0881b28b6fd1beb90.zip
RUN mv x-stream-9cf34b3415219bdcf41c67c0881b28b6fd1beb90 x-stream \
        && cd x-stream && mkdir object_files && mkdir bin && make

RUN cd / && wget https://github.com/GraphChi/graphchi-cpp/archive/master.zip && unzip master.zip && rm master.zip
RUN mv graphchi-cpp-master graphchi && cd graphchi && make

RUN cd / && wget https://github.com/thu-pacman/GridGraph/archive/master.zip && unzip master.zip && rm master.zip
RUN mv GridGraph-master gridgraph && cd gridgraph && make

RUN cd / && wget https://github.com/jshun/ligra/archive/master.zip && unzip master.zip && rm master.zip
ENV CILK 1
RUN mv ligra-master ligra && cd ligra/apps && make

RUN cd / && wget https://github.com/snap-stanford/snap/archive/master.zip && unzip master.zip && rm master.zip
RUN mv snap-master snap && cd snap && make all

VOLUME /datasets
WORKDIR /datasets

CMD ["/sbin/init"]
