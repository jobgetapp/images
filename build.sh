#!/bin/sh
set -ex

JG_PG_VERSION=13
JG_TIMESCALE_VERSION=2.11.0
JG_MONGO_FDW_VERSION=5_5_0

cd timescale
docker build -t ghcr.io/jobgetapp/timescale:2.11.0-pg${JG_PG_VERSION}-latest \
  --build-arg JG_PG_VERSION=${JG_PG_VERSION} \
  --build-arg JG_TIMESCALE_VERSION=${JG_TIMESCALE_VERSION} \
  .

cd ../timescale-mongofdw
docker build -t ghcr.io/jobgetapp/timescale-mongofdw:${JG_MONGO_FDW_VERSION}-ts${JG_TIMESCALE_VERSION}-pg${JG_PG_VERSION}-latest \
  --build-arg JG_PG_VERSION=${JG_PG_VERSION} \
  --build-arg JG_TIMESCALE_VERSION=${JG_TIMESCALE_VERSION} \
  --build-arg JG_MONGO_FDW_VERSION=${JG_MONGO_FDW_VERSION} \
  .
