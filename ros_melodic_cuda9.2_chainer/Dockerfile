FROM nvidia/cudagl:9.2-devel-ubuntu18.04

LABEL maintainer="sktometometo <sktometometo@gmail.com>"

# Ubuntu 18.04 Image with
#  - ROS melodic
#  - cuda 9.2
#  - cudnn7
#  - chainer 6.4.0

ENV DEBIAN_FRONTEND=noninteractive


# Update GPG Key for CUDA
#  See https://zenn.dev/takakurasato/scraps/d3e0ee6132a5c5
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

# install packages
RUN apt-get update && apt-get install -q -y \
    wget \
    dirmngr \
    gnupg2  \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade packages
RUN apt-get update \
    && apt-get upgrade -q -y \
    && apt-get dist-upgrade -q -y \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# ROS Installation
# -------------------------------------------------------
# setup keys
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
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
    ros-melodic-desktop-full=1.4.1-0* \
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
    libvtk6-dev \
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
    python-vtk6 \
    rlwrap \
    software-properties-common \
    ssh \
    sudo \
    tcl-vtk6 \
    wget \
    xdg-user-dirs-gtk \
    xsel \
    vim \
    emacs \
    tmux \
    git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


# -------------------------------------------------------
# Chainer Installation
# -------------------------------------------------------
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    python3-wheel \
    python3-setuptools \
    git \
    cmake \
    libblas3 \
    libblas-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
RUN pip install -U \
    "setuptools<45" \
    "pip==9.0.3"
RUN pip install -U \
    "chainer==6.4.0" \
    "cupy-cuda92==6.4.0" \
    "fcn==6.4.17" \
    "ipython<6" \
    "matplotlib<3" \
    numpy \
    percol \
    flake8 \
    grip \
    hacking


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
RUN echo '' >> ~/.bashrc
RUN echo '# ROS' >> ~/.bashrc
RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc


CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
