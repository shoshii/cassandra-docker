VERSION=4.0.1
DOCKER_ID?=shoshii
REPO=${DOCKER_ID}/cassandra-centos

all: build

rpmbuild:
	cd cassandra && ant realclean
	cd cassandra && ant artifacts -Drelease=true
	cd cassandra && mkdir -p build/rpmbuild/{BUILD,RPMS,SPECS,SRPMS}
	cd cassandra && rpmbuild --define="version ${VERSION}" \
                        --define="revision `date +"%Y%m%d"`git`git rev-parse --short HEAD`%{?dist}" \
                        --define "_topdir `pwd`/build/rpmbuild" \
                        --define "_sourcedir `pwd`/build" \
                        -ba redhat/cassandra.spec

container:
	@echo "Building ${REPO}:${VERSION}"
	rm -fR rpms/*
	cp cassandra/build/rpmbuild/RPMS/noarch/* rpms/
	docker build --pull -t ${REPO}:${VERSION} --build-arg PKG_NAME=`find rpms -type f -printf '%f\n' | grep -e "cassandra-[0-9].*"` --build-arg TOOL_PKG_NAME=`find rpms -type f -printf '%f\n' | grep -e "cassandra-tools-[0-9].*"` .

build: rpmbuild container

run:
	docker run --net=host -it --name=cassandra ${REPO}:${VERSION} /bin/bash

stop:
	docker ps | grep ${REPO}:${VERSION} | cut -d " " -f 1 | xargs docker stop || echo 'failed to stop'
	docker rm cassandra

push:
	docker -- push ${REPO}:${VERSION}

.PHONY: all rpmbuild build run stop push