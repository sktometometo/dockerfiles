# Ubuntu 18.04 Image with
#  - ROS melodic
#  - cuda 11.1
#  - cudnn8
#  - TensorRT


# Nvidia tensorRT container 20.11-py3 includes
#  - Ubuntu 18.04
#  - CUDA 10.2.89
#  - TensorRT 7.0.0
FROM nvcr.io/nvidia/tensorrt:20.11-py3

ENV DEBIAN_FRONTEND=noninteractive

Maintainer Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>

# -------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------
RUN echo ''
RUN echo '-----------------------------'
RUN echo 'Basic Configuration'
RUN echo '-----------------------------'
RUN echo ''

RUN apt-get update \
    && apt-get dist-upgrade -q -y \
    && apt-get install python -q -y

RUN apt-get update -q && \
    apt-get install -q -y \
        acpi \
        apt \
        apt-cacher-ng \
        apt-utils \
        aptitude \
        bc \
        ccache \
        cmake \
        cmake-curses-gui \
        cron \
        curl \
        emacs \
        git \
        hddtemp \
        htop \
        ibus-mozc \
        indicator-multiload \
        ipython \
        less \
        libboost-all-dev \
        libeigen3-dev \
        libflann-dev \
        libfreetype6-dev \
        libgnome2-bin \
        libnotify-bin \
        libqhull-dev \
        lm-sensors \
        lsb-release \
        man-db \
        mesa-utils \
        mlocate \
        nkf \
        notify-osd \
        ntp \
        patch \
        pkg-config \
        python \
        python-dev \
        python-pip \
        python-setuptools \
        rlwrap \
        software-properties-common \
        ssh \
        sudo \
        wget \
        xdg-user-dirs-gtk \
        xsel \
        vim \
        emacs \
        tmux \
        git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


# -------------------------------------------------------
# ROS Installation
# -------------------------------------------------------
RUN echo ''
RUN echo '-----------------------------'
RUN echo 'ROS Installation'
RUN echo '-----------------------------'
RUN echo ''
# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2  \
    && rm -rf /var/lib/apt/lists/*
# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list
# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-catkin-tools \
    python-wstools \
    && rm -rf /var/lib/apt/lists/*
# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# bootstrap rosdep
RUN rosdep init
# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get upgrade && apt-get install -y \
    ros-melodic-desktop-full=1.4.1-0*


# -------------------------------------------------------
# Add a default user and bashrc
# -------------------------------------------------------
RUN echo ''
RUN echo '-----------------------------'
RUN echo 'User Configuration'
RUN echo '-----------------------------'
RUN echo ''
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN echo '' >> /home/ubuntu/.bashrc
RUN echo '# CUDA' >> /home/ubuntu/.bashrc
RUN echo 'export PATH=/usr/local/cuda/bin:${PATH}' >> /home/ubuntu/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}' >> /home/ubuntu/.bashrc
RUN echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"' >> /home/ubuntu/.bashrc
RUN echo '' >> /home/ubuntu/.bashrc
RUN echo '# ROS' >> /home/ubuntu/.bashrc
RUN echo 'source /opt/ros/melodic/setup.bash' >> /home/ubuntu/.bashrc

WORKDIR /home/ubuntu
USER ubuntu


#
#
#
RUN rosdep update
RUN mkdir /home/ubuntu/catkin_ws/src -p
RUN cd /home/ubuntu/catkin_ws
RUN catkin init
RUN cd /home/ubuntu/catkin_ws/src \
    && git clone https://github.com/tongtybj/jsk_recognition.git \
    && cd jsk_recognition \
    && git checkout trtr_tracker \
    && cd .. \
    && sudo rosdep install --from-paths . --ignore-src -y -r
