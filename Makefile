default: all

arm-18-build:
	bash ./build.sh build arm 18
arm-20-build:
	bash ./build.sh build arm 20
x86-18-build:
	bash ./build.sh build x86 18 build
x86-20-build:
	bash ./build.sh build x86 20 build
x86-18-run: x86-18-build
	bash ./build.sh build x86 18 run
x86-20-run: x86-20-build
	bash ./build.sh build x86 20 run

build-all-20: arm-20-build x86-20-run
build-all-18: arm-18-build x86-18-run
build-all: build-all-20 build-all-18

push-arm-18-build:
	bash ./build.sh push arm 18 build
push-arm-20-build:
	bash ./build.sh push arm 20 build
push-x86-18-build:
	bash ./build.sh push x86 18 build
push-x86-20-build:
	bash ./build.sh push x86 20 build
push-x86-18-run:
	bash ./build.sh push x86 18 run
push-x86-20-run:
	bash ./build.sh push x86 20 run

push-all-20: push-arm-20-build push-x86-20-build push-x86-20-run
push-all-18: push-arm-18-build push-x86-18-build push-x86-18-run
push-all: push-all-18 push-all-20

all: build-all push-all
