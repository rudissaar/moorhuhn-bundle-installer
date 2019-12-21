#!/usr/bin/env sh

# SYNOPSIS
# Runs tasks to generate Moorhuhn bundle installer for UNIX-like operating systems.

# DESCRIPTION
# This scripts tries to package multiple Moorhuhn games to an installer that is compatible with UNIX-like opertaing system.

# REQUIREMENTS
# - wget
# - awk
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
RELATIVE_PATH=$(dirname "${0}")

# Name of the installer that will be generated.
INSTALLER_NAME="${RELATIVE_PATH}/dist/moorhuhn-bundle-installer.run"

# Variable that keeps track of how many real packages will installer include, do not modify.
PACKAGE_COUNTER=0

# If settings.ini file is not found, then lets generate it by copying sample.
if [ ! -f "${RELATIVE_PATH}/settings.ini" ]; then
    cp "${RELATIVE_PATH}/settings.ini.sample" "${RELATIVE_PATH}/settings.ini"
fi

# Function that reads settings.ini file and return values from it.
GET_VALUE_FROM_INI_FILE () {
    awk -F '=' '/'"${1}"'/ {print $2}' "${RELATIVE_PATH}"/settings.ini
}

# Reading options from settings.ini file.
INI_COMPRESS_INSTALLER_IF_POSSIBLE=$(GET_VALUE_FROM_INI_FILE compress_installer_if_possible)
if [ -n "${INI_COMPRESS_INSTALLER_IF_POSSIBLE}" ]; then
    COMPRESS_INSTALLER_IF_POSSIBLE=${INI_COMPRESS_INSTALLER_IF_POSSIBLE}
fi

# Reading fallbacks from settings.ini file.
INI_WGET_FALLBACK=$(GET_VALUE_FROM_INI_FILE wget_fallback)
if [ -n "${INI_WGET_FALLBACK}" ]; then
    WGET_FALLBACK=${INI_WGET_FALLBACK}
fi

INI_P7ZIP_FALLBACK=$(GET_VALUE_FROM_INI_FILE p7zip_fallback)
if [ -n "${INI_P7ZIP_FALLBACK}" ]; then
    P7ZIP_FALLBACK=${INI_P7ZIP_FALLBACK}
fi

INI_BINARYCREATOR_FALLBACK=$(GET_VALUE_FROM_INI_FILE binarycreator_fallback)
if [ -n "${INI_BINARYCREATOR_FALLBACK}" ]; then
    BINARYCREATOR_FALLBACK=${INI_BINARYCREATOR_FALLBACK}
fi

INI_UPX_FALLBACK=$(GET_VALUE_FROM_INI_FILE upx_fallback)
if [ -n "${INI_UPX_FALLBACK}" ]; then
    UPX_FALLBACK=${INI_UPX_FALLBACK}
fi

# Reading settings from settings.ini file.
MOORHUHNJAGD_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhnjagd_zip_url)
MOORHUHN2_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhn2_zip_url)
MOORHUHNWINTER_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhnwinter_zip_url)
MOORHUHN3_ZIP_URL=$(GET_VALUE_FROM_INI_FILE moorhuhn3_zip_url)

CLEAR_DATA_DIRS () {
    BASENAME=$(basename "${0}")
    TMP_FILE=$(mktemp /tmp/"${BASENAME}".XXXXXX)
    find "${RELATIVE_PATH}" -type d -name 'data' > "${TMP_FILE}"
    while IFS= read -r DIR_TO_CLEAR
    do
        rm -rf "${DIR_TO_CLEAR:?}/"*
    done < "${TMP_FILE}"
    rm "${TMP_FILE}"
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

    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
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

    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
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

    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
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

    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
}

BUILD_INSTALLER () {
    if [ ${PACKAGE_COUNTER} -lt 1 ]; then
        echo "> Skipping creating installer, because it's not including any packages."
        return 1
    fi

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
if ! command -v wget 1> /dev/null 2>&1; then
    if [ -n "${WGET_FALLBACK}" ]; then
        WGET="${WGET_FALLBACK}"
    else
        echo "> Unable to find wget from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    WGET="$(command -v wget 2> /dev/null)"
fi

# Capturing 7z command.
if ! command -v 7z 1> /dev/null 2>&1; then
    if [ -n "${P7ZIP_FALLBACK}" ]; then
        P7ZIP="${P7ZIP_FALLBACK}"
    else
        echo "> Unable to find 7z from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    P7ZIP="$(command -v 7z 2> /dev/null)"
fi

# Capturing binarycreator command.
if ! command -v binarycreator 1> /dev/null 2>&1; then
    if [ -n "${BINARYCREATOR_FALLBACK}" ]; then
        BINARYCREATOR="${BINARYCREATOR_FALLBACK_FALLBACK}"
    else
        echo "> Unable to find binarycreator from your environment's PATH variable."
        echo '> Aborting.'
        exit 1
    fi
else
    BINARYCREATOR="$(command -v binarycreator 2> /dev/null)"
fi

# Capturing upx command.
if ! command -v upx 1> /dev/null 2>&1; then
    if [ -n "${UPX_FALLBACK}" ]; then
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
    UPX="$(command -v upx 2> /dev/null)"
    echo "> UPX binary found at: '${UPX}'"
fi

CLEAR_DATA_DIRS
IMPORT_MOORHUHNJAGD
IMPORT_MOORHUHN2
IMPORT_MOORHUHNWINTER
IMPORT_MOORHUHN3
if BUILD_INSTALLER; then
    COMPRESS_INSTALLER
fi
CLEAR_DATA_DIRS

