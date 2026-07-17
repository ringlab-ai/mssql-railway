#!/usr/bin/env bash
#
# Boot as root, give the (root-owned) Railway volume to the mssql user, then hand
# off to the stock image's launcher as that user. The stock entrypoint is
# /opt/mssql/bin/launch_sqlservr.sh with /opt/mssql/bin/sqlservr as its argument;
# running sqlservr directly skips required setup. gosu drops privileges cleanly,
# preserving the mssql user's supplementary groups.
set -euo pipefail

chown -R mssql:root /var/opt/mssql

exec gosu mssql /opt/mssql/bin/launch_sqlservr.sh /opt/mssql/bin/sqlservr
