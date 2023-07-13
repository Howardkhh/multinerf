IMAGE = howardkhh/multinerf
DATA = $(shell readlink -f data)
SHMEM_SIZE = 32G

build:
	docker build -t $(IMAGE) ./ < Dockerfile

start:
	docker run --rm	-i -t \
		-v $(PWD):/root/multinerf \
		-v $(DATA):/root/multinerf/data \
		--gpus all \
		--shm-size $(SHMEM_SIZE) \
		$(IMAGE)
