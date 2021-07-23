VERSION=4.0.1
DOCKER_ID?=shoshii
REPO=${DOCKER_ID}/cassandra-centos

all: build

container:
	@echo "Building ${REPO}:${VERSION}"
	rm -fR rpms/*
	cp cassandra/build/rpmbuild/RPMS/noarch/* rpms/
	docker build --pull -t ${REPO}:${VERSION}  \
		--build-arg PKG_NAME=`find rpms -type f -printf '%f\n' | grep -e "cassandra-[0-9].*"`  \
		--build-arg TOOL_PKG_NAME=`find rpms -type f -printf '%f\n' | grep -e "cassandra-tools-[0-9].*"` .

build: container

run:
	docker run --net=host -it --name=cassandra ${REPO}:${VERSION} /bin/bash

stop:
	docker ps | grep ${REPO}:${VERSION} | cut -d " " -f 1 | xargs docker stop || echo 'failed to stop'
	docker rm cassandra

push:
	docker -- push ${REPO}:${VERSION}

.PHONY: all build run stop push