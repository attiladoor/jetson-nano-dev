

if [ $1 == "arm" ]
then
    BASE="nvcr.io/nvidia/l4t-base:r32.6.1"
    ENABLE_REALSENSE_CUDA="true"
    ENABLE_OPENCV_CUDA="ON"
    ARCH="arm"
elif [ $1 == "x86" ]
then
    BASE="ubuntu:18.04"
    ENABLE_REALSENSE_CUDA="false"
    OPENCV_CUDA="OFF"
    ARCH="x86"
else
    echo "Wrong architecture:" $1
    exit 1
fi

CONTAINER_NAME="attiladoor/jetson-nano-dev-"

docker build \
    --build-arg BASE=$BASE \
    --build-arg ENABLE_REALSENSE_CUDA=$REALSENSE_CUDA \
    --build-arg ENABLE_OPENCV_CUDA=$OPENCV_CUDA \
    --build-arg ARCH=$ARCH \
    --tag $CONTAINER_NAME$1 \
    --file docker/Dockerfile .