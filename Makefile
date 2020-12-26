-include: .env

IMAGE=rockyburt/glances
GLANCES_VERSION=3.1.5
VERSION=${GLANCES_VERSION}-1

build_images:
	docker build -t $(IMAGE):latest \
		--build-arg GLANCES_VERSION=$(GLANCES_VERSION) \
		-t $(IMAGE):$(VERSION) \
		.

release_images:
	docker buildx build \
		$(DOCKER_BUILDX_ARGS) \
		--push \
		--build-arg GLANCES_VERSION=$(GLANCES_VERSION) \
		--platform linux/arm,linux/arm64,linux/amd64 \
		-t $(IMAGE):latest -t $(IMAGE):$(VERSION) .

	docker buildx build \
		$(DOCKER_BUILDX_ARGS) \
		--push \
		--build-arg GLANCES_VERSION=$(GLANCES_VERSION) \
		--platform linux/amd64 \
		-t $(IMAGE):latest-amd64 -t $(IMAGE):$(VERSION)-amd64 .

	docker buildx build \
		$(DOCKER_BUILDX_ARGS) \
		--push \
		--build-arg GLANCES_VERSION=$(GLANCES_VERSION) \
		--platform linux/arm64 \
		-t $(IMAGE):latest-arm64 -t $(IMAGE):$(VERSION)-arm64 .

	docker buildx build \
		$(DOCKER_BUILDX_ARGS) \
		--push \
		--build-arg GLANCES_VERSION=$(GLANCES_VERSION) \
		--platform linux/arm \
		-t $(IMAGE):latest-arm64 -t $(IMAGE):$(VERSION)-arm .
