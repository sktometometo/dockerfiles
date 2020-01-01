FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

Maintainer Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>

# -------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------
RUN adduser --disabled-password --gecos "" user && \
    echo "user:password" | chpasswd && \
    usermod -aG sudo user

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get dist-upgrade -qq -y

RUN apt-get update -qq && \
    apt-get install -qq -y \
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
        libvtk5-dev \
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
        python-vtk \
        rlwrap \
        software-properties-common \
        ssh \
        sudo \
        tcl-vtk \
        wget \
        xdg-user-dirs-gtk \
        xsel

RUN pip install -q -U "pip==9.0.3" setuptools

RUN pip install -q -U \
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
# ROS Installation
# copied from https://github.com/osrf/docker_iamges
# -------------------------------------------------------
# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
        gnupg2 \
            && rm -rf /var/lib/apt/lists/*
# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros1-latest.list
# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
        python-rosinstall \
            python-vcstools \
                && rm -rf /var/lib/apt/lists/*
# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# bootstrap rosdep
RUN rosdep init \
    && rosdep update
# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-core=1.3.2-0* 
# install ros packages for ros-base (kinetic on ubuntu xenial)
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-base=1.3.2-0* 
# install ros packages for robot (kinetic on ubuntu xenial)
RUN apt-get update && apt-get install -y \
    ros-kinetic-robot=1.3.2-0* 
# install ros packages for desktop (kinetic on ubuntu xenial)
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop=1.3.2-0* 
# install ros packages for desktop-full (kinetic on ubuntu xenial)
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full=1.3.2-0* 
#        && rm -rf /var/lib/apt/lists/*
# setup entrypoint
# COPY ./ros_entrypoint.sh /
# ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["bash"]

# -------------------------------------------------------
#
#
# -------------------------------------------------------
ENV HOME /home/user
ENV SHELL /bin/bash
RUN chown -R user:user /home/user
USER user
CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
