set -e

CONTAINER_BASE_NAME="attiladoor/jetson-nano-dev-"

if [ $1 == "arm" ]
then
    if [ ! -z $3 ]
    then
        echo "Invalid positional parameter: ${3}"
        exit 1
    fi

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
    DOCKER_FILE="docker-build/Dockerfile"
elif [ $1 == "x86" ]
then
    if [ $2 == "18" ]
    then
        BASE="ubuntu:18.04"
        VERSION="18"
    elif [ $2 == "20" ]
    then
        BASE="ubuntu:20.04"
        VERSION="20"
    else
        echo "Wrong ubuntu version:" $2
        exit 1
    fi

    ARCH="x86"


    if [ -z $3 ]
    then
        echo "Container variant should be specified"
        exit 1
    elif [ $3 == "run" ]
    then
        VARIANT_TAG="-run"
        BASE="${CONTAINER_BASE_NAME}${ARCH}-${VERSION}-build"
    elif [ $3 == "build" ]
    then
        VARIANT_TAG="-build"
    fi

    DOCKER_FILE="docker${VARIANT_TAG}/Dockerfile"
    ENABLE_CUDA="OFF"

else
    echo "Wrong architecture:" $1
    exit 1
fi

docker build \
    --build-arg BASE=$BASE \
    --build-arg ENABLE_CUDA=$ENABLE_CUDA \
    --build-arg ARCH=$ARCH \
    --tag $CONTAINER_BASE_NAME$ARCH-$VERSION$VARIANT_TAG \
    --file $DOCKER_FILE .
