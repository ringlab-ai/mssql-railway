# SQL Server for Railway with a persistent volume.
#
# SQL Server 2019+ runs the engine as the non-root `mssql` user (uid 10001),
# which cannot write Railway's root-owned volume at /var/opt/mssql, and refuses
# to run as root — an intractable combination on Railway. SQL Server 2017 runs
# the engine as ROOT (the non-root user arrived in 2019), so it writes the
# root-owned volume directly. No chown/gosu wrapper needed.
#
# Runtime config (ACCEPT_EULA, MSSQL_PID, MSSQL_SA_PASSWORD, MSSQL_MEMORY_LIMIT_MB)
# comes from the Railway service environment, not this image.
FROM mcr.microsoft.com/mssql/server:2017-latest
