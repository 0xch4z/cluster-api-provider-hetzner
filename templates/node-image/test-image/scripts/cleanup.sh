#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo '--> Starting Cleanup.'
# Ensure we don't leave SSH host keys
rm -rf /etc/ssh/ssh_host_*

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i -e '/^\(#\|\)SELINUX/s/^.*$/SELINUX=disabled/' /etc/selinux/config

# Performs cleanup of temporary files for the currently enabled repositories.
dnf -y autoremove
dnf -y clean all