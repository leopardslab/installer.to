#!/bin/bash

set -e
if [[ -z $DUNNER_VERSION ]]; then
    VERSION='latest'
else
    VERSION="v${DUNNER_VERSION}"
fi

RELEASES_URL="https://github.com/leopardslab/dunner/releases"
REPO_URL="https://github.com/leopardslab/dunner"
API_URL="https://api.github.com/repos/leopardslab/dunner/releases"

initVersion() {
    # Resolve latest version
    if [[ $VERSION == 'latest' ]]; then
        VERSION=$(curl -s ${API_URL}/latest | grep -wo '"tag_name":\ .*' | sed s/'"tag_name":\ "'//g | sed s/'",'//g)
    fi
}

gitClone() {
    # Cloning repository from GitHub
    git clone $REPO_URL $TARGET_DIR
    cd $TARGET_DIR
    git config --local advice.detachedHead false
    if [[ $VERSION == 'current' ]]; then
        echo "Checking out from master branch"
    elif [[ $VERSION == 'latest' ]]; then
        echo "Checking out latest version of dunner"
        git checkout tags/$(git describe --tags | sed s/''//g)
    else
        echo "Checking out dunner repo with version $VERSION..."
        git checkout tags/$VERSION
    fi
    echo
}

installFromSource() {
    echo
    # Installing dep...
    if [[ -z $(which dep) ]]; then
        echo "Installing dep..."
        curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
    fi

    TARGET_DIR="${GOPATH}/src/github.com/leopardslab/dunner"
    mkdir -p $TARGET_DIR
    if [[ $(which git) ]]; then
        gitClone
    else
        echo "'git' not found. Please install git"
        exit 1
    fi

    cd $TARGET_DIR
    if [[ -z $(which dep) ]]; then
        echo "Command 'dep' not found. Please install 'dep'"
        exit 1
    else
        echo "Installing dependencies using 'dep'..."
        dep ensure
        echo "Installing dunner..."
        go install # TODO -- Flags
    fi
}

raiseVersionError() {
    echo "Could not find version $VERSION for dunner."
    exit 1
}

promptSrcInstall() {
    # Prompt user to confirm to whether download the source
    # and install using go.
    read -p "Install from source code?[y/N] " -n 1 -r
    echo
    if [[ $(echo $REPLY | grep -o '^[Yy]$') ]]; then
        installFromSource
    else
        echo "Dunner not installed; Exited!"
        exit 0
    fi
}

binInstall() {
    # Binary installation from the release page.
    ARCH=$(uname -m)
    OS=$(uname -s)

    ver=$(echo $VERSION | sed s/v//g)
    release=$(curl -s ${API_URL} | grep -i "\"name\": \"dunner_${ver}_${OS}_${ARCH}.tar.gz\",")
    if [[ -z $release ]]; then
        echo "OS $OS with $ARCH architecture is not supported corresponding to version $VERSION"
        echo
        promptSrcInstall
    elif [[ $(which tar) ]]; then
        downloadUrl="${RELEASES_URL}/download/${VERSION}/dunner_${ver}_${OS}_${ARCH}.tar.gz"
        echo "Downloading dunner_${ver}_${OS}_${ARCH}..."
        wget -O "dunner.tar.gz" $downloadUrl 2>/dev/null || curl -o "dunner.tar.gz" -L $downloadUrl
        if [[ $OS == 'Linux' || $OS == 'Darwin' ]]; then
            tar -xf dunner.tar.gz
            cp dunner /usr/bin/
        fi
    else
        echo "'tar' command not found..."
        echo
        promptSrcInstall
    fi
}

initInstall() {
    ARCH=$(uname -m)
    if [[ $ARCH == 'i386' ]]; then
        ARCH="386"
    elif [[ $ARCH == 'x86_64' ]]; then
        ARCH="amd64"
    fi
    if [[ $(which dpkg) ]]; then
        pkg=$(curl -s ${API_URL}/tags/${VERSION} | grep -io "\"name\": \"dunner_${ARCH}\.deb" | sed s/'"name": "'//g)
        if [[ -z $pkg ]]; then
            echo "Deb package not found for $ARCH for version $VERSION"
        else
            downloadUrl="${RELEASES_URL}/download/${VERSION}/${pkg}"
            echo "Downloading ${pkg} as dunner.deb..."
            wget -O "dunner.deb" $downloadUrl 2>/dev/null || curl -o "dunner.deb" -L $downloadUrl
            echo "Installing from dunner.deb"
            dpkg -i dunner.deb
            rm dunner.deb
            exit 0
        fi
    fi

    if [[ $(which rpm) ]]; then
        pkg=$(curl -s ${API_URL}/tags/${VERSION} | grep -io "\"name\": \"dunner_${ARCH}\.rpm" | sed s/'"name": "'//g)
        if [[ -z $pkg ]]; then
            echo "RPM package not found for $OS-$ARCH for version $VERSION"
        else
            downloadUrl="${RELEASES_URL}/download/${VERSION}/${pkg}"
            echo "Downloading ${pkg} as dunner.rpm..."
            wget -O "dunner.rpm" $downloadUrl 2>/dev/null || curl -o "dunner.rpm" -L $downloadUrl
            echo "Installing from dunner.rpm"
            rpm -ivh dunner.rpm
            rm dunner.rpm
            exit 0
        fi
    fi
    binInstall
}

if [[ $(which dunner) ]]; then
    echo "dunner already installed at $(which dunner)"
    exit 1
fi

if [[ -z $(which docker) ]]; then
    echo "Docker not found. Please install docker to use dunner"
    exit 1
fi

echoConstants() {
    echo $API_URL
    echo $RELEASES_URL
    echo $REPO_URL
}
# echoConstants
initVersion
initInstall
