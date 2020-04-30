FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

Maintainer Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>

#
# ROS kinetic と cuda 9.2 を使えるようにした dockerimage
#

# -------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------
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
        xsel \
        vim \
        emacs \
        tmux \
        git

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
    gnupg2
# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros1-latest.list
# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full
# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-catkin-tools
# bootstrap rosdep
RUN rosdep init && rosdep update


# -------------------------------------------------------
#
# -------------------------------------------------------
RUN echo '' >> ~/.bashrc
RUN echo '# CUDA' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/cuda-9.2/bin:${PATH}' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
RUN echo '' >> ~/.bashrc
RUN echo '# ROS' >> ~/.bashrc
RUN echo 'source /opt/ros/kinetic/setup.bash' >> ~/.bashrc
RUN echo 'source $HOME/catkin_ws/devel/setup.bash' >> ~/.bashrc

RUN mkdir $HOME/catkin_ws/src -p && \
    cd $HOME/catkin_ws && \
    catkin init && \
    cd $HOME/catkin_ws/src && \
    git clone https://github.com/jsk-ros-pkg/jsk_recognition.git && \
    rosdep install --from-paths . --ignore-src -y -r

CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
