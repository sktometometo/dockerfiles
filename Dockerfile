FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
#ARG CUDA_VERSION=10.0
#ARG CUDNN_VERSION=7.4
#ARG UBUNTU_DIST=ubuntu16.04
#FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-${UBUNTU_DIST}
LABEL maintainer="Koki Shinjo <shinjo@jsk.imi.i.u-tokyo.ac.jp>"
CMD echo "now running..."



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
# install chainer for python3
#COPY requirements_python3.txt /tmp/chainer_install/requirements.txt
#RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3
#RUN python3 -m pip --no-cache-dir install -r /tmp/chainer_install/requirements.txt
# install chainer for python
COPY requirements_python2.txt /tmp/chainer_install/requirements.txt
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python
RUN python -m pip --no-cache-dir install \
    numpy matplotlib scipy \
    cupy-cuda100==6.6.0 \
    chainer==6.6.0 \
    pandas \
    fcn
ENV DISPLAY 0



#
# install ROS
#
RUN apt-get update && apt-get install -q -y \
    dirmngr gnupg2 \
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
    python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*
# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# bootstrap rosdep
RUN rosdep init && rosdep update
# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*
# setup entrypoint
COPY ./ros_entrypoint.sh /
#ENTRYPOINT ["/ros_entrypoint.sh"]
#CMD ["bash"]
