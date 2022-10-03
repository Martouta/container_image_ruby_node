IMAGE_NAME = martouta/ruby_node

all: build test

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

test:
	docker run --rm $(IMAGE_NAME) ruby -v | grep 3.1.2
	docker run --rm $(IMAGE_NAME) bundler --version | grep 'Bundler version 2.2.33'
	docker run --rm $(IMAGE_NAME) node -v | grep v18.10.0
	docker run --rm $(IMAGE_NAME) yarn --version | grep 1.22
	docker run --rm $(IMAGE_NAME) pwd | grep '/root'
	docker run --rm $(IMAGE_NAME) cat /etc/issue | grep 'Debian GNU/Linux 11'
