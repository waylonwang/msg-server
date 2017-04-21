FROM coolq/wine-coolq
MAINTAINER Waylon Wang <waylon.act@gmail.com>

RUN mkdir /home/user/coolq/app/io.github.richardchien.coolqhttpapi
COPY config.cfg /home/user/coolq/app/io.github.richardchien.coolqhttpapi/config.cfg
COPY CQP.cfg /home/user/coolq/CQP.cfg
RUN wget -q -O /home/user/coolq/app/io.github.richardchien.coolqhttpapi.cpk \
    https://github.com/richardchien/coolq-http-api/releases/download/v1.1.2/io.github.richardchien.coolqhttpapi.cpk
RUN apt-get update \
    && apt-get install -y vim \
    && rm -rf /var/lib/apt/lists/*
