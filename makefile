# Setup ————————————————————————————————————————————————————————————————————————————————————————————————————————————————

# Static ———————————————————————————————————————————————————————————————————————————————————————————————————————————————
PROJECT_NAME=$(shell basename $$(pwd) | tr '[:upper:]' '[:lower:]')
APP_DOCKERFILE=./docker/app/Dockerfile
JAVA_APP_SERVICE=java-app
#IMG_NAME=$(PROJECT_NAME)

# Docker conf ——————————————————————————————————————————————————————————————————————————————————————————————————————————
DOCKER_RUN=docker run -it --rm

MAVEN_IMAGE=maven:3-openjdk-17-slim
MAVEN_BASE_COMMAND=$(DOCKER_RUN) \
                   		-v $(shell pwd):/opt/maven \
                   		-v $(PROJECT_NAME)-maven:/root/.m2 \
                   		-w /opt/maven

ifeq ($(wildcard ./docker/docker-compose.override.yml),)
	COMPOSE_OVERRIDE=
else
	COMPOSE_OVERRIDE=-f ./docker/docker-compose.override.yml
endif

COMPOSE=docker compose -f ./docker/docker-compose.yml $(COMPOSE_OVERRIDE)

# Docker commands - DEV ————————————————————————————————————————————————————————————————————————————————————————————————
.PHONY: build-dev-app
build-dev-app:
	docker build --no-cache --tag $(JAVA_APP_SERVICE)-dev -f $(APP_DOCKERFILE) --target debug .
	@#$(COMPOSE) -f ./docker/docker-compose.dev.yml --project-name dc-$(PROJECT_NAME)-dev build --no-cache $$ARG

.PHONY: run-dev-app
run-dev-app:
	@#$(DOCKER_RUN) --name $(PROJECT_NAME) -p 5005:5005 $$ARG $(IMG_NAME)-debug
	$(COMPOSE) -f ./docker/docker-compose.dev.yml --project-name dc-$(PROJECT_NAME)-dev run --rm --publish "5005:5005" $(JAVA_APP_SERVICE) $$ARG

# Docker commands ——————————————————————————————————————————————————————————————————————————————————————————————————————

.PHONY: build
build:
	@#docker (no compose)
	docker build --no-cache --tag $(JAVA_APP_SERVICE) -f $(APP_DOCKERFILE) --target production .
	@#$(COMPOSE) -f ./docker/docker-compose.prod.yml --project-name dc-$(PROJECT_NAME)-prod build --no-cache $$ARG

.PHONY: run
run:
	@#docker (no compose)
	@#@$(DOCKER_RUN) --name dc-$(PROJECT_NAME)-prod $$ARG $(IMG_NAME)-production
	$(COMPOSE) -f ./docker/docker-compose.prod.yml --project-name dc-$(PROJECT_NAME)-prod run --rm $(JAVA_APP_SERVICE) $$ARG

# Maven ————————————————————————————————————————————————————————————————————————————————————————————————————————————————

.PHONY: mvn
mvn:
	$(MAVEN_BASE_COMMAND) $(MAVEN_IMAGE) mvn $$ARG

# Test commands ————————————————————————————————————————————————————————————————————————————————————————————————————————

.PHONY: test
test:
	@#$(MAVEN_BASE_COMMAND) $(MAVEN_IMAGE) mvn test $$ARG
	$(COMPOSE) -f ./docker/docker-compose.prod.yml --project-name dc-$(PROJECT_NAME)-prod run --rm $(JAVA_APP_SERVICE)-test mvn test $$ARG

.PHONY: test-debug
test-debug:
	@#$(MAVEN_BASE_COMMAND) -p 5005:5005 $(MAVEN_IMAGE) mvn -Dmaven.surefire.debug="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005" test $$ARG
	$(COMPOSE) -f ./docker/docker-compose.dev.yml --project-name dc-$(PROJECT_NAME)-dev run --rm --publish "5005:5005" $(JAVA_APP_SERVICE)-test mvn -Dmaven.surefire.debug="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005" test $$ARG