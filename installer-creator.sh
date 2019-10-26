#!/usr/bin/env sh

# SYNOPSIS

# DESCRIPTION

# REQUIREMENTS
# - wget
# - p7zip
# - Qt Installer Framework 3.0 or higher
# - UPX (Optional)

# Tweakable options.
COMPRESS_INSTALLER_IF_POSSIBLE=1

# Manual binary fallbacks.
WGET_FALLBACK=''
P7ZIP_FALLBACK=''
BINARYCREATOR_FALLBACK=''
UPX_FALLBACK=''

# Variable that captures parent directory of current script, do not modify.
RELATIVE_PATH=$(dirname ${0})

# Name of the installer that will be generated.
INSTALLER_NAME="${RELATIVE_PATH}/dist/moorhuhn-bundle-installer.run"

# If sources.ini file is not found, then lets generate it by copying sample.
if [ ! -f "${RELATIVE_PATH}/sources.ini" ]; then
    cp "${RELATIVE_PATH}/sources.ini.sample" "${RELATIVE_PATH}/sources.ini"
fi

# Function that reads sources.ini file and return values from it.
GET_VALUE_FROM_INI_FILE () {
    echo $(awk -F '=' '/'${1}'/ {print $2}' "${RELATIVE_PATH}/sources.ini")
}

MOORHUHNJAGD_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhnjagd_zip_url)
MOORHUHN2_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhn2_zip_url)
MOORHUHNWINTER_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhnwinter_zip_url)
MOORHUHN3_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhn3_zip_url)

CLEAR_DATA_DIRS () {
    for DIR_TO_CLEAR in $(find "${RELATIVE_PATH}" -type d -name 'data')
    do
        rm -r "${DIR_TO_CLEAR}/"*
    done
}

IMPORT_MOORHUHNJAGD () {
    if [ -z "${MOORHUHNJAGD_ZIP_URL}" ]; then
        echo '> Source for Moorhuhnjagd zip archive is unspecified.'
        echo '> Skipping.'
        return
    fi

    MOORHUHNJAGD_ARCHIVE_PATH="${RELATIVE_PATH}/tmp/moorhuhnjagd.zip"
    MOORHUHNJAGD_DATA_DIR="${RELATIVE_PATH}/packages/eu.murda.moorhuhn.moorhuhnjagd/data/moorhuhnjagd"

    if [ ! -f "${MOORHUHNJAGD_ARCHIVE_PATH}" ]; then
        "${WGET}" "${MOORHUHNJAGD_ZIP_URL}" -O "${MOORHUHNJAGD_ARCHIVE_PATH}"
    fi

    if [ -f "${MOORHUHNJAGD_ARCHIVE_PATH}" ]; then
        "${P7ZIP}" x -aoa "-o${MOORHUHNJAGD_DATA_DIR}" "${MOORHUHNJAGD_ARCHIVE_PATH}"
    fi
}

IMPORT_MOORHUHN2 () {
    if [ -z "${MOORHUHN2_ZIP_URL}" ]; then
        echo '> Source for Moorhuhn 2 zip archive is unspecified.'
        echo '> Skipping.'
        return
    fi

    MOORHUHN2_ARCHIVE_PATH="${RELATIVE_PATH}/tmp/moorhuhn2.zip"
    MOORHUHN2_DATA_DIR="${RELATIVE_PATH}/packages/eu.murda.moorhuhn.moorhuhn2/data/moorhuhn2"

    if [ ! -f "${MOORHUHN2_ARCHIVE_PATH}" ]; then
        "${WGET}" "${MOORHUHN2_ZIP_URL}" -O "${MOORHUHN2_ARCHIVE_PATH}"
    fi

    if [ -f "${MOORHUHN2_ARCHIVE_PATH}" ]; then
        "${P7ZIP}" x -aoa "-o${MOORHUHN2_DATA_DIR}" "${MOORHUHN2_ARCHIVE_PATH}"
    fi
}

