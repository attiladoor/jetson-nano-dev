default: all

arm:
	bash ./build.sh arm
x86:
	bash ./build.sh x86
all: arm x86

push-arm:
	docker push attiladoor/jetson-nano-dev-arm:latest
push-x86:
	docker push attiladoor/jetson-nano-dev-x86:latest
push-all: push-arm push-x86


