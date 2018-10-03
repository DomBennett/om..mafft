FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    wget make gcc g++

RUN wget https://mafft.cbrc.jp/alignment/software/mafft-7.407-with-extensions-src.tgz && \
    gunzip -cd mafft-7.407-with-extensions-src.tgz | tar xfv - && \
    rm mafft-7.407-with-extensions-src.tgz && \
    mv mafft-7.407-with-extensions mafft
    
RUN cd mafft/core/ && make clean && make && make install && cd ../..

RUN cd mafft/extensions/ && make clean && make && make install & cd ../..

RUN mkdir /working_dir
WORKDIR /working_dir
