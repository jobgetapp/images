# Install the Mongo FDW extension on the timescale DB
FROM timescale:pg13-latest as build

# Install required packages
RUN apt-get update \
  && apt-get install -y libssl-dev wget unzip cmake postgresql-server-dev-13 pkg-config

# Create driver installation directory
RUN mkdir /opt/drivers
ENV JSONC_INSTALL_DIR=/opt/drivers/json-c
ENV MONGOC_INSTALL_DIR=/opt/drivers/mongo-c

# Install Mongo FDW
ENV PKG_CONFIG_PATH=/tmp/mongo_fdw_source/mongo_fdw-REL-5_5_0/mongo-c-driver/src/libmongoc/src:/tmp/mongo_fdw_source/mongo_fdw-REL-5_5_0/mongo-c-driver/src/libbson/src
RUN mkdir /tmp/mongo_fdw_source \
  && cd /tmp/mongo_fdw_source \
  && wget https://github.com/EnterpriseDB/mongo_fdw/archive/refs/tags/REL-5_5_0.zip \
  && unzip REL-5_5_0.zip \
  && cd mongo_fdw-REL-5_5_0 \
  && ./autogen.sh --with-master \
  && make \
  && make install

FROM timescale:pg13-latest

# Copy installed files over
COPY --from=build /usr/share/postgresql /usr/share/postgresql
COPY --from=build /usr/lib/postgresql /usr/lib/postgresql
COPY --from=build /opt/drivers /opt/drivers

# Create driver ld config
RUN echo "/opt/drivers/mongo-c/lib" > /etc/ld.so.conf.d/custom_drivers.conf \
 && ldconfig