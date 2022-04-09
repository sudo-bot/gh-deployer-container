#!/bin/sh

set -eu

docker run --rm --name test-bench \
		-d \
		--user ${CONTAINER_USER} \
        --workdir /home/www/phpMyAdmin \
		-p ${TEST_ADDR}:80 \
		-e SKIP_DEPLOY=yes \
		-e MEMORY_LIMIT=254M \
			${IMAGE_TAG}

docker exec test-bench ls -lah /home/www
docker exec test-bench curl --fail -o ./upgradephpmyadmin.sh https://gist.githubusercontent.com/williamdes/883f2158f17e9ed5a83d892ada56f5df/raw/e5ceceaa0c146e249146d9f2153749b0e02fd0f9/upgradephpmyadmin.sh
docker exec test-bench sh -eu ./upgradephpmyadmin.sh "/home/www/" nobody nobody "" phpMyAdmin
docker exec test-bench ls -lah /home/www

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
