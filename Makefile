IMAGE_NAME=sineverba/update-cloudflare-ip
CONTAINER_NAME=update-cloudflare-ip
VERSION=1.0.0-dev
TOPDIR=$(PWD)
BUILDX_VERSION=0.9.1
BINFMT_VERSION=qemu-v7.0.0-28

build:
	docker build --tag $(IMAGE_NAME):$(VERSION) .

multi:
	mkdir -vp ~/.docker/cli-plugins/
	curl --silent -L "https://github.com/docker/buildx/releases/download/v$(BUILDX_VERSION)/buildx-v$(BUILDX_VERSION).linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx version
	docker run --rm --privileged tonistiigi/binfmt:$(BINFMT_VERSION) --install all
	docker buildx ls
	docker buildx rm multiarch
	docker buildx create --name multiarch --driver docker-container --use
	docker buildx inspect --bootstrap --builder multiarch
	docker buildx build --platform linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/amd64 --tag $(IMAGE_NAME):$(VERSION) --push .

inspect:
	docker run \
	--rm -it \
	--entrypoint /bin/sh \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION)

test:
	docker run --rm -it --entrypoint cat --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) /etc/os-release | grep "Alpine Linux"
	docker run --rm -it --entrypoint cat --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) /etc/os-release | grep "3.16.2"

destroy:
	docker image rm $(IMAGE_NAME):$(VERSION)

spin:
	docker run \
	--rm -it \
	-v $(TOPDIR)/config:/config \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION)