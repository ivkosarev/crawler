FROM alpine:latest

# ARG VERSION
ENV KUBE_VERSION=1.19

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && apk add --update bash \
 && apk add --update openssl \
 && curl -L https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && cd /root \
 && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
 && bash get_helm.sh \
#  && chmod 700 get_helm.sh \
#  && ./get_helm.sh \
 && apk del --purge deps \
 && rm /var/cache/apk/*

WORKDIR /root
# ENTRYPOINT ["kubectl"]
# CMD ["help"]
