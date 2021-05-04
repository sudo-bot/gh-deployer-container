IMAGE_TAG ?= gh-deploy-container
TEST_PORT ?= 9099

.PHONY: docker-build

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG)

docker-test:
	docker run --rm --name test-bench \
		-d \
		--user "0:$(id -g)" \
		-p $(TEST_PORT):80 \
		-v $(PWD):/home/www/phpMyAdmin \
		-e SKIP_DEPLOY=yes \
		-e MEMORY_LIMIT=254M \
			$(IMAGE_TAG)
	sleep 2
	curl -I http://127.0.0.1:$(TEST_PORT)/
	curl -I http://127.0.0.1:$(TEST_PORT)/.nginx/status
	curl -I http://127.0.0.1:$(TEST_PORT)/.phpfpm/status
	docker stop test-bench
