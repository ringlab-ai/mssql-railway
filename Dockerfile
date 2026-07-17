# SQL Server 2022 for Railway with a persistent volume.
#
# SQL Server 2022 runs as the non-root `mssql` user (uid 10001) and REFUSES to
# run as root ("master database file is owned by root ... fatal error"). But
# Railway mounts persistent volumes root-owned, so uid 10001 can't write
# /var/opt/mssql and the engine fails PAL init (Error: 101). Neither UID works
# alone, and RAILWAY_RUN_UID only sets the process uid — it does not chown the
# volume.
#
# entrypoint.sh reconciles this the way the SQL Server community does: boot as
# root, chown the data directory to uid 10001, then run the engine as uid 10001.
# Set RAILWAY_RUN_UID=0 on the service so the entrypoint starts as root.
#
# Runtime config (ACCEPT_EULA, MSSQL_PID, MSSQL_SA_PASSWORD, MSSQL_MEMORY_LIMIT_MB)
# comes from the Railway service environment, not this image.
FROM mcr.microsoft.com/mssql/server:2022-latest
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
