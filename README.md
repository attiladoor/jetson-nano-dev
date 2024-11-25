# jetson-nano-dev
Docker build environment based on ubuntu 20.04 meant for computer vision / ML applications on Nvidia's jetson nano board, aside with an x86 (CPU only) test and run evirnonment for local testing. 

### Content
The following packages are installed:
* CMake 3.23
* OpenCV 4.7 with GPU support on Jetson Nano and 4.10 on Orin 
* Librealsense 2.53 with GPU support (from repo)
* Cuda toolkit 10.2 / 12.2
* TensorRT: 8.2 / 8.6
* Tiny tensor: TensorRT wrapper
* OnnxRuntime: 1.11 with TensorRT support

## Pre-requisites
```bash
sudo apt-get install qemu binfmt-support qemu-user-static
```

## Variants
* jetson-nano-dev-arm-20-build: default build environment
* jetson-nano-dev-x86-20-build: x86 test environment with only CPU support to test algorithms locally
* jetson-nano-dev-x86-20-run: runtime env based on the build container 

## How to build
```bash
make build-all-20
```

## Docker-hub

* https://hub.docker.com/r/attiladoor/jetson-nano-dev-arm-20-build
* https://hub.docker.com/r/attiladoor/jetson-nano-dev-x86-20-build
* https://hub.docker.com/r/attiladoor/jetson-nano-dev-x86-20-run

See the corresponding release tags
