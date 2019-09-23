#!/usr/bin/env sh
# Script that installs some of the native dependencies on Fedora GNU/Linux.

# You need root permissions to run this script.
if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

# Install packages.
dnf install -y \
    gawk \
    p7zip \
    upx \
    wget

