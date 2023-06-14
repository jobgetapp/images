# Install and configure TimescaleDB on the official Debian-based Postgres image
ARG JG_PG_VERSION=13
FROM postgres:${JG_PG_VERSION} AS build

ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/cargo PATH=/opt/cargo/bin:$PATH
ARG JG_PG_VERSION
ARG JG_CARGO_VERSION=0.7.1
ARG JG_TIMESCALE_VERSION=2.11.0
ARG JG_TIMESCALE_TOOLKIT_VERSION=1.16.0

# Install required packages
RUN apt-get update \
  && apt-get install -y \
  git \
  gcc \
  make \
  curl \
  cmake \
  clang \
  pkg-config \
  libssl-dev \
  libkrb5-dev \
  build-essential \
  postgresql-server-dev-${JG_PG_VERSION}

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN cargo install --version "=${JG_CARGO_VERSION}" --force cargo-pgx

# Create postgres build directory
RUN mkdir /pg-build \
  && chown postgres:postgres /pg-build \
  && chown postgres:postgres -R /usr/share/postgresql \
  && chown postgres:postgres -R /usr/lib/postgresql \
  && chown postgres:postgres -R /opt/cargo

# Init postgres
USER postgres
RUN cd /pg-build && \
  cargo pgx init --pg${JG_PG_VERSION} pg_config

# Install timescaledb
RUN cd /pg-build \ 
  && git clone https://github.com/timescale/timescaledb \
  && cd timescaledb \
  && git checkout ${JG_TIMESCALE_VERSION} \
  && ./bootstrap \
  && cd ./build \
  && make \
  && make install

# Install timescaledb-toolkit
RUN cd /pg-build \
  && git clone https://github.com/timescale/timescaledb-toolkit \
  && cd timescaledb-toolkit/extension \
  && git checkout ${JG_TIMESCALE_TOOLKIT_VERSION} \
  && cargo pgx install --release \
  && cargo run --manifest-path ../tools/post-install/Cargo.toml -- pg_config

ARG JG_PG_VERSION
FROM postgres:${JG_PG_VERSION}

# Copy installed files over
COPY --from=build /usr/lib/postgresql /usr/lib/postgresql
COPY --from=build /usr/share/postgresql /usr/share/postgresql

# Configure timescaledb
RUN sed -r -i "s/^#(shared_preload_libraries\s*=\s*)''/\1'timescaledb'/" /usr/share/postgresql/postgresql.conf.sample \
  && echo "psql -U postgres -d template1 -c 'CREATE EXTENSION timescaledb;'" > /docker-entrypoint-initdb.d/timescaledb.sh \
  && echo "psql -U postgres -d template1 -c 'CREATE EXTENSION timescaledb_toolkit;'" >> /docker-entrypoint-initdb.d/timescaledb.sh
