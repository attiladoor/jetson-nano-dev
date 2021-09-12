FROM nvcr.io/nvidia/l4t-base:r32.6.1
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
        libjpeg8-dev \
        libtiff-dev \
        libpng-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libatlas-base-dev \
        gfortran \
        libhdf5-dev \
        python3-pip \
        libgl1-mesa-dev \
        libusb-1.0 \
        libglib2.0-0 \
        libgl1-mesa-glx

RUN apt-get install -y \
    musl-dev \
    libffi-dev \
    libbsd-dev \
    libssl-dev \
    libusb-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxi-dev \
    libc-dev

ARG REALSENSE_VERSION="v2.45.0-cpack"

RUN git clone --depth 1 --branch ${REALSENSE_VERSION} https://github.com/attiladoor/librealsense && \
    cd librealsense && mkdir build && cd build && \
    cmake ../ -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=false -DBUILD_WITH_CUDA=true && \
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
	    gfortran \
 	    file \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libcanberra-gtk3-module \
        libdc1394-22-dev \
        libeigen3-dev \
        libglew-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer1.0-dev \
        libgtk-3-dev \
        libjpeg-dev \
        libjpeg8-dev \
        libjpeg-turbo8-dev \
        liblapack-dev \
        liblapacke-dev \
        libopenblas-dev \
        libpng-dev \
        libpostproc-dev \
        libswscale-dev \
        libtbb-dev \
        libtbb2 \
        libtesseract-dev \
        libtiff-dev \
        libv4l-dev \
        libxine2-dev \
        libxvidcore-dev \
        libx264-dev \
	    libgtkglext1 \
	    libgtkglext1-dev \
        pkg-config \
        qv4l2 \
        v4l-utils \
        v4l2ucp \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN pip3 install numpy

# Setup cuda repo and install cuda toolkit
RUN wget https://storage.gra.cloud.ovh.net/v1/AUTH_6f9e6316c2ce4d37af5c8100c6660301/visys/jetpack4.4/cuda-repo-l4t-10-2-local-10.2.89_1.0-1_arm64.deb && \
    wget https://storage.gra.cloud.ovh.net/v1/AUTH_6f9e6316c2ce4d37af5c8100c6660301/visys/jetpack4.4/libcudnn8_8.0.0.180-1+cuda10.2_arm64.deb && \
    dpkg -i cuda-repo-l4t-10-2-local-10.2.89_1.0-1_arm64.deb libcudnn8_8.0.0.180-1+cuda10.2_arm64.deb && \
    apt-key add /var/cuda-repo-10-2-local-10.2.89/*.pub &&  \
    apt-get update && \
    apt-get install cuda-cudart-10-2 cuda-curand-10-2 libcublas10 cuda-toolkit-10-2 -y && \
    rm -rf *.deb && \
    ln -s /usr/local/cuda-10.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/sh -c echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" > /etc/ld.so.conf.d/nvidia-tegra-egl.conf && ldconfig

# OpenCV looks for the cuDNN version in cudnn_version.h, but it's been renamed to cudnn_version_v8.h
RUN ln -s /usr/include/aarch64-linux-gnu/cudnn_version_v8.h /usr/include/aarch64-linux-gnu/cudnn_version.h

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
	    -D BUILD_opencv_java=OFF \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D CUDA_ARCH_BIN=5.3,6.2,7.2 \
        -D CUDA_ARCH_PTX= \
        -D CUDA_FAST_MATH=ON \
        -D CUDNN_INCLUDE_DIR=/usr/include/aarch64-linux-gnu \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
	    -D WITH_EIGEN=ON \
        -D ENABLE_NEON=ON \
        -D OPENCV_DNN_CUDA=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_CUBLAS=OFF \
        -D WITH_CUDA=ON \
        -D WITH_CUDNN=OFF \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_OPENGL=ON \
	    -D WITH_OPENCL=OFF \
	    -D WITH_IPP=OFF \
        -D WITH_TBB=ON \
	   -D BUILD_TIFF=ON \
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


