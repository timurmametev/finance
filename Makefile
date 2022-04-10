init: docker-clear docker-pull docker-build docker-up api-init
start: docker-up
stop: docker-down
restart: stop start
lint: api-lint
analyze: api-analyze

# Development docker images

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-build:
	docker-compose build --no-cache

docker-pull:
	docker-compose pull

docker-clear:
	docker-compose down -v --remove-orphans

# Build docker production images

build: build-gateway build-frontend build-api

build-gateway:
	docker --log-level=debug build --pull --file=gateway/docker/production/nginx/Dockerfile --tag=${REGISTRY}/finance-gateway:${IMAGE_TAG} gateway/docker

build-frontend:
	docker --log-level=debug build --pull --file=frontend/docker/production/nginx/Dockerfile --tag=${REGISTRY}/finance-frontend:${IMAGE_TAG} frontend

build-api:
	docker --log-level=debug build --pull --file=api/docker/production/php-fpm/Dockerfile --tag=${REGISTRY}/finance-api-php-fpm:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/production/php-cli/Dockerfile --tag=${REGISTRY}/finance-api-php-cli:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/production/nginx/Dockerfile --tag=${REGISTRY}/finance-api:${IMAGE_TAG} api

try-build:
	REGISTRY=localhost IMAGE_TAG=0 make build

# Push docker images

push: push-gateway push-frontend push-api

push-gateway:
	docker push ${REGISTRY}/finance-gateway:${IMAGE_TAG}

push-frontend:
	docker push ${REGISTRY}/finance-frontend:${IMAGE_TAG}

push-api:
	docker push ${REGISTRY}/finance-api-php-fpm:${IMAGE_TAG}
	docker push ${REGISTRY}/finance-api-php-cli:${IMAGE_TAG}
	docker push ${REGISTRY}/finance-api:${IMAGE_TAG}

# Initial api

api-init: api-composer-install

api-composer-install:
	docker-compose run --rm api-php-cli composer install

# Code checking

api-lint:
	docker-compose run --rm api-php-cli composer lint
	docker-compose run --rm api-php-cli composer cs-check

api-analyze:
	docker-compose run --rm api-php-cli composer psalm