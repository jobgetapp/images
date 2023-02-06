# Install and configure TimescaleDB on the official Debian-based Postgres image
ARG POSTGRES_MAJOR='13'
ARG TIMESCALEDB_VERSION='2.9.2'

FROM postgres:${POSTGRES_MAJOR} AS build

# Install required packages
RUN apt-get update \
  && apt-get install -y build-essential git cmake postgresql-server-dev-${POSTGRES_MAJOR} libkrb5-dev

# Install postgres files
RUN git clone https://github.com/timescale/timescaledb \
  && cd timescaledb \
  && git checkout ${TIMESCALEDB_VERSION} \
  && ./bootstrap \
  && cd ./build \
  && make \
  && make install

FROM postgres:${POSTGRES_MAJOR}

# Copy installed files over

COPY --from=build /usr/lib/postgresql /usr/lib/postgresql
COPY --from=build /usr/share/postgresql /usr/share/postgresql

# Edit postgres config to preload TimescaleDB
RUN sed -r -i "s/^#(shared_preload_libraries\s*=\s*)''/\1'timescaledb'/" /usr/share/postgresql/postgresql.conf.sample

# Create TimescaleDB extension on startup
RUN echo "psql -U postgres -d template1 -c 'CREATE EXTENSION timescaledb;'" > /docker-entrypoint-initdb.d/timescaledb.sh
