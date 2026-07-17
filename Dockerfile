# SQL Server 2022 for Railway with a persistent volume.
#
# SQL Server 2022 runs as the non-root `mssql` user (uid 10001) and REFUSES to
# run as root. Railway mounts volumes root-owned, so uid 10001 can't write
# /var/opt/mssql (PAL init Error: 101). RAILWAY_RUN_UID only sets the process
# uid; it does not chown the volume. So entrypoint.sh boots as root (set
# RAILWAY_RUN_UID=0 on the service), chowns the data dir to the mssql user, then
# drops to that user with `gosu` — which preserves the user's supplementary
# groups (unlike `chroot --userspec`/`setpriv`, which clear them and make the
# engine crash on startup).
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
