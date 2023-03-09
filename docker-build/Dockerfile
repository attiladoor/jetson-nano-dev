ARG BASE
FROM ${BASE}
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt


RUN apt-get update && \
    apt-get install -y  \
    build-essential  \
    software-properties-common \
    tar \
    python3-dev \
    python3-numpy \
    python3-distutils \
    python3-setuptools \
    unzip \
    git \
    wget \
    ca-certificates \
    gnupg2 \
    libssl-dev

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


ARG ENABLE_CUDA

# Source https://github.com/cptnalf/frigate_dockers/blob/ffccb8d13212d83c12055c4bba447889a4222c39/Dockerfile
RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    apt-key adv --fetch-key https://repo.download.nvidia.com/jetson/jetson-ota-public.asc  && \
    echo "deb https://repo.download.nvidia.com/jetson/common r32.6 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    echo "deb https://repo.download.nvidia.com/jetson/t210 r32.6 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    apt-get update && \
    wget http://http.us.debian.org/debian/pool/main/libf/libffi/libffi6_3.2.1-9_arm64.deb && \
    dpkg -i libffi6_3.2.1-9_arm64.deb && \
    rm libffi6_3.2.1-9_arm64.deb && \
    rm -rf /var/lib/apt/lists/* \
    ;fi

RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    mkdir -p /opt/nvidia/l4t-packages/ && \
    touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall && \
    apt-get -qq update && \
    apt-get install --no-install-recommends  -o Dpkg::Options::="--force-overwrite" -o Dpkg::Options::="--force-confdef" -y \
    nvidia-l4t-core \
    nvidia-l4t-multimedia \
    nvidia-l4t-multimedia-utils \
    nvidia-l4t-cuda \
    nvidia-l4t-3d-core \
    nvidia-l4t-wayland \
    nvidia-l4t-x11 \
    nvidia-l4t-firmware \
    nvidia-l4t-tools && \
    ldconfig /usr/lib/aarch64-linux-gnu/tegra \
    ;fi

# install a more recent cmake from source
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.3/cmake-3.23.3.tar.gz && \
    tar -zxvf cmake-3.23.3.tar.gz && \
    cd cmake-3.23.3 && \
    ./bootstrap --parallel=$(nproc) && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/cmake*

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu/tegra/:${LD_LIBRARY_PATH}"
# use gcc 8 becuase of the cuda compiler


RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    /bin/sh -c echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" > /etc/ld.so.conf.d/nvidia-tegra-egl.conf && ldconfig \
    ;fi

RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    apt-get update  && \
    apt-get install -y g++-8 gcc-8 && \
    apt-get install -y cuda-toolkit-10-2 tensorrt &&\
    export CC="/usr/bin/gcc-8" && \
    export CXX="/usr/bin/g++-8" && \
    echo "CC=/usr/bin/gcc-8" >> /etc/environment && \
    echo "CXX=/usr/bin/g++-8" >> /etc/environment && \
    ln -fs $CC /usr/bin/gcc && \
    ln -fs $CC /usr/bin/cc && \
    ln -fs $CXX /usr/bin/g++ && \
    ln -fs $CXX /usr/bin/c++ \
    ;fi

RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    /bin/sh -c echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" > /etc/ld.so.conf.d/nvidia-tegra-egl.conf && ldconfig \
    ;fi

RUN if [ ${ENABLE_CUDA} = "ON" ]; then \
    apt-get install -y && \
    git clone --recurse-submodules -j8 https://github.com/zerollzeng/tiny-tensorrt.git && \
    cd tiny-tensorrt && \
    mkdir build && cd build && \
    cmake \
    -DGPU_ARCH=53 \
    -DBUILD_PYTHON=OFF \
    -DBUILD_SAMPLE=OFF \
    .. && make -j$(nproc) && \
    make install; \
    rm -rf /opt/tiny-tensorrt \
    ;fi

# https://onnxruntime.ai/docs/build/eps.html#tensorrt
# onnxruntime cannot be built currently with "--use_tensorrt" flag. TODO: find a proper tenorrt + onnxruntime combination
# at the moment please use the "tiny-tensorrt" library as wrapper
RUN if [ ${ENABLE_CUDA} = "OFF" ]; then \
    git clone --branch v1.11.0 --recursive -j$(nproc) https://github.com/Microsoft/onnxruntime.git && \
    cd onnxruntime && \
    ./build.sh --config Release --build_shared_lib --parallel && \
    cd build/Linux/Release && \
    make install && \
    rm -rf /opt/onnxruntime \
    ;fi

# install librealsense from repo
ENV REALSENSE_VERSION="2.53.1-0~realsense0*"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE && \
    echo "deb https://librealsense.intel.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/librealsense-apt-source.list && \
    apt-get update && \
    apt-get install -y -f librealsense2=${REALSENSE_VERSION} librealsense2-dev=${REALSENSE_VERSION}

# Build and install OpenCV 4.4 - static library
# Source:
# OpenCV - https://github.com/mdegans/nano_build_opencv/blob/master/build_opencv.sh
#
ARG OPENCV_VERSION="4.7.0"

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
    -D WITH_CUDA=${ENABLE_CUDA} \
    -D CUDA_FAST_MATH=${ENABLE_CUDA} \
    -D ENABLE_FAST_MATH=${ENABLE_CUDA} \
    -D WITH_CUBLAS=${ENABLE_CUDA} \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D BUILD_SHARED_LIBS=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_TBB=ON \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_TESTS=OFF \
    ../

RUN cd opencv/build && make -j$(nproc)
RUN cd opencv/build && make install
RUN cd opencv/build && make package

RUN cd opencv/build && tar -czvf OpenCV-${OPENCV_VERSION}-${ARCH}.tar.gz *.deb && \
    cp OpenCV-${OPENCV_VERSION}-${ARCH}.tar.gz /opt && rm -rf /opt/opencv && rm -rf /opt/opencv_contrib

# install jpeg streamer from source
# TODO: Remove patch branch and use master
RUN git clone https://github.com/nadjieb/cpp-mjpeg-streamer.git && \
    cd cpp-mjpeg-streamer && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/cpp-mjpeg-streamer

# Install boost from source
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar -xzvf boost_1_67_0.tar.gz && \
    cd boost_1_67_0 && \
    ./bootstrap.sh && \
    ./b2 install link=static -j$(nproc) || true  \
    cd ../ && \
    rm -rf /opt/boost*


