#!/usr/bin/env bash
#
# Boot as root, give the (root-owned) Railway volume to the mssql user, then run
# the engine as that user — SQL Server 2022 refuses to run as root but needs to
# own /var/opt/mssql. `chroot --userspec` (coreutils, always present) drops
# privileges without the /proc fd scan that makes setpriv/su hang under a
# container's huge RLIMIT_NOFILE.
set -euo pipefail

chown -R 10001:0 /var/opt/mssql

exec chroot --userspec=10001:0 / /opt/mssql/bin/sqlservr
