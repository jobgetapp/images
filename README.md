# Jobget Images

Docker images used by JobGet.

## Images

| Image                            | Registry path                             | Description                                                                                          |   |
|----------------------------------|-------------------------------------------|------------------------------------------------------------------------------------------------------|---|
| `timescale:pg13-latest`          | `ghcr.io/jobgetapp/timescale:pg13-latest` | Timescale v2.9.2 installed on the official `postgres:13` image (running Debian)                      |   |
| `timescale-mongofdw-pg13-latest` | `ghcr.io/jobgetapp/timescale:pg13-latest` | Mongo FDW (https://github.com/EnterpriseDB/mongo_fdw) installed on `jobgetapp/timescale:pg13-latest` |   |
|                                  |                                           |                                                                                                      |   |