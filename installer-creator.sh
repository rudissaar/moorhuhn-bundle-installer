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

# Manual binary fallbacks.
WGET_FALLBACK=''

# Variable that captures parent directory of current script, do not modify.
RELATIVE_PATH=$(dirname ${0})

# If sources.ini file is not found, then lets generate it by copying sample.
if [[ ! -f "${RELATIVE_PATH}/sources.ini" ]]; then
    cp "${RELATIVE_PATH}/sources.ini.sample" "${RELATIVE_PATH}/sources.ini"
fi

# Function that reads sources.ini file and return values from it.
GET_VALUE_FROM_DOT_INIT () {
    echo $(awk -F '=' '/'${1}'/ {print $2}' "${RELATIVE_PATH}/sources.ini")
}

MOORHUHNJAGD_ZIP_URL=$(GET_VALUE_FROM_DOT_INIT moorhuhnjagd_zip_url)

IMPORT_MOORHUHNJAGD () {
    if [[ -z "${MOORHUHNJAGD_ZIP_URL}" ]]; then
        echo '> Source for Moorhuhjagd zip archive is unspecified.'
        echo '> Skipping.'
        return
    fi

    MOORHUHNJAGD_ARCHIVE_PATH="${RELATIVE_PATH}/tmp/moorhuhnjagd.zip"

    if [[ ! -f "${MOORHUHNJAGD_ARCHIVE_PATH}" ]]; then
        "${WGET}" "${MOORHUHNJAGD_ZIP_URL}" -O "${MOORHUHNJAGD_ARCHIVE_PATH}"
    fi
}

# Capturing wget command.
which wget 1> /dev/null 2>&1

if [[ "${?}" != '0' ]]; then
    if [[ ! -z "${WGET_FALLBACK}" ]]; then
        WGET="${WGET_FALLBACK}"
    else
        echo "> Unable to find wget from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    WGET="$(which wget)"
fi

IMPORT_MOORHUHNJAGD

