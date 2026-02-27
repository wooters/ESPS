# Build and test inside an Ubuntu 24.04 container (requires macOS container CLI)
CONTAINER_TAG = esps-test

.PHONY: container-test
container-test:
	container build --tag $(CONTAINER_TAG) --file Dockerfile .
	container run --rm $(CONTAINER_TAG)
