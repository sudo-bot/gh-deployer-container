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
	docker run --rm --name test-bench \
		-d \
		--user ${CONTAINER_USER} \
		-p ${TEST_ADDR}:80 \
		-v $(PWD):/home/www/phpMyAdmin \
		-e SKIP_DEPLOY=yes \
		-e MEMORY_LIMIT=254M \
			${IMAGE_TAG}
	sleep 2
	curl --fail -I http://${TEST_ADDR}/
	curl --fail -I http://${TEST_ADDR}/.nginx/status
	curl --fail -I http://${TEST_ADDR}/.phpfpm/status
	docker stop test-bench
