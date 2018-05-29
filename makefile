IMAGE_NAME=ipman1971/hive-zulu
CONTAINER_NAME=hive-container

default: build

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -itd --name $(CONTAINER_NAME) -h localhost \
		-p 8088:8088 -p 50070:50070 -p 50090:50090 -p 10000:10000 \
		-p 10002:10002 $(IMAGE_NAME)

attach:
	docker attach $(CONTAINER_NAME)

clean:
	docker rm -vf $(CONTAINER_NAME)

clean-image:
	docker rmi -f $(IMAGE_NAME)
