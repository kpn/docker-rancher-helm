REPOSITORY=kpnnv
IMAGE=docker-rancher

docker/build/%:
	docker build \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    -t $(REPOSITORY)/$(IMAGE):$* .

docker/push/%:
	docker push $(REPOSITORY)/$(IMAGE):$*
