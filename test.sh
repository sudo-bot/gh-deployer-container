#!/bin/sh

set -eu

docker run --rm --name test-bench \
		-d \
		--user ${CONTAINER_USER} \
		-p ${TEST_ADDR}:80 \
		-v ${PWD}:/home/www/phpMyAdmin \
		-e SKIP_DEPLOY=yes \
		-e MEMORY_LIMIT=254M \
			${IMAGE_TAG}

sleep 2

DID_FAIL=0

checkUrl() {
    set +e
    curl --fail -I "${1}"
    if [ $? -gt 0 ]; then
        DID_FAIL=1
        echo "ERR: for URL ${1}"
    fi
    set -e
}

echo "Running tests..."

checkUrl "http://${TEST_ADDR}/"
checkUrl "http://${TEST_ADDR}/.nginx/status"
checkUrl "http://${TEST_ADDR}/.phpfpm/status"

if [ $DID_FAIL -gt 0 ]; then
    echo "Showing logs"
    docker logs test-bench
fi

echo "Stopping and removing the container"
docker stop test-bench
