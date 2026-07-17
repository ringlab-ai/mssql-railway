#!/usr/bin/env bash
#
# Boot as root, give the (root-owned) Railway volume to the mssql user, then hand
# off to the stock image's real launcher as that user. The stock image's
# entrypoint is /opt/mssql/bin/launch_sqlservr.sh (a wrapper that does required
# setup) with /opt/mssql/bin/sqlservr as its argument — running sqlservr
# directly skips that setup and crashes the engine. gosu drops privileges
# cleanly (preserving the mssql user's supplementary groups).
set -euo pipefail

chown -R mssql:root /var/opt/mssql

exec gosu mssql /opt/mssql/bin/launch_sqlservr.sh /opt/mssql/bin/sqlservr
