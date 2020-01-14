FROM golang:1.11.4-alpine

ENV GOOFYS_VERSION=v0.23.1

RUN apk add --no-cache \
      curl \
      fuse

RUN curl -sSL https://github.com/kahing/goofys/releases/download/${GOOFYS_VERSION}/goofys -o /usr/local/bin/goofys \
    && chmod 755 /usr/local/bin/goofys \
    && mkdir -p /mnt/s3

ENV MOUNT_DIR=/mnt/s3 \
    REGION=ap-northeast-1 \
    STAT_CACHE_TTL=1m0s \
    TYPE_CACHE_TTL=1m0s \
    DIR_MODE=0755 \
    FILE_MODE=0600

ENTRYPOINT ["sh"]

CMD [ \
    "-c", \
    "goofys \
        -f \
        --region ${REGION} \
        -o allow_other \
        --dir-mode ${DIR_MODE} \
        --file-mode ${FILE_MODE} \
        --stat-cache-ttl ${STAT_CACHE_TTL} \
        --type-cache-ttl ${TYPE_CACHE_TTL} \
        ${BUCKET} \
        ${MOUNT_DIR}" \
]

LABEL com.aznyan.docker.image.name=goofys
LABEL com.aznyan.docker.image.arch=amd64
LABEL com.aznyan.docker.image.app.version=${GOOFYS_VERSION}
LABEL com.aznyan.docker.image.revision=1.0.0

