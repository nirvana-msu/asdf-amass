#!/usr/bin/env bash

getOs() {
    WIN=( "msys" "cygwin" "win32" )
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ " ${WIN[@]} " =~ " $OSTYPE " ]]; then
        echo "windows"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "freebsd"
    else
        echo "Unsupported platform!"
        exit 1
    fi
}

getPlatform() {
    # Releases seen so far in GitHub contained amd64 | i386 | 386, hence using "i?" regex
    if [[ `getconf LONG_BIT` = "64" ]]; then
        arch="amd64"
    else
        arch="i?386"
    fi
    echo "$(getOs)_${arch}"
}

queryReleases() {
    releases_path=https://api.github.com/repos/OWASP/Amass/releases
    cmd="curl -sS"
    if [[ -n "${GITHUB_API_TOKEN}" ]]; then
        cmd="${cmd} -H 'Authorization: token ${GITHUB_API_TOKEN}'"
    fi
    eval "${cmd} ${releases_path}"
}
