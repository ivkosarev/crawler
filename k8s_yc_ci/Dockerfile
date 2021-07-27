FROM alpine:3.7

# ARG VERSION
ENV KUBE_VERSION=1.19

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && apk add --update bash \
 && curl -L https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

WORKDIR /root
# ENTRYPOINT ["kubectl"]
# CMD ["help"]