IMPORT_MOORHUHNWINTER () {
    if [ -z "${MOORHUHNWINTER_ZIP_URL}" ]; then
        echo '> Source for Moorhuhn Winter zip archive is unspecified.'
        echo '> Skipping.'
        return
    fi

    MOORHUHNWINTER_ARCHIVE_PATH="${RELATIVE_PATH}/tmp/moorhuhnwinter.zip"
    MOORHUHNWINTER_DATA_DIR="${RELATIVE_PATH}/packages/eu.murda.moorhuhn.moorhuhnwinter/data/moorhuhnwinter"

    if [ ! -f "${MOORHUHNWINTER_ARCHIVE_PATH}" ]; then
        "${WGET}" "${MOORHUHNWINTER_ZIP_URL}" -O "${MOORHUHNWINTER_ARCHIVE_PATH}"
    fi

    if [ -f "${MOORHUHNWINTER_ARCHIVE_PATH}" ]; then
        "${P7ZIP}" x -aoa "-o${MOORHUHNWINTER_DATA_DIR}" "${MOORHUHNWINTER_ARCHIVE_PATH}"
    fi
}

IMPORT_MOORHUHN3 () {
    if [ -z "${MOORHUHN3_ZIP_URL}" ]; then
        echo '> Source for Moorhuhn 3 zip archive is unspecified.'
        echo '> Skipping.'
        return
    fi

    MOORHUHN3_ARCHIVE_PATH="${RELATIVE_PATH}/tmp/moorhuhn3.zip"
    MOORHUHN3_DATA_DIR="${RELATIVE_PATH}/packages/eu.murda.moorhuhn.moorhuhn3/data/moorhuhn3"

    if [ ! -f "${MOORHUHN3_ARCHIVE_PATH}" ]; then
        "${WGET}" "${MOORHUHN3_ZIP_URL}" -O "${MOORHUHN3_ARCHIVE_PATH}"
    fi

    if [ -f "${MOORHUHN3_ARCHIVE_PATH}" ]; then
        "${P7ZIP}" x -aoa "-o${MOORHUHN3_DATA_DIR}" "${MOORHUHN3_ARCHIVE_PATH}"
    fi
}

BUILD_INSTALLER () {
    echo "> Creating installer."

    COMMAND="${BINARYCREATOR}"
    COMMAND="${COMMAND} -c ${RELATIVE_PATH}/config/config.xml"
    COMMAND="${COMMAND} -p ${RELATIVE_PATH}/packages"
    COMMAND="${COMMAND} ${INSTALLER_NAME}"

    eval "${COMMAND}"
}

COMPRESS_INSTALLER () {
    if [ "${COMPRESS_INSTALLER_IF_POSSIBLE}" = '1' ]; then
        if [ -f "${INSTALLER_NAME}" ]; then
            echo "> Compressing Installer to save disk space."
            "${UPX}" -9 "${INSTALLER_NAME}"
        fi
    fi
}

# Capturing wget command.
which wget 1> /dev/null 2>&1

if [ "${?}" != '0' ]; then
    if [ ! -z "${WGET_FALLBACK}" ]; then
        WGET="${WGET_FALLBACK}"
    else
        echo "> Unable to find wget from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    WGET="$(which wget)"
fi

# Capturing 7z command.
which 7z 1> /dev/null 2>&1

if [ "${?}" != '0' ]; then
    if [ ! -z "${P7ZIP_FALLBACK}" ]; then
        P7ZIP="${P7ZIP_FALLBACK}"
    else
        echo "> Unable to find 7z from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    P7ZIP="$(which 7z)"
fi

# Capturing binarycreator command.
which binarycreator 1> /dev/null 2>&1

if [ "${?}" != '0' ]; then
    if [ ! -z "${BINARYCREATOR_FALLBACK}" ]; then
        BINARYCREATOR="${BINARYCREATOR_FALLBACK_FALLBACK}"
    else
        echo "> Unable to find binarycreator from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    BINARYCREATOR="$(which binarycreator)"
fi

# Capturing upx command.
which upx 1> /dev/null 2>&1

if [ "${?}" != '0' ]; then
    if [ ! -z "${UPX_FALLBACK}" ]; then
        UPX="${UPX_FALLBACK}"
        echo "> UPX binary found at: '${UPX}'"
    else
        if [ "${COMPRESS_INSTALLER_IF_POSSIBLE}" = '1' ]; then
            echo "> Unable to find upx from your environment's PATH variable."
            echo '> Compressing the installer will be skipped.'
        fi

        COMPRESS_INSTALLER_IF_POSSIBLE=0
    fi
else
    UPX="$(which upx)"
    echo "> UPX binary found at: '${UPX}'"
fi

CLEAR_DATA_DIRS
IMPORT_MOORHUHNJAGD
IMPORT_MOORHUHN2
IMPORT_MOORHUHNWINTER
BUILD_INSTALLER
COMPRESS_INSTALLER
CLEAR_DATA_DIRS

