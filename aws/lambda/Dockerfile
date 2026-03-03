# Build Node AWS Lambda
FROM public.ecr.aws/docker/library/node:22-bookworm as build-image

RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

RUN mkdir /var/lmd && cd /var/lmd && npm install aws-lambda-ric

FROM public.ecr.aws/docker/library/node:22-slim

COPY --from=build-image /var/lmd /var/lmd
