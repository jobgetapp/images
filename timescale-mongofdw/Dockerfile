# Install the Mongo FDW extension on the timescale DB
ARG JG_PG_VERSION=13
ARG JG_TIMESCALE_VERSION=2.11.0
FROM ghcr.io/jobgetapp/timescale:${JG_TIMESCALE_VERSION}-pg${JG_PG_VERSION}-latest as build
ARG JG_PG_VERSION
ARG JG_MONGO_FDW_VERSION=5_5_0

# Install required packages
RUN apt-get update \
  && apt-get install -y \
  wget \
  cmake \
  unzip \
  pkg-config \
  libssl-dev \
  postgresql-server-dev-${JG_PG_VERSION}

# Create driver installation directory
RUN mkdir /opt/drivers
ENV JSONC_INSTALL_DIR=/opt/drivers/json-c
ENV MONGOC_INSTALL_DIR=/opt/drivers/mongo-c

# Install Mongo FDW
ENV PKG_CONFIG_PATH=/tmp/mongo_fdw_source/mongo_fdw-REL-${JG_MONGO_FDW_VERSION}/mongo-c-driver/src/libmongoc/src:/tmp/mongo_fdw_source/mongo_fdw-REL-${JG_MONGO_FDW_VERSION}/mongo-c-driver/src/libbson/src
RUN mkdir /tmp/mongo_fdw_source \
  && cd /tmp/mongo_fdw_source \
  && wget https://github.com/EnterpriseDB/mongo_fdw/archive/refs/tags/REL-${JG_MONGO_FDW_VERSION}.zip \
  && unzip REL-${JG_MONGO_FDW_VERSION}.zip \
  && cd mongo_fdw-REL-${JG_MONGO_FDW_VERSION} \
  && ./autogen.sh --with-master \
  && make \
  && make install

ARG JG_PG_VERSION
ARG JG_TIMESCALE_VERSION
FROM ghcr.io/jobgetapp/timescale:${JG_TIMESCALE_VERSION}-pg${JG_PG_VERSION}-latest

# Copy installed files over
COPY --from=build /usr/share/postgresql /usr/share/postgresql
COPY --from=build /usr/lib/postgresql /usr/lib/postgresql
COPY --from=build /opt/drivers /opt/drivers

# Create driver ld config
RUN echo "/opt/drivers/mongo-c/lib" > /etc/ld.so.conf.d/custom_drivers.conf \
 && ldconfig