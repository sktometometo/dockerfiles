FROM osrf/ros:melodic-desktop-full
MAINTAINER sktometometo <shinjo@jsk.imi.i.u-tokyo.ac.jp>

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       sudo \
       vim \
       tmux \
       git \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
