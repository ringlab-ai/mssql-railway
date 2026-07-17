# SQL Server 2022 for Railway with a persistent volume.
#
# SQL Server 2022 runs the engine as the non-root `mssql` user (uid 10001) and
# refuses to run as root, but Railway mounts volumes root-owned so uid 10001
# can't write /var/opt/mssql. entrypoint.sh boots as root (set RAILWAY_RUN_UID=0
# on the service), chowns the data dir to the mssql user, then hands off to the
# stock launcher (launch_sqlservr.sh) as that user via gosu.
#
# Runtime config (ACCEPT_EULA, MSSQL_PID, MSSQL_SA_PASSWORD, MSSQL_MEMORY_LIMIT_MB)
# comes from the Railway service environment, not this image.
FROM mcr.microsoft.com/mssql/server:2022-latest
USER root
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
