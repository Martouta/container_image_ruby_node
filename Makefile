IMAGE_BASE_NAME = martouta/ruby_node

build: Dockerfile
	docker build -t $(IMAGE_BASE_NAME):$(version) .

test:
	docker run --rm $(IMAGE_BASE_NAME):$(version) ruby -v | grep 3.2.0
	docker run --rm $(IMAGE_BASE_NAME):$(version) bundler --version | grep 'Bundler version 2.2.33'
	docker run --rm $(IMAGE_BASE_NAME):$(version) node -v | grep v18.18.2
	docker run --rm $(IMAGE_BASE_NAME):$(version) yarn --version | grep 1.22
	docker run --rm $(IMAGE_BASE_NAME):$(version) pwd | grep '/root'
	docker run --rm $(IMAGE_BASE_NAME):$(version) cat /etc/issue | grep 'Debian GNU/Linux 11'

deploy:
	docker push $(IMAGE_BASE_NAME):$(version)
	gh release create $(version) --title "$(version)" --notes "It can be found in [DockerHub](https://hub.docker.com/r/$(IMAGE_BASE_NAME)/tags) as of version $(version)"
	git fetch -t
