#!/bin/sh
if [ "$(go env GOARCH)" = "arm64" ]; then
    echo "WARNING: goboring assertion currently not support on arm - skipping..."
    exit 0
fi
if [ -z "$*" ]; then
    echo "usage: $0 file1 [file2 ... fileN]"
fi
for exe in "${@}"; do
    if [ ! -x "${exe}" ]; then
        echo "$exe: file not found" >&2
        exit 1
    fi
    if [ $(go tool nm ${exe} | grep Cfunc__goboringcrypto | wc -l) -eq 0 ]; then
        echo "${exe}: missing goboring symbols" >&2
        exit 1
    fi
done
