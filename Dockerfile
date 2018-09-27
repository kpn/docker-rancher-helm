FROM rancher/cli:v2.0.4

LABEL maintainer="KPN D-Nitro team"

ARG VCS_REF
ARG BUILD_DATE

##### Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kpn/docker-rancher" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

##### prepare
RUN apk add --update bash \
 && apk add --update -t deps curl \
 && curl -k -X GET https://artifacts.kpn.org/devsupport-local/scripts/linux_trust_ca_cert_0.1.0.sh | bash -s

##### kubectl
ENV KUBE_LATEST_VERSION="v1.11.3"

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

##### helm
ENV HELM_LATEST_VERSION="v2.11.0"

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz

##### generic cleanup
RUN apk del --purge deps && rm /var/cache/apk/*

##### k8s files
COPY k8s/ /k8s/
WORKDIR /k8s

##### run
ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "rancher" ]
