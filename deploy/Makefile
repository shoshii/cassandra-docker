VERSION=4.0.1
DOCKER_ID?=shoshii
REPO=${DOCKER_ID}/cassandra-centos

NODE_DC=dc1
NODE_RACK=rack1
NODE_IP=
SEEDS=

all: build
build:
	pip3 install jinja2 --user && python3 generate_node_conf.py ${NODE_IP} ${SEEDS} --dc=${NODE_DC} --rack=${NODE_RACK}
	docker build --pull -t ${REPO}-${NODE_IP}:${VERSION} --build-arg VERSION=${VERSION} .
run:
	docker run --net=host -d --rm --name=cassandra-${NODE_IP} ${REPO}-${NODE_IP}:${VERSION}
stop:
	docker ps | grep ${REPO}-${NODE_IP} | cut -d " " -f 1 | xargs docker stop || echo 'failed to stop'
push: build
	docker -- push ${REPO}-${NODE_IP}:${VERSION}
.PHONY: all build run stop push