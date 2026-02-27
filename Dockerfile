FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        libc6-dev \
        make \
        bison \
        flex \
        libx11-dev \
        libxt-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY . .
RUN find . -name '*.o' -delete && find . -name '*.a' -delete
RUN cd ESPS/general && ./SETUP -p /usr/esps && ./ESPS_INSTALL
