FROM oceanixau/bird.rs.docker:latest

MAINTAINER OceanIX Administrator <connect@oceanix.net.au>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install \
        -y \
        --no-install-recommends \
            vim \
            git \
            build-essential \
            python3-pip \
            python3-dev && \
    rm -rf /var/lib/apt/lists/*


RUN curl \
    -OL https://golang.org/dl/go1.15.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

RUN go get github.com/alice-lg/birdwatcher

RUN mkdir -p /etc/birdwatcher

RUN mkdir /bgpq3 && \
    cd /bgpq3 && \
    git clone https://github.com/snar/bgpq3.git ./ && \
    ./configure && \
    make && \
    make install


ARG INSTALL_FROM_GITHUB_SHA

RUN pip3 install --upgrade pip setuptools wheel

RUN if [ -z "$INSTALL_FROM_GITHUB_SHA" ]; \
    then \
        pip3 install arouteserver; \
    else \
        pip3 install git+https://github.com/pierky/arouteserver.git@$INSTALL_FROM_GITHUB_SHA; \
    fi;

CMD /root/run.sh
