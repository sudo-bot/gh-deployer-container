IMAGE_TAG ?= gh-deploy-container
TEST_ADDR ?= 127.0.0.77:9099
CONTAINER_USER ?= "0:$(shell id -g)"

.PHONY: docker-build docker-test run-test cleanup-test test

all: docker-build docker-test

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG) \
		--pull

docker-test:
	TEST_ADDR="${TEST_ADDR}" ./test.sh

test: run-test test cleanup-test

run-test:
	TEST_ADDR="${TEST_ADDR}" \
	CONTAINER_USER="${CONTAINER_USER}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml up -d
	# --exit-code-from=sut --abort-on-container-exit

	docker exec test-bench curl --fail -o ./upgradephpmyadmin.sh https://gist.githubusercontent.com/williamdes/883f2158f17e9ed5a83d892ada56f5df/raw/40a79cdf948ba7d702e19b923125631aec821a05/upgradephpmyadmin.sh
	docker exec test-bench sh -eu ./upgradephpmyadmin.sh "/home/www/" nobody nobody "" phpMyAdmin
	docker cp tests/config.inc.php test-bench:/home/www/phpMyAdmin/config.inc.php
	@sleep 2
	@echo "You can browse: http://${TEST_ADDR}"

cleanup-test:
	@echo "Stopping and removing the container"
	TEST_ADDR="${TEST_ADDR}" \
	CONTAINER_USER="${CONTAINER_USER}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml down
