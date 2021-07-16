VERSION=4.0.1
DOCKER_ID?=shoshii
REPO=${DOCKER_ID}/cassandra-centos

all: build

container:
	@echo "Building ${REPO}:${VERSION}"
	docker build --pull -t ${REPO}:${VERSION} .

build: container

run:
	docker run --net=host -d --name=cassandra ${REPO}:${VERSION}

stop:
	docker ps | grep ${REPO}:${VERSION} | cut -d " " -f 1 | xargs docker stop || echo 'failed to stop'
	docker rm cassandra

push:
	docker -- push ${REPO}:${VERSION}

.PHONY: all build run stop push