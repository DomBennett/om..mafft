FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget make gcc g++

# TODO: switch to latest
# Unsure if mafft website maintains past versions, using uploaded copy
RUN wget https://github.com/DomBennett/om..mafft..7.407/raw/master/mafft-7.407-with-extensions-src.tgz && \
    gunzip -cd mafft-7.407-with-extensions-src.tgz | tar xfv - && \
    rm mafft-7.407-with-extensions-src.tgz && \
    mv mafft-7.407-with-extensions mafft
    
RUN cd mafft/core/ && make clean && make && make install && cd ../..

RUN cd mafft/extensions/ && make clean && make && make install & cd ../..

RUN mkdir /working_dir
WORKDIR /working_dir
