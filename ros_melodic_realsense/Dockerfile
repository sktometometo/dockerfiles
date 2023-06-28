FROM osrf/ros:melodic-desktop-full

LABEL maintainer="sktometometo <sktometometo@gmail.com>"

# Ubuntu 18.04 Image with
#  - ROS melodic
#  - librealsense

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get dist-upgrade -q -y \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
    sudo \
    vim \
    tmux \
    git \
    bsdmainutils \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# LibRealsense Installation
# -------------------------------------------------------
# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2  \
    && rm -rf /var/lib/apt/lists/*
# setup keys
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
# setup sources.list
RUN sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
# Install librealsense2
RUN apt-get update && apt-get install -y \
    librealsense2-dkms \
    librealsense2-utils \
    librealsense2-dev \
    librealsense2-dbg \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# Default User
# -------------------------------------------------------
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu


# -------------------------------------------------------
# Bashrc
# -------------------------------------------------------
RUN echo '# ROS' >> ~/.bashrc
RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc


CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
