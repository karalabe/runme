ALPINE_VERSIONS := "" 3.20 3.21
GO_VERSIONS     := "" 1.23 1.23.0 1.23.1 1.23.2 1.23.3 1.23.4
RUST_VERSIONS   := "" 1.83 1.83.0

IMAGE_NAME := karalabe/runme

build: build-shell build-go build-rust

build-shell:
	for alpine in $(ALPINE_VERSIONS); do \
		docker buildx build --platform linux/amd64,linux/arm64 \
			--build-arg ALPINE_VERSION=$$alpine \
			-t $(IMAGE_NAME):shell-alpine$$alpine -f Dockerfile.shell .; \
  	done

build-go:
	for alpine in $(ALPINE_VERSIONS); do \
		for go in $(GO_VERSIONS); do \
			docker buildx build --platform linux/amd64,linux/arm64 \
				--build-arg ALPINE_VERSION=$$alpine \
				--build-arg GO_VERSION=$$go \
				-t $(IMAGE_NAME):golang$$go-alpine$$alpine -f Dockerfile.golang .; \
  		done; \
  	done

build-rust:
	for alpine in $(ALPINE_VERSIONS); do \
		for rust in $(RUST_VERSIONS); do \
			docker buildx build --platform linux/amd64,linux/arm64 \
				--build-arg ALPINE_VERSION=$$alpine \
				--build-arg RUST_VERSION=$$rust \
				-t $(IMAGE_NAME):rust$$rust-alpine$$alpine -f Dockerfile.rust .; \
  		done; \
  	done

push: push-shell push-go push-rust

push-shell:
	for alpine in $(ALPINE_VERSIONS); do \
		docker push $(IMAGE_NAME):shell-alpine$$alpine; \
  	done

push-go:
	for alpine in $(ALPINE_VERSIONS); do \
		for go in $(GO_VERSIONS); do \
			docker push $(IMAGE_NAME):golang$$go-alpine$$alpine; \
  		done; \
  	done

push-rust:
	for alpine in $(ALPINE_VERSIONS); do \
		for rust in $(RUST_VERSIONS); do \
			docker push $(IMAGE_NAME):rust$$rust-alpine$$alpine; \
  		done; \
  	done

clean: clean-shell clean-go clean-rust

clean-shell:
	for alpine in $(ALPINE_VERSIONS); do \
		docker rmi $(IMAGE_NAME):shell-alpine$$alpine; \
  	done

clean-go:
	for alpine in $(ALPINE_VERSIONS); do \
		for go in $(GO_VERSIONS); do \
			docker rmi $(IMAGE_NAME):golang$$go-alpine$$alpine; \
  		done; \
  	done

clean-rust:
	for alpine in $(ALPINE_VERSIONS); do \
		for rust in $(RUST_VERSIONS); do \
			docker rmi $(IMAGE_NAME):rust$$rust-alpine$$alpine; \
  		done; \
  	done

.PHONY: all clean
