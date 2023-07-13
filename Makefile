IMAGE = howardkhh/multinerf
SHMEM_SIZE = 32G

build:
	docker build -t $(IMAGE) ./ < Dockerfile

start:
	docker run --rm	-i -t \
		-v $(PWD):/root/multinerf \
		--gpus all \
		--shm-size $(SHMEM_SIZE) \
		$(IMAGE)
