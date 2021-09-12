FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential  \
        cmake \
        software-properties-common \
        tar \
        python3-dev \
        python3-numpy \
        python3-distutils \
        python3-setuptools \
        wget \
        git \
        unzip

RUN apt-get update && \
    apt-get -qq install -y \
        libtbb2 \
        libtbb-dev && \
    apt-get -qq install -y \
        pkg-config \
        libhdf5-dev \
        python3-pip \
        libusb-1.0 \
        libglib2.0-0 \
        libgtk2.0-dev \
        libglib2.0-0 \
        libgl1-mesa-dev \
        libgl1-mesa-glx

RUN apt-get install -y \
    musl-dev \
    libffi-dev \
    libbsd-dev \
    libssl-dev \
    libusb-dev \
    libc-dev

ARG REALSENSE_VERSION="v2.45.0-cpack"

RUN git clone --depth 1 --branch ${REALSENSE_VERSION} https://github.com/attiladoor/librealsense && \
    cd librealsense && mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=release \
        -DBUILD_EXAMPLES=true \
        -DBUILD_GRAPHICAL_EXAMPLES=false \
        -DBUILD_WITH_CUDA=false \
        ../ && \
    make -j$(nproc) && \
    make install && \
    cpack && \
    cp librealsense2-0.1.1-Linux.deb /opt/ && \
    cd /opt && \
    rm -rf /opt/librealsense

# Build and install OpenCV 4.4
#
# setup environment
#
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
WORKDIR /opt

# Source:
# OpenCV - https://github.com/mdegans/nano_build_opencv/blob/master/build_opencv.sh
#
ARG OPENCV_VERSION="4.4.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
 	    file \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libglew-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer1.0-dev \
        libjpeg-dev \
        libjpeg8-dev \
        libjpeg-turbo8-dev \
        libpng-dev \
        libpostproc-dev \
        libswscale-dev \
        libv4l-dev \
        libxine2-dev \
        libxvidcore-dev \
        libx264-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN pip3 install numpy

RUN git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git && \
    git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git

RUN cd opencv && \
    mkdir build && \
    cd build && \
    cmake \
        -D CPACK_BINARY_DEB=ON \
	    -D BUILD_EXAMPLES=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D CUDA_ARCH_BIN=5.3,6.2,7.2 \
        -D CUDA_ARCH_PTX= \
        -D CUDA_FAST_MATH=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_CUDA=OFF \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
	    -D WITH_IPP=OFF \
        -D WITH_TBB=ON \
	    -D BUILD_PERF_TESTS=OFF \
	    -D BUILD_TESTS=OFF \
	   ../

RUN cd opencv/build && make -j$(nproc)
RUN cd opencv/build && make install
RUN cd opencv/build && make package

RUN cd opencv/build && tar -czvf OpenCV-${OPENCV_VERSION}-aarch64.tar.gz *.deb && \
    cp OpenCV-${OPENCV_VERSION}-aarch64.tar.gz /opt && rm -rf /opt/opencv && rm -rf /opt/opencv_contrib


RUN git clone https://github.com/nadjieb/cpp-mjpeg-streamer.git && \
    cd cpp-mjpeg-streamer && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf cpp-mjpeg-streamer


