default: all

arm-18-build:
	bash ./build.sh arm 18
arm-20-build:
	bash ./build.sh arm 20
x86-18-build:
	bash ./build.sh x86 18 build
x86-20-build:
	bash ./build.sh x86 20 build
x86-18-run: x86-18-build
	bash ./build.sh x86 18 run
x86-20-run: x86-20-build
	bash ./build.sh x86 20 run

all: arm-20 x86-20

push-arm-18:
	docker push attiladoor/jetson-nano-dev-arm-18:latest
push-arm-20:
	docker push attiladoor/jetson-nano-dev-arm-20:latest
push-x86-18:
	docker push attiladoor/jetson-nano-dev-x86-18:latest
push-x86-20:
	docker push attiladoor/jetson-nano-dev-x86-20:latest
push-all: push-arm-20 push-x86-20


