set -e

if [ $1 == "arm" ]
then
    if [ $2 == "18" ]
    then
        BASE="nvcr.io/nvidia/l4t-base:r32.6.1"
    elif [ $2 == "20" ]
    then
        BASE="arm64v8/ubuntu:20.04"
    else
        echo "Wrong ubuntu version:" $2
        exit 1
    fi
    ENABLE_CUDA="ON"
    ARCH="arm"
elif [ $1 == "x86" ]
then
    if [ $2 == "18" ]
    then
        BASE="ubuntu:18.04"
    elif [ $2 == "20" ]
    then
        BASE="ubuntu:20.04"
    else
        echo "Wrong ubuntu version:" $2
        exit 1
    fi
    ENABLE_CUDA="OFF"
    ARCH="x86"
else
    echo "Wrong architecture:" $1
    exit 1
fi

CONTAINER_NAME="attiladoor/jetson-nano-dev-"

docker build \
    --build-arg BASE=$BASE \
    --build-arg ENABLE_CUDA=$ENABLE_CUDA \
    --build-arg ARCH=$ARCH \
    --tag $CONTAINER_NAME$1-$2 \
    --file docker/Dockerfile .
