ARG BASE
FROM ${BASE}
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

RUN apt-get update && \
    apt-get install -y \
        build-essential  \
        software-properties-common \
        tar \
        python3-dev \
        python3-numpy \
        python3-distutils \
        python3-setuptools \
        wget \
        git \
        unzip \
        gdb

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

# install a more recent cmake from source
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz && \
    tar -zxvf cmake-3.20.2.tar.gz && \
    cd cmake-3.20.2 && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install

# install librealsense from source - only static libs
ARG REALSENSE_VERSION="v2.45.0-cpack"
ARG ENABLE_REALSENSE_CUDA
ARG ARCH

RUN git clone --depth 1 --branch ${REALSENSE_VERSION} https://github.com/attiladoor/librealsense && \
    cd librealsense && mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=release \
        -DBUILD_EXAMPLES=false \
        -DBUILD_GRAPHICAL_EXAMPLES=false \
        -DBUILD_WITH_CUDA=false \
        -DBUILD_SHARED_LIBS=false \
        ../ && \
    make -j$(nproc) && \
    make install

# Build and install OpenCV 4.4 - static library
#
# setup environment
#
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Source:
# OpenCV - https://github.com/mdegans/nano_build_opencv/blob/master/build_opencv.sh
#
ARG OPENCV_VERSION="4.4.0"
ARG ENABLE_OPENCV_CUDA
ARG ARCH

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

# Setup cuda repo and install cuda toolkit
# Add to enable cuddnn
# wget https://storage.gra.cloud.ovh.net/v1/AUTH_6f9e6316c2ce4d37af5c8100c6660301/visys/jetpack4.4/libcudnn8_8.0.0.180-1+cuda10.2_arm64.deb
# apt-get isntall libcudnn8_8.0.0.180-1+cuda10.2_arm64.deb
# OpenCV looks for the cuDNN version in cudnn_version.h, but it's been renamed to cudnn_version_v8.h
# RUN if [ ${ENABLE_OPENCV_CUDA} = "ON" ]; then \
#         ln -s /usr/include/aarch64-linux-gnu/cudnn_version_v8.h /usr/include/aarch64-linux-gnu/cudnn_version.h \
#     ;fi
RUN if [ ${ENABLE_OPENCV_CUDA} = "ON" ]; then \
        wget https://storage.gra.cloud.ovh.net/v1/AUTH_6f9e6316c2ce4d37af5c8100c6660301/visys/jetpack4.4/cuda-repo-l4t-10-2-local-10.2.89_1.0-1_arm64.deb && \
        dpkg -i cuda-repo-l4t-10-2-local-10.2.89_1.0-1_arm64.deb && \
        apt-key add /var/cuda-repo-10-2-local-10.2.89/*.pub &&  \
        apt-get update && \
        apt-get install cuda-cudart-10-2 cuda-curand-10-2 libcublas10 cuda-toolkit-10-2 -y && \
        rm -rf *.deb && \
        ln -s /usr/local/cuda-10.2 /usr/local/cuda && \
        rm -rf /var/lib/apt/lists/* \
    ;fi

RUN if [ ${ENABLE_OPENCV_CUDA} = "ON" ]; then \
        /bin/sh -c echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
        echo "/usr/lib/aarch64-linux-gnu/tegra-egl" > /etc/ld.so.conf.d/nvidia-tegra-egl.conf && ldconfig \
    ;fi

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
        -D WITH_CUDA=${ENABLE_OPENCV_CUDA} \
        -D CUDA_FAST_MATH=${ENABLE_OPENCV_CUDA} \
        -D ENABLE_FAST_MATH=${ENABLE_OPENCV_CUDA} \
        -D WITH_CUBLAS=${ENABLE_OPENCV_CUDA} \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D BUILD_SHARED_LIBS=OFF \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_TBB=ON \
	-D BUILD_PERF_TESTS=OFF \
	-D BUILD_TESTS=OFF \
	   ../

RUN cd opencv/build && make -j$(nproc)
RUN cd opencv/build && make install
RUN cd opencv/build && make package

# install jpeg streamer from source
RUN git clone https://github.com/nadjieb/cpp-mjpeg-streamer.git && \
    cd cpp-mjpeg-streamer && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install && \
    cd /opt/

# Install boost from source
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar -xzvf boost_1_67_0.tar.gz && \
    cd boost_1_67_0 && \
    ./bootstrap.sh && \
    ./b2 install link=static -j$(nproc) || true

# install mqtt broker
RUN apt-get update && \
    apt-get install -y mosquitto

RUN pip3 install paho-mqtt

# cleanup
RUN rm -rf /opt/*