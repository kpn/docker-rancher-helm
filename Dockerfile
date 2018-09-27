FROM alpine AS kubectl_helm

##### prepare
RUN apk add --update -t deps curl

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

FROM rancher/cli:v2.0.4

LABEL maintainer="KPN D-Nitro team"

ARG VCS_REF
ARG BUILD_DATE
##### Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kpn/docker-rancher" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

##### install bash
RUN apk add --update bash && rm /var/cache/apk/*

##### copy kubectl
COPY --from=kubectl_helm /usr/local/bin/kubectl /usr/local/bin/kubectl
##### copy helm
COPY --from=kubectl_helm /usr/local/bin/helm /usr/local/bin/helm

##### run
ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "rancher" ]
