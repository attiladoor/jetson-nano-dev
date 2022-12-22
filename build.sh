set -e

CONTAINER_BASE_NAME="attiladoor/jetson-nano-dev-"
DOCKER_COMMAND=$1
ARCH=$2
UBUNTU_VERSION=$3
VARIANT_OPT=$4

if [ -z $VERSION ]
then
    VERSION=latest
fi

if [ $ARCH == "arm" ]
then
    # if [ ! -z $VARIANT_OPT ]
    # then
    #     echo "Invalid positional parameter: ${VARIANT_OPT}"
    #     exit 1
    # fi

    if [ $UBUNTU_VERSION == "18" ]
    then
        BASE="nvcr.io/nvidia/l4t-base:r32.6.1"
    elif [ $UBUNTU_VERSION == "20" ]
    then
        BASE="arm64v8/ubuntu:20.04"
    else
        echo "Wrong ubuntu version:" $UBUNTU_VERSION
        exit 1
    fi
    ENABLE_CUDA="ON"
    DOCKER_FILE="docker-build/Dockerfile"
    VARIANT_TAG="-build"
elif [ $ARCH == "x86" ]
then
    if [ $UBUNTU_VERSION == "18" ]
    then
        BASE="ubuntu:18.04"
    elif [ $UBUNTU_VERSION == "20" ]
    then
        BASE="ubuntu:20.04"
    else
        echo "Wrong ubuntu version:" $UBUNTU_VERSION
        exit 1
    fi

    ARCH="x86"

    if [ -z $VARIANT_OPT ]
    then
        echo "Container variant should be specified"
        exit 1
    elif [ $VARIANT_OPT == "run" ]
    then
        VARIANT_TAG="-run"
        BASE="${CONTAINER_BASE_NAME}${ARCH}-${UBUNTU_VERSION}-build:${VERSION}"
    elif [ $VARIANT_OPT == "build" ]
    then
        VARIANT_TAG="-build"
    fi

    DOCKER_FILE="docker${VARIANT_TAG}/Dockerfile"
    ENABLE_CUDA="OFF"

else
    echo "Wrong architecture:" $ARCH
    exit 1
fi

if [[ $DOCKER_COMMAND == "build" ]]
then
    docker buildx build \
        --build-arg BASE=$BASE \
        --build-arg ENABLE_CUDA=$ENABLE_CUDA \
        --build-arg ARCH=$ARCH \
        --tag $CONTAINER_BASE_NAME$ARCH-$UBUNTU_VERSION$VARIANT_TAG:$VERSION \
        --file $DOCKER_FILE .
elif [[ $DOCKER_COMMAND == "push" ]]
then
echo $CONTAINER_BASE_NAME$ARCH-$UBUNTU_VERSION$VARIANT_TAG:$VERSION
docker push $CONTAINER_BASE_NAME$ARCH-$UBUNTU_VERSION$VARIANT_TAG:$VERSION
else
echo "Invalid docker command $DOCKER_COMMAND"
fi
