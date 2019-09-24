#!/usr/bin/env sh

# SYNOPSIS

# DESCRIPTION

# REQUIREMENTS
# - wget
# - p7zip
# - Qt Installer Framework 3.0 or higher
# - UPX (Optional)

# Name of the installer that will be generated. 
INSTALLER_NAME='dist/moorhuhn-bundle-installer.run'

# Variable that captures parent directory of current script, do not modify.
RELATIVE_PATH=$(dirname ${0})

# If sources.ini file is not found, then lets generate it by copying sample.
if [[ ! -f "${RELATIVE_PATH}/sources.ini" ]]; then
    cp "${RELATIVE_PATH}/sources.ini" "${RELATIVE_PATH}/sources.ini"
fi

# Function that reads sources.ini file and return values from it.
GET_VALUE_FROM_DOT_INIT () {
    echo $(awk -F '=' '/'${1}'/ {print $2}' "${RELATIVE_PATH}/sources.ini")
}

MOORHUHNJAGD_URL=$(GET_VALUE_FROM_DOT_INIT moorhuhnjagd_url)
echo "${MOORHUHNJAGD_URL}"

