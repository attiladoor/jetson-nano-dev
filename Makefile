default: all

arm-20-build:
	bash ./build.sh build arm 20 build
arm-orin-22-build:
	bash ./build.sh build arm-orin 22 build
x86-20-build:
	bash ./build.sh build x86 20 build
x86-20-run: x86-20-build
	bash ./build.sh build x86 20 run

build-all-20: arm-20-build x86-20-run
build-all: build-all-20 arm-orin-22-build

push-arm-20-build:
	bash ./build.sh push arm 20 build
push-x86-20-build:
	bash ./build.sh push x86 20 build
push-x86-20-run:
	bash ./build.sh push x86 20 run
push-arm-orin-22-build:
	bash ./build.sh push arm-orin 22 build

push-all-20: push-arm-20-build push-x86-20-build push-x86-20-run
push-all: push-all-20 push-arm-orin-22-build

all: build-all push-all
