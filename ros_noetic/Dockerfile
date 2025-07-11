FROM osrf/ros:noetic-desktop-full

LABEL maintainer="sktometometo <sktometometo@gmail.com>"

# Ubuntu 20.04 Image with
#  - ROS noetic

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
       wget \
       curl \
       bsdmainutils \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*
RUN sudo apt-key del C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN curl -sS https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -

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
# bashrc configuration
# -------------------------------------------------------
RUN echo '# ROS' >> ~/.bashrc
RUN echo 'source /opt/ros/noetic/setup.bash' >> ~/.bashrc


CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
