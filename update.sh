#!/usr/bin/env bash

set -e

if [ -z "$1" ]
then
    echo "$0 [version]" >&2
    exit 1
fi
VERSION="$1"

curl \
    -o SHA256SUMS \
    "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION}/SHA256SUMS"

dch \
    --newversion "1:${VERSION}" \
    --distribution jammy \
    "https://www.mozilla.org/en-US/firefox/${VERSION}/releasenotes/"
