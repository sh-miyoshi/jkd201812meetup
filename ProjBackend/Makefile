ifndef APISERVER_IMAGE_NAME
	APISERVER_IMAGE_NAME="docker.io/smiyoshi/sectest-apiserver:latest"
endif

ifndef APISERVER_IMAGE_VERSION
	APISERVER_IMAGE_VERSION="latest"
endif

ifndef MYSQL_IMAGE_NAME
	MYSQL_IMAGE_NAME="docker.io/smiyoshi/sectest-database:latest"
endif

ifndef MYSQL_IMAGE_VERSION
	MYSQL_IMAGE_VERSION="latest"
endif


all: build

build:
	docker build -t $(APISERVER_IMAGE_NAME):$(APISERVER_IMAGE_VERSION) --build-arg http_proxy="$(http_proxy)" --build-arg https_proxy="$(https_proxy)" -f Dockerfile.apiserver .
	docker build -t $(MYSQL_IMAGE_NAME):$(MYSQL_IMAGE_VERSION) --build-arg http_proxy="$(http_proxy)" --build-arg https_proxy="$(https_proxy)" -f Dockerfile.mysql .

ci_push:
	docker push $(APISERVER_IMAGE_NAME):$(APISERVER_IMAGE_NAME)
	docker push $(MYSQL_IMAGE_NAME):$(MYSQL_IMAGE_VERSION)
