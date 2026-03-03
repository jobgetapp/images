# Build Node AWS Lambda
ARG JG_NODE_VERSION=13
FROM public.ecr.aws/docker/library/node:${JG_NODE_VERSION}-bookworm as build-image

RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

RUN mkdir /var/lmd && cd /var/lmd && npm install aws-lambda-ric

FROM public.ecr.aws/docker/library/node:${JG_NODE_VERSION}-slim

COPY --from=build-image /var/lmd /var/lmd
