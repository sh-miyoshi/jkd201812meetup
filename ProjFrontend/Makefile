ifndef DOCKER_IMAGE_NAME
	DOCKER_IMAGE_NAME="docker.io/smiyoshi/sectest-frontend:latest"
endif

ifndef DOCKER_IMAGE_VERSION
	DOCKER_IMAGE_VERSION="latest"
endif


all: build

build:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --build-arg http_proxy="$(http_proxy)" --build-arg https_proxy="$(https_proxy)" .

ci_push:
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)