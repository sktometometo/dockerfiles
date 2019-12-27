FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
#ARG CUDA_VERSION=10.0
#ARG CUDNN_VERSION=7.4
#ARG UBUNTU_DIST=ubuntu16.04
#FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-${UBUNTU_DIST}
LABEL maintainer="Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>"
CMD echo "now running..."


#
# add default user
#
## define variables
ENV USER leus
ENV HOME /home/${USER}
ENV SHELL /bin/bash
# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
## 一般ユーザーアカウントを追加
RUN useradd -m ${USER}
## 一般ユーザーにsudo権限を付与
RUN gpasswd -a ${USER} sudo
## 一般ユーザーのパスワード設定
RUN echo "${USER}:leus" | chpasswd
##
RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo '${USER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
##
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd
## default install
RUN apt-get update && apt-get install -y \
    git tmux vim emacs apt-utils
##
ENV DISPLAY 0



#
# install chainer
#
CMD echo "installing chainer...."
RUN mkdir /tmp/chainer_install
RUN apt-get update -y
RUN apt-get install -y \
    git cmake libblas3 libblas-dev \
    python-opencv \
    python-dev python-pip python-tk python-wheel python-setuptools \
    python3-dev python3-pip python3-tk python3-wheel python3-setuptools \
    zlib1g-dev libjpeg62-dev curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python
RUN python -m pip --no-cache-dir install \
    numpy \
    matplotlib \
    scipy \
    cupy-cuda92==6.4.0 \
    chainer==6.4.0 \
    fcn==6.4.17



#
# install ROS
#
RUN apt-get update && apt-get install -q -y dirmngr gnupg2 sudo
## setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
## setup sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full
#=1.3.2-0*
# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-catkin-tools
# bootstrap rosdep
RUN rosdep init && rosdep update
# setup entrypoint
COPY ./ros_entrypoint.sh ${HOME}


## 
USER ${USER}
WORKDIR ${HOME}
