ARG BASE
FROM ${BASE}

# install mqtt broker
RUN apt-get update && \
    apt-get install -y mosquitto gdb

RUN pip3 install paho-mqtt


# install gtest
RUN git clone https://github.com/google/googletest.git && \
    cd googletest && \
    mkdir build && cd build && \
    cmake .. -DBUILD_SHARED_LIBS=ON -DINSTALL_GTEST=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd ../../ && \
    rm -rf googletest

# install nodejs
RUN apt-get update && \
    apt-get install -y nodejs npm

# install realsense python
RUN pip3 install pyrealsense2

RUN pip3 install onnxruntime-gpu onnx
