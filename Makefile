IMAGE_TAG ?= gh-deploy-container
TEST_ADDR ?= 127.0.0.77:9099
CONTAINER_USER ?= "0:$(shell id -g)"

.PHONY: docker-build

all: docker-build docker-test

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG) \
		--pull

docker-test:
	CONTAINER_USER="${CONTAINER_USER}" \
	TEST_ADDR="${TEST_ADDR}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	./test.sh
