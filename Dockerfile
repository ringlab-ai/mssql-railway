# SQL Server 2017 for Railway with a persistent volume.
#
# SQL Server 2019+ runs the engine as the non-root `mssql` user and crashes with
# its data dir on a Railway volume (root-owned mount; refuses root; engine
# core-dumps after init even with a chown wrapper). SQL Server 2017 runs the
# engine as ROOT, so it writes the root-owned volume directly with no wrapper.
#
# Runtime config (ACCEPT_EULA, MSSQL_PID, MSSQL_SA_PASSWORD, MSSQL_MEMORY_LIMIT_MB)
# comes from the Railway service environment, not this image.
FROM mcr.microsoft.com/mssql/server:2017-latest
