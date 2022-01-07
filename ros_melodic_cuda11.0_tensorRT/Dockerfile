FROM nvcr.io/nvidia/tensorrt:20.11-py3

LABEL maintainer="sktometometo <sktometometo@gmail.com>"

# Ubuntu 18.04 Image with
#  - ROS melodic
#  - cuda 11.1
#  - cudnn8
#  - TensorRT

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get dist-upgrade -q -y \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# ROS Installation
# -------------------------------------------------------
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
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------
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
# Default User
# -------------------------------------------------------
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
RUN rosdep update


# -------------------------------------------------------
# Bashrc
# -------------------------------------------------------
RUN echo '' >> ~/.bashrc
RUN echo '# CUDA' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/cuda/bin:${PATH}' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"' >> ~/.bashrc
RUN echo '' >> ~/.bashrc
RUN echo '# ROS' >> ~/.bashrc
RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc


CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
