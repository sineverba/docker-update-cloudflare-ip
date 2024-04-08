IMAGE_NAME=sineverba/update-cloudflare-ip
CONTAINER_NAME=update-cloudflare-ip
APP_VERSION=1.2.0-dev
ALPINE_VERSION=3.19.1
BUILDX_VERSION=0.13.1
BINFMT_VERSION=qemu-v7.0.0-28
TOPDIR=$(PWD)

build:
	docker build \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--tag $(IMAGE_NAME):$(APP_VERSION) \
		"."

preparemulti:
	mkdir -vp ~/.docker/cli-plugins
	curl \
		-L \
		"https://github.com/docker/buildx/releases/download/v$(BUILDX_VERSION)/buildx-v$(BUILDX_VERSION).linux-amd64" \
		> \
		~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx version
	docker run --rm --privileged tonistiigi/binfmt:$(BINFMT_VERSION) --install all
	docker buildx ls
	docker buildx rm multiarch
	docker buildx create --name multiarch --driver docker-container --use

multi:
	docker buildx inspect --bootstrap --builder multiarch
	docker buildx build \
		--platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
		--tag $(IMAGE_NAME):$(APP_VERSION) "."

test:
	docker run \
		--rm \
		-it \
		--entrypoint cat \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME):$(APP_VERSION) \
		/etc/os-release | grep "Alpine Linux"
	docker run \
		--rm \
		-it \
		--entrypoint cat \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME):$(APP_VERSION) \
		/etc/os-release | grep $(ALPINE_VERSION)

inspect:
	docker run \
	--rm -it \
	--entrypoint /bin/sh \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(APP_VERSION)

spin:
	docker run \
	--rm -it \
	-v $(TOPDIR)/config:/config \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION)

destroy:
	-docker image rm alpine:$(ALPINE_VERSION)
	docker image rm $(IMAGE_NAME):$(APP_VERSION)