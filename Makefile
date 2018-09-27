REPOSITORY=kpnnv
IMAGE=docker-rancher

docker/build/%:
	docker build -t $(REPOSITORY)/$(IMAGE):$* .

docker/push/%:
	docker push $(REPOSITORY)/$(IMAGE):$*
