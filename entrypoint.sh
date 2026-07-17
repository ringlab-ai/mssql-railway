#!/usr/bin/env bash
#
# Boot as root, give the (root-owned) Railway volume to the mssql user, then run
# the engine as that user via gosu. gosu sets the user's uid/gid AND
# supplementary groups before exec — a clean privilege drop that (unlike
# chroot --userspec / setpriv) does not make SQL Server crash on startup.
set -euo pipefail

chown -R mssql:root /var/opt/mssql

exec gosu mssql /opt/mssql/bin/sqlservr
