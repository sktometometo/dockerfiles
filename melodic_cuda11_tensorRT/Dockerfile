ARG CUDA_VERSION=11.1

FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

Maintainer Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>

ENV TRT_VERSION 7.2.3.4


# Ubuntu 18.04 Image with
#  - ROS melodic
#  - cuda 11.1
#  - cudnn8
#  - TensorRT

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
    && rm -rf /var/lib/apt/lists/*

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
RUN rosdep init && rosdep update
# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*


# -------------------------------------------------------
# Tensor RT Installation
# -------------------------------------------------------
RUN echo ''
RUN echo '-----------------------------'
RUN echo 'Tensor RT Installation'
RUN echo '-----------------------------'
RUN echo ''
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    wget \
    zlib1g-dev \
    git \
    pkg-config \
    sudo \
    ssh \
    libssl-dev \
    pbzip2 \
    pv \
    bzip2 \
    unzip \
    devscripts \
    lintian \
    fakeroot \
    dh-make \
    build-essential

# Install python3
RUN apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-dev \
      python3-wheel &&\
    cd /usr/local/bin &&\
    ln -s /usr/bin/python3 python &&\
    ln -s /usr/bin/pip3 pip;

# Install TensorRT
RUN cd /tmp &&\
    wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb &&\
    dpkg -i nvidia-machine-learning-repo-*.deb && apt-get update
RUN v="${TRT_VERSION%.*}-1+cuda${CUDA_VERSION%.*}" &&\
    apt-get install -y libnvinfer7=${v} libnvinfer-plugin7=${v} libnvparsers7=${v} libnvonnxparsers7=${v} libnvinfer-dev=${v} libnvinfer-plugin-dev=${v} libnvparsers-dev=${v} python3-libnvinfer=${v} &&\
    apt-mark hold libnvinfer7 libnvinfer-plugin7 libnvparsers7 libnvonnxparsers7 libnvinfer-dev libnvinfer-plugin-dev libnvparsers-dev python3-libnvinfer
# Install PyPI packages
RUN pip3 install --upgrade pip
RUN pip3 install setuptools>=41.0.0
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Install Cmake
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh && \
    chmod +x cmake-3.14.4-Linux-x86_64.sh && \
    ./cmake-3.14.4-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm ./cmake-3.14.4-Linux-x86_64.sh

# Download NGC client
RUN cd /usr/local/bin && wget https://ngc.nvidia.com/downloads/ngccli_cat_linux.zip && unzip ngccli_cat_linux.zip && chmod u+x ngc && rm ngccli_cat_linux.zip ngc.md5 && echo "no-apikey\nascii\n" | ngc config set


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
RUN ["/bin/bash"]
