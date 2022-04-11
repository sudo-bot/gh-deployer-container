#!/bin/sh

set -eu

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
checkUrl "http://${TEST_ADDR}/index.php"
checkUrl "http://${TEST_ADDR}/robots.txt"

if [ $DID_FAIL -gt 0 ]; then
    echo "Showing logs"
    docker logs test-bench
fi
