PROJECT_NAME=$(shell basename $$(pwd) | tr '[:upper:]' '[:lower:]')
APP_DOCKERFILE=./docker/app/Dockerfile
IMG_NAME=$(PROJECT_NAME)
APP_DOCKERFILE=./docker/app/Dockerfile
STAGE_BASE=base

DOCKER_RUN_BASE=docker run -it --rm

MAVEN_IMAGE=maven:3-openjdk-17-slim
MAVEN_BASE_COMMAND=$(DOCKER_RUN_BASE) \
                   		-v $(shell pwd):/opt/maven \
                   		-v $(PROJECT_NAME)-maven:/root/.m2 \
                   		-w /opt/maven

.PHONY: build-debug-app
build-debug-app:
	docker build --no-cache --tag $(IMG_NAME)-debug -f $(APP_DOCKERFILE) --target debug .

.PHONY: run-debug
run-debug:
	@$(DOCKER_RUN_BASE) \
		--name $(PROJECT_NAME) \
		-p 5005:5005 \
		$$ARG \
		$(IMG_NAME)-debug

.PHONY: build
build:
	docker build --no-cache --tag $(IMG_NAME)-production -f $(APP_DOCKERFILE) --target production .

.PHONY: run
run:
	@$(DOCKER_RUN_BASE) \
		--name $(PROJECT_NAME) \
		$$ARG \
		$(IMG_NAME)-production

.PHONY: mvn
mvn:
	$(MAVEN_BASE_COMMAND) \
		$(MAVEN_IMAGE) \
		mvn \
		$$ARG

.PHONY: test
test:
	$(MAVEN_BASE_COMMAND) \
		$(MAVEN_IMAGE) \
		mvn \
		test \
		$$ARG

.PHONY: test-debug
test-debug:
	$(MAVEN_BASE_COMMAND) \
		-p 5005:5005 \
		$(MAVEN_IMAGE) \
		mvn \
		-Dmaven.surefire.debug="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005" \
		test \
		$$ARG